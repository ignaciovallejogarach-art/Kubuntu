#!/bin/bash

# ===== VPN UCM =====

# Conectar
alias vpn_ucm='globalprotect connect --portal galeria.ucm.es'

# Desconectar
alias vpn_ucm_off='globalprotect disconnect'

# Consultar estado
alias vpn_ucm_estado='globalprotect show --status'

# ===== Recargar configuración bash =====
alias recharge_bash='source ~/.bashrc'

# COROS → diario (instalado por Entrenamientos)
sincronizar_entrenamientos() { /home/ignacio/Proyectos/Orientacion/Entrenamientos/scripts/sincronizar_entrenamientos "$@"; }
