#!/usr/bin/env bash

# === RUTAS PERSONALIZADAS ===

alias kubuntu='cd "$HOME/Proyectos/Kubuntu"'

# === PARA LA UNIVERSIDAD ===

alias rso='cd "$HOME/Proyectos/GIDIA/rso"'
alias drso='cd "$HOME/Documentos/Universidad/3/rso"'

alias sbc='cd "$HOME/Proyectos/GIDIA/sbc/fdi_sbc_26g4"'
alias rnd='cd "$HOME/Proyectos/GIDIA/rnd"'
alias gidia='cd "$HOME/Proyectos/GIDIA"'

alias aa2='cd "$HOME/Proyectos/GIDIA/aa2"'
alias daa2='cd "$HOME/Documentos/Universidad/3/aa2"'
murphy() {
	cd "$HOME/Documentos/Universidad/3/aa2"
	xdg-open "murphy.pdf"
}


# === PARA ORIENTACIÓN ===
alias mapas='cd "$HOME/Documentos/CONDES/Mapas"'
alias crc='cd "$HOME/Proyectos/Deporte/CRC"'
alias entrenamientos='cd "$HOME/Proyectos/Orientacion/Entrenamientos"'
alias orientacion='cd "$HOME/Proyectos/Orientacion"'

# === NAVEGACIÓN A LA RUTA Y APERTURA DEL ARCHIVO ===
paths() {
	cd "$HOME/Proyectos/Kubuntu/Atajos"
	micro "paths.sh"
}

