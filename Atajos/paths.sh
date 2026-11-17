#!/usr/bin/env bash

# === RUTAS PERSONALIZADAS ===

alias kubuntu='cd "$HOME/Proyectos/Kubuntu"'

# === PARA LA UNIVERSIDAD ===

alias rso='cd "$HOME/Proyectos/GIDIA/rso"'
alias drso='cd "$HOME/Documentos/Universidad/3/rso"'

alias sbc='cd "$HOME/Proyectos/GIDIA/sbc/fdi_sbc_26g4"'
alias rnd='cd "$HOME/Proyectos/GIDIA/rnd"'
alias gidia='cd "$HOME/Proyectos/GIDIA"'
alias giw='cd "$HOME/Proyectos/GIDIA/giw/Proyectos-GIW"'

alias aa2='cd "$HOME/Proyectos/GIDIA/aa2"'
alias daa2='cd "$HOME/Documentos/Universidad/3/aa2"'
murphy() {
	cd "$HOME/Documentos/Universidad/3/aa2"
	xdg-open "murphy.pdf"
}

# === PARA CIU RUN CLUB ===
alias ciu_marca='cd "$HOME/Proyectos/Deporte/CRC/Marca"'
alias ciu_app='cd "$HOME/Proyectos/Deporte/CRC/CIU_MEMBERS"'
ciu_branding() {
	cd "$HOME/Proyectos/Deporte/CRC/Marca"
	micro "branding.md"
}
ciu_logos() {
	dolphin "$HOME/Proyectos/Deporte/CRC/Marca/Logos"
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

# === PARA MOSTRAR INFORMACIÓN ===
alias info_git='bash "$HOME/Proyectos/Kubuntu/Consola/info_git.sh"'

# === PARA MIS PROYECTOS === 
alias analisis_inversion='cd "$HOME/Proyectos/Finanzas/Analisis-Inversion"'

# === PARA CONCURSOS ===
alias ojo_ciudadano='cd "$HOME/Proyectos/Concursos/Ojo-Ciudadano"'
