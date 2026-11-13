import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as P5Support

PlasmoidItem {
    id: root

    preferredRepresentation: fullRepresentation
    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground

    property var usage: ({})
    readonly property string cmd: "python3 " + Qt.resolvedUrl("../code/usage.py").toString().replace("file://", "")

    // Cambia a "#101010" si tu fondo de escritorio es claro
    readonly property color textColor: "#ffffff"

    function fmt(s) {
        if (s === null || s === undefined) return "renovado"
        var d = Math.floor(s / 86400), h = Math.floor((s % 86400) / 3600), m = Math.floor((s % 3600) / 60)
        if (d > 0) return d + "d " + h + "h"
        if (h > 0) return h + "h " + m + "m"
        return m + "m"
    }

    P5Support.DataSource {
        id: ds
        engine: "executable"
        connectedSources: []
        onNewData: (source, data) => {
            disconnectSource(source)
            try { root.usage = JSON.parse(data["stdout"]) } catch (e) {}
        }
    }

    Timer {
        interval: 120000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: ds.connectSource(root.cmd)
    }

    fullRepresentation: Item {
        implicitWidth: 230
        implicitHeight: col.implicitHeight + 8
        Layout.minimumWidth: 200
        Layout.minimumHeight: col.implicitHeight + 8

        ColumnLayout {
            id: col
            anchors { left: parent.left; right: parent.right; top: parent.top; margins: 4 }
            spacing: 14

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: "#aa000000"
                shadowBlur: 0.7
                shadowVerticalOffset: 1
                shadowHorizontalOffset: 0
            }

            Repeater {
                model: [ { key: "claude", name: "CLAUDE" }, { key: "codex", name: "CODEX" } ]

                ColumnLayout {
                    id: block
                    required property var modelData
                    readonly property var info: root.usage[modelData.key]
                    Layout.fillWidth: true
                    spacing: 5

                    Text {
                        text: block.modelData.name + (block.info && block.info.stale ? "  ·  sin actualizar" : "")
                        color: root.textColor
                        opacity: 0.6
                        font.pixelSize: 10
                        font.letterSpacing: 2.5
                        font.weight: Font.DemiBold
                    }

                    Text {
                        visible: !block.info || !block.info.ok
                        text: block.info ? (block.info.err || "—") : "cargando…"
                        color: root.textColor
                        opacity: 0.55
                        font.pixelSize: 12
                    }

                    Repeater {
                        model: block.info && block.info.ok ? block.info.windows : []

                        ColumnLayout {
                            id: win
                            required property var modelData
                            Layout.fillWidth: true
                            spacing: 3

                            RowLayout {
                                Layout.fillWidth: true
                                Text {
                                    text: win.modelData.label
                                    color: root.textColor
                                    opacity: 0.6
                                    font.pixelSize: 11
                                    Layout.preferredWidth: 22
                                }
                                Text {
                                    text: win.modelData.left + "%"
                                    color: root.textColor
                                    font.pixelSize: 15
                                    font.weight: Font.Medium
                                }
                                Item { Layout.fillWidth: true }
                                Text {
                                    text: root.fmt(win.modelData.resets_in)
                                    color: root.textColor
                                    opacity: 0.7
                                    font.pixelSize: 12
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 2
                                radius: 1
                                color: Qt.rgba(1, 1, 1, 0.18)
                                Rectangle {
                                    width: parent.width * win.modelData.left / 100
                                    height: parent.height
                                    radius: 1
                                    color: root.textColor
                                    opacity: 0.9
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
