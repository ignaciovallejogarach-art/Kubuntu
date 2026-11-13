#!/usr/bin/env python3
"""Imprime en JSON el uso restante de Claude y Codex. Solo lectura local + 1 GET a api.anthropic.com."""
import json, os, sys, time, glob, urllib.request
from datetime import datetime, timezone

HOME = os.path.expanduser("~")
CACHE = os.path.join(HOME, ".cache", "aiusage-claude.json")
CACHE_TTL = 120  # s: evita saturar el endpoint


def label(minutes):
    if minutes is None:
        return "?"
    if minutes % 1440 == 0:
        return f"{minutes // 1440}d"
    return f"{round(minutes / 60)}h"


def parse_iso(s):
    return datetime.fromisoformat(s.replace("Z", "+00:00")).timestamp()


# ---------- Claude ----------
def claude():
    try:
        with open(os.path.join(HOME, ".claude", ".credentials.json")) as f:
            tok = json.load(f)["claudeAiOauth"]["accessToken"]
    except Exception:
        return {"ok": False, "err": "sin sesión de Claude Code"}

    cached = None
    try:
        with open(CACHE) as f:
            cached = json.load(f)
        if time.time() - cached["t"] < CACHE_TTL:
            return build_claude(cached["d"])
    except Exception:
        pass

    try:
        req = urllib.request.Request(
            "https://api.anthropic.com/api/oauth/usage",
            headers={
                "Authorization": f"Bearer {tok}",
                "anthropic-beta": "oauth-2025-04-20",
                "User-Agent": "claude-code/aiusage-widget",
            },
        )
        with urllib.request.urlopen(req, timeout=10) as r:
            d = json.load(r)
        os.makedirs(os.path.dirname(CACHE), exist_ok=True)
        with open(CACHE, "w") as f:
            json.dump({"t": time.time(), "d": d}, f)
        return build_claude(d)
    except Exception as e:
        if cached:  # datos antiguos mejor que nada
            out = build_claude(cached["d"])
            out["stale"] = True
            return out
        code = getattr(e, "code", None)
        return {"ok": False, "err": "token caducado (abre Claude Code)" if code == 401 else "sin conexión"}


def build_claude(d):
    wins = []
    for key, lab in (("five_hour", "5h"), ("seven_day", "7d")):
        w = d.get(key)
        if not w or w.get("utilization") is None:
            continue
        resets = parse_iso(w["resets_at"]) if w.get("resets_at") else None
        left = max(0.0, 100.0 - float(w["utilization"]))
        secs = max(0, int(resets - time.time())) if resets else None
        if resets and resets < time.time():
            left, secs = 100.0, None
        wins.append({"label": lab, "left": round(left), "resets_in": secs})
    return {"ok": bool(wins), "windows": wins, "err": None if wins else "sin datos"}


# ---------- Codex ----------
def codex():
    files = glob.glob(os.path.join(HOME, ".codex", "sessions", "**", "rollout-*.jsonl"), recursive=True)
    if not files:
        return {"ok": False, "err": "sin sesiones de Codex"}
    files.sort(key=os.path.getmtime, reverse=True)
    for path in files[:8]:
        try:
            with open(path, "rb") as f:
                f.seek(0, 2)
                size = f.tell()
                f.seek(max(0, size - 400_000))
                lines = f.read().decode("utf-8", "ignore").splitlines()
        except Exception:
            continue
        for line in reversed(lines):
            if '"rate_limits"' not in line:
                continue
            try:
                ev = json.loads(line)
                rl = ev["payload"]["rate_limits"]
                if not rl:
                    continue
                ts = parse_iso(ev["timestamp"]) if ev.get("timestamp") else os.path.getmtime(path)
            except Exception:
                continue
            wins = []
            for key in ("primary", "secondary"):
                w = rl.get(key)
                if not w or w.get("used_percent") is None:
                    continue
                if w.get("resets_at"):
                    resets = float(w["resets_at"])
                elif w.get("resets_in_seconds") is not None:
                    resets = ts + float(w["resets_in_seconds"])
                else:
                    resets = None
                left = max(0.0, 100.0 - float(w["used_percent"]))
                secs = max(0, int(resets - time.time())) if resets else None
                if resets and resets < time.time():
                    left, secs = 100.0, None  # ventana ya renovada
                wins.append({"label": label(w.get("window_minutes")), "left": round(left), "resets_in": secs})
            if wins:
                return {"ok": True, "windows": wins, "err": None}
    return {"ok": False, "err": "sin datos de límites aún"}


if __name__ == "__main__":
    print(json.dumps({"claude": claude(), "codex": codex()}))
