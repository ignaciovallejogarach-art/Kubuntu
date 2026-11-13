alias mapper='Mapper'

# === VPN UCM: desconexión y limpieza DNS ===
unalias vpn_ucm_off 2>/dev/null || true

vpn_ucm_off() {
    globalprotect disconnect

    if globalprotect show --status | grep -qi "Disconnected"; then
        sudo resolvectl revert gpd0 2>/dev/null || true
        sudo resolvectl flush-caches
        echo "✓ VPN desconectada y DNS restaurados."
    else
        echo "⚠ La VPN sigue conectada. No se modifican los DNS."
        return 1
    fi
}
