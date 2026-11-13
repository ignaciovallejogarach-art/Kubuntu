import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore

// Reloj cuya esfera es el propio sol del fondo de pantalla.
// El widget no pinta relleno: solo marcas y agujas sobre el sol.
PlasmoidItem {
    id: root

    preferredRepresentation: fullRepresentation
    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground

    // Paleta extraída del fondo
    readonly property color cream: "#fbe9d0"   // cielo aclarado
    readonly property color teal: "#193742"    // montaña oscura

    // Sol en el fondo original (1672x941 px), ajustado por mínimos cuadrados
    readonly property size imgSize: Qt.size(1672, 941)
    readonly property point sunCenter: Qt.point(1148.82, 383.26)
    readonly property real sunRadius: 179.53

    property date now: new Date()

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            root.now = new Date()
            if (root.fullRepresentationItem) root.fullRepresentationItem.align()
        }
    }

    fullRepresentation: Item {
        id: face
        implicitWidth: 412
        implicitHeight: 412
        Layout.minimumWidth: 100
        Layout.minimumHeight: 100

        // El fondo usa "Escalado y recortado": se calcula dónde cae el sol en
        // pantalla y la esfera se dibuja ahí, aunque la rejilla del escritorio
        // desplace unos píxeles la caja del widget.
        property real r: Math.min(width, height) / 2
        property real cx: width / 2
        property real cy: height / 2

        function align() {
            var sw = Screen.width, sh = Screen.height
            var k = Math.max(sw / root.imgSize.width, sh / root.imgSize.height)
            var ox = (sw - root.imgSize.width * k) / 2
            var oy = (sh - root.imgSize.height * k) / 2
            var g = face.mapToGlobal(0, 0)
            var sx = g.x - Screen.virtualX, sy = g.y - Screen.virtualY
            var ncx = ox + root.sunCenter.x * k - sx
            var ncy = oy + root.sunCenter.y * k - sy
            var nr = root.sunRadius * k
            if (Math.abs(ncx - cx) > 0.1 || Math.abs(ncy - cy) > 0.1 || Math.abs(nr - r) > 0.1) {
                cx = ncx; cy = ncy; r = nr
                dial.requestPaint()
            }
        }
        onWidthChanged: align()
        onHeightChanged: align()
        Component.onCompleted: align()

        readonly property real h: root.now.getHours() % 12
        readonly property real m: root.now.getMinutes()
        readonly property real s: root.now.getSeconds()

        // Contorno del sol + 12 marcas
        Canvas {
            id: dial
            anchors.fill: parent
            anchors.margins: -100
            onWidthChanged: requestPaint()
            onHeightChanged: requestPaint()
            onPaint: {
                var ctx = getContext("2d")
                var r = face.r, cx = face.cx + 100, cy = face.cy + 100
                ctx.reset()
                ctx.strokeStyle = root.cream
                ctx.lineCap = "round"

                ctx.globalAlpha = 0.35
                ctx.lineWidth = 1.2
                ctx.beginPath()
                ctx.arc(cx, cy, r - 0.6, 0, 2 * Math.PI)
                ctx.stroke()

                for (var i = 0; i < 12; i++) {
                    var a = i * Math.PI / 6
                    var major = i % 3 === 0
                    var r1 = r - (major ? 0.13 : 0.08) * r
                    var r2 = r - 0.04 * r
                    ctx.globalAlpha = major ? 0.95 : 0.6
                    ctx.lineWidth = major ? 3 : 2
                    ctx.beginPath()
                    ctx.moveTo(cx + r1 * Math.sin(a), cy - r1 * Math.cos(a))
                    ctx.lineTo(cx + r2 * Math.sin(a), cy - r2 * Math.cos(a))
                    ctx.stroke()
                }
            }
        }

        component Hand: Rectangle {
            id: hand
            property real angle
            property real length
            width: 5
            height: length
            radius: width / 2
            color: root.cream
            antialiasing: true
            x: face.cx - width / 2
            y: face.cy - length + width / 2
            transform: Rotation {
                origin.x: hand.width / 2
                origin.y: hand.length - hand.width / 2
                angle: hand.angle
            }
        }

        Hand {
            length: face.r * 0.5
            width: 6
            angle: (face.h + face.m / 60) * 30
        }
        Hand {
            length: face.r * 0.76
            width: 4
            angle: (face.m + face.s / 60) * 6
        }

        Rectangle {
            x: face.cx - width / 2
            y: face.cy - height / 2
            width: 12; height: 12; radius: 6
            color: root.teal
            border.color: root.cream
            border.width: 2.5
            antialiasing: true
        }
    }
}
