#!/usr/bin/env bash

cat <<'EOF'
══════════════════════════════════════════════════════════
                   GIT — GUÍA RÁPIDA
══════════════════════════════════════════════════════════

📌 CLONAR REPOSITORIOS

🎓 Cuenta universitaria (Ignaciiovallejo):
git clone git@github-uni:Ignaciiovallejo/NOMBRE_REPOSITORIO.git

💻 Cuenta personal (ignaciovallejogarach-art):
git clone git@github-personal:ignaciovallejogarach-art/NOMBRE_REPOSITORIO.git

📌 CAMBIAR DE CUENTA EN UN REPOSITORIO EXISTENTE

gitcuenta uni                  Utilizar cuenta universitaria
gitcuenta personal             Utilizar cuenta personal

📌 COMPROBAR CONFIGURACIÓN

git remote -v                  Ver repositorio remoto
git config user.name           Ver autor de commits
git config user.email          Ver correo de commits

ssh -T git@github-uni          Comprobar cuenta universitaria
ssh -T git@github-personal     Comprobar cuenta personal

IMPORTANTE:
- Las cuentas pueden funcionar simultáneamente.
- No necesitas introducir tokens en cada push.
- Cada repositorio recuerda su identidad SSH.
- El autor de los commits se configura por separado.

══════════════════════════════════════════════════════════
EOF
