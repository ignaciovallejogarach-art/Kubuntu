---
name: kubuntu
# Skill compartida entre Codex y Claude Code
# Se aplica a tareas de personalización del Kubuntu del usuario, no a repositorios ajenos.
description: >-
  Diseñar, implementar, integrar, probar y mantener personalizaciones del
  equipo Kubuntu en ~/Proyectos/Kubuntu: aplicaciones, atajos Bash/Kitty,
  consola, widgets KDE Plasma y automatizaciones. Usar cuando la petición
  afecte a este sistema o a este repositorio; no aplicarla indiscriminadamente
  a otros proyectos.
---

# Skill: personalización de Kubuntu

## Contexto y alcance

- Directorio principal: `~/Proyectos/Kubuntu/`, repositorio Git principal para personalizar el sistema.
- Sistema: Kubuntu con KDE Plasma (Wayland); terminal Kitty y shell Bash con Oh My Bash.
- Herramientas frecuentes: Visual Studio Code, Git, Codex, Claude Code, APT y Snap.
- Equipo: Dell Latitude 7420, Intel Core i5-1145G7, 16 GB RAM, Intel Iris Xe.
- Comprobar las versiones, aplicaciones instaladas, estructura existente y estado del sistema **antes** de asumirlos.
- No convertir este repositorio en un almacén de instalaciones APT/Snap: guardar aquí el código y la configuración propios; dejar los paquetes y datos internos en sus ubicaciones oficiales.

## Estructura de referencia

```text
~/Proyectos/Kubuntu/
├── Aplicaciones/                  # Personalizaciones y automatizaciones de aplicaciones
│   └── <aplicacion>/             # Estructura interna flexible según complejidad
│       ├── scripts/             # Si corresponde
│       ├── config/              # Si corresponde
│       ├── backup/              # Si corresponde
│       ├── install.sh           # Cuando se necesite instalación reproducible
│       ├── uninstall.sh         # Cuando se necesite reversión reproducible
│       └── README.md            # Documentación de cada funcionalidad
├── Atajos/
│   ├── paths.sh                 # Accesos de navegación a directorios
│   └── comandos.sh              # Comandos, alias y funciones operativas
├── Consola/                      # Información y presentación personalizada en terminal
├── Widgets/                      # Widgets y recursos para KDE Plasma
└── SKILL.md                      # Estas instrucciones
```

La estructura es **una convención objetivo**, no una afirmación de que todos los archivos ya existan. Inspeccionar antes de crear, mover o reemplazar. No duplicar comandos entre `paths.sh`, `comandos.sh`, `~/.bashrc` y scripts ejecutables.

- `Atajos/paths.sh`: nombres que cambian a una ruta. Mantenerlo separado de `Atajos/comandos.sh` cuando se organice o refactorice esta parte del proyecto.
- `Atajos/comandos.sh`: funciones, aliases operativos y puntos de entrada a scripts externos. Debe cargarse al abrir Kitty mediante un único mecanismo en `~/.bashrc`, sin entradas duplicadas.
- Scripts con lógica propia: ubicarlos en el módulo correspondiente; usar funciones o alias ligeros para invocarlos desde Bash y enlaces en `~/.local/bin` solo cuando aporten valor.
- `Consola/`: información personalizada que se muestra en la terminal; evitar procesos en segundo plano innecesarios.
- `Widgets/`: widgets nativos o soluciones integradas con Plasma, según estabilidad, rendimiento y mantenimiento.
- Los proyectos grandes pueden tener su propio repositorio Git; conservar este como repositorio principal de personalización.

## Método de trabajo obligatorio

### 1. Inspeccionar y proponer — **antes de modificar**

1. Entender el objetivo y revisar los archivos y mecanismos actuales relacionados; reutilizar lo que ya funciona.
2. Priorizar herramientas ya instaladas; investigar alternativas solo cuando aporten una ventaja concreta.
3. Presentar al usuario una propuesta **breve y estructurada** con objetivo, solución, archivos afectados, dependencias y riesgos.
4. **Esperar aprobación explícita antes de implementar**. No interpretar una petición de ideas o diagnóstico como autorización de cambios.
5. Si implica modificar archivos fuera de `~/Proyectos/Kubuntu/` (p. ej., `~/.bashrc`, `~/.config`, `/etc/`, servicios, Plasma), **enumerar y justificar cada cambio externo antes de realizarlo**. Los cambios críticos o distintos de los aprobados requieren autorización específica.

### 2. Implementar tras la aprobación

- Preferir soluciones simples, nativas, modulares, mantenibles y ampliables.
- Dentro de `Aplicaciones/<aplicacion>/`, elegir libremente la estructura interna adecuada; no crear carpetas o archivos vacíos por obligación.
- Instalar las dependencias necesarias para la implementación aprobada; evitar dependencias superfluas. Si implican cambios globales sensibles, privilegios administrativos o riesgos nuevos, explicar y pedir confirmación específica.
- Elegir entre enlaces simbólicos, archivos en ubicaciones oficiales y scripts de instalación según lo soporte cada programa; no desplazar arbitrariamente instalaciones gestionadas por APT/Snap.
- Usar scripts `install.sh` y `uninstall.sh` para integraciones de cierta complejidad; que sean idempotentes, comprueben precondiciones y reviertan **solo** lo que les pertenece.
- Preferir archivos de configuración para herramientas simples e interfaz gráfica de ajustes cuando la complejidad lo justifique.
- Si una automatización periódica es útil, proponer **ejecución manual y automática** con ventajas y costes; dejar que el usuario elija. Priorizar `systemd --user` u otros mecanismos propios del sistema cuando correspondan.
- No crear servicios permanentes, sondeos frecuentes o tareas al inicio sin necesidad y aprobación.

### 3. Probar, proteger y documentar

- Ajustar pruebas a complejidad: sintaxis y casos básicos para scripts sencillos; pruebas aisladas y aceptación real controlada para integraciones sensibles.
- No considerar pruebas simuladas como prueba de funcionamiento en KDE real.
- Antes de alterar configuraciones operativas, revisar su contenido y guardar copia de los **archivos externos** afectados cuando exista riesgo de pérdida. Git versiona el código del proyecto, pero no sustituye respaldos de configuraciones externas.
- No borrar backups existentes ni datos del usuario. No almacenar ni versionar contraseñas, tokens, claves SSH privadas o certificados personales; usar `.gitignore` cuando proceda.
- Ante un error, corregir autónomamente dentro del alcance aprobado. Si requiere un rediseño importante, consultar antes.
- Si el cambio deja el sistema inestable, **priorizar revertir únicamente los cambios propios** al último estado funcional, siempre que sea seguro; si la reversión puede perder trabajo o estado ajeno, detenerse y pedir autorización.
- Revisar también componentes relacionados cuando sea necesario para mantener coherencia; no aplicar cambios importantes fuera del alcance aprobado sin preguntar.
- Documentar cada funcionalidad en `README.md` (instalación, uso, dependencias, mantenimiento y desinstalación o restauración cuando proceda).
- Al finalizar, informar de forma concisa: archivos modificados, pruebas efectuadas y resultado, cómo usarlo y cómo revertirlo.

## Calidad, rendimiento y diseño

1. Priorizar **mantenibilidad y escalabilidad** por encima de la rapidez puntual de implementación.
2. Proteger primero estabilidad, seguridad y datos; minimizar consumo de CPU, RAM, batería y procesos residentes.
3. Apariencia **minimalista y coherente**: compartir paleta, tipografías y estilo visual entre personalizaciones.
4. Admitir animaciones y efectos siempre que su impacto en rendimiento sea bajo y aporten valor.
5. Elegir la tecnología de cada widget o integración KDE según compatibilidad, estabilidad, rendimiento y coste de mantenimiento; no imponer una única tecnología.
6. Evitar soluciones complejas si una opción simple ofrece el mismo resultado.

## Seguridad especial de Kubuntu y KDE

- No modificar KWin, KDE Plasma, sesiones gráficas, atajos globales, gestor de red, drivers, particiones, cifrado, firmware ni servicios críticos sin alcance aprobado y advertencia explícita de riesgo.
- No reiniciar ni cerrar la sesión gráfica, matar aplicaciones, sobrescribir configuraciones o usar `sudo` de forma sorpresiva.
- No ejecutar operaciones destructivas (`rm -rf`, restauraciones globales, cambios masivos de permisos) sin confirmar exactamente qué afecta y cómo recuperarlo.
- Respetar funcionalidades existentes (Kitty, Bash, SSH/GitHub, VPN, Spotify y otras). Verificar rutas y enlaces simbólicos antes de editarlos.
- No confundir la instalación de una aplicación con la configuración personalizada que se conserva en este repositorio.

## Compatibilidad con agentes

- El contenido de esta skill es una **fuente única** para Codex y Claude Code.
- Usarla cuando el usuario pida trabajo sobre personalizaciones de `~/Proyectos/Kubuntu/`.
- Si hay reglas superiores o permisos efectivos del agente más restrictivos, prevalecen esos límites: esta skill no concede permisos que la herramienta o el usuario no hayan concedido.
