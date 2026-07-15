import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    preferredRepresentation: compactRepresentation

    toolTipMainText: ""
    toolTipSubText: ""

    property bool vpnActive: false
    property string currentStatusText: i18n("Checking VPN...")

    // Check status command:
    // 1. Checks if the sysfs directory exists for the interface (e.g. /sys/class/net/wg0)
    // 2. Checks if nmcli active connections contain the connection name (case-insensitive)
    property string checkCommand: "if [ -d /sys/class/net/" + plasmoid.configuration.vpnInterface + " ] || nmcli connection show --active | grep -qi \"" + plasmoid.configuration.vpnConnectionName + "\"; then echo \"active\"; else echo \"inactive\"; fi"

    // Toggle command:
    // If active, tries to bring down via nmcli, then ip link, then wg-quick
    // If inactive, tries to bring up via nmcli, then ip link, then wg-quick
    property string toggleCommand: "if [ -d /sys/class/net/" + plasmoid.configuration.vpnInterface + " ] || nmcli connection show --active | grep -qi \"" + plasmoid.configuration.vpnConnectionName + "\"; then (nmcli connection down \"" + plasmoid.configuration.vpnConnectionName + "\" || ip link set dev " + plasmoid.configuration.vpnInterface + " down || wg-quick down " + plasmoid.configuration.vpnInterface + "); else (nmcli connection up \"" + plasmoid.configuration.vpnConnectionName + "\" || ip link set dev " + plasmoid.configuration.vpnInterface + " up || wg-quick up " + plasmoid.configuration.vpnInterface + "); fi"

    // Timer to poll status
    Timer {
        id: pollTimer
        interval: plasmoid.configuration.checkInterval * 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            executableDataSource.exec(root.checkCommand);
        }
    }

    // React to configuration changes
    Connections {
        target: plasmoid.configuration
        function onVpnInterfaceChanged() { pollTimer.restart(); }
        function onVpnConnectionNameChanged() { pollTimer.restart(); }
        function onCheckIntervalChanged() {
            pollTimer.interval = plasmoid.configuration.checkInterval * 1000;
            pollTimer.restart();
        }
    }

    // Legacy DataSource support layer in Plasma 6
    Plasma5Support.DataSource {
        id: executableDataSource
        engine: "executable"
        connectedSources: []

        onNewData: function(source, data) {
            disconnectSource(source);

            // Only process state check command outputs to prevent loops/spams
            if (source !== root.checkCommand) {
                return;
            }

            var output = data["stdout"].trim();
            var isActive = (output === "active");
            root.vpnActive = isActive;
            root.currentStatusText = isActive 
                ? i18n("VPN Active (%1)", plasmoid.configuration.vpnInterface) 
                : i18n("VPN Disconnected");
        }

        function exec(cmd) {
            connectSource(cmd);
        }
    }

    function toggleVpn() {
        root.currentStatusText = i18n("Toggling VPN...");
        executableDataSource.exec(root.toggleCommand);
        // Force a refresh soon after
        pollTimer.restart();
    }

    // Panel representation
    compactRepresentation: Item {
        id: compactRoot
        implicitWidth: Kirigami.Units.gridUnit * 1.5
        implicitHeight: Kirigami.Units.gridUnit * 1.5

        Kirigami.Icon {
            id: iconItem
            anchors.centerIn: parent
            width: Math.min(parent.width, parent.height) - Kirigami.Units.smallSpacing * 1.5
            height: width
            source: root.vpnActive ? plasmoid.configuration.activeIcon : plasmoid.configuration.inactiveIcon
            isMask: true
            
            // Color active state positive green or highlight, inactive as disabled gray
            color: root.vpnActive ? Kirigami.Theme.positiveTextColor : Kirigami.Theme.disabledTextColor

            Behavior on color {
                ColorAnimation { duration: Kirigami.Units.longDuration }
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                root.toggleVpn();
            }
        }
    }

    // Expanded / Desktop representation
    fullRepresentation: Item {
        id: fullRoot
        implicitWidth: Kirigami.Units.gridUnit * 12
        implicitHeight: Kirigami.Units.gridUnit * 6

        Kirigami.Card {
            anchors.fill: parent
            anchors.margins: Kirigami.Units.smallSpacing

            contentItem: ColumnLayout {
                anchors.centerIn: parent
                spacing: Kirigami.Units.largeSpacing

                RowLayout {
                    spacing: Kirigami.Units.mediumSpacing
                    Layout.alignment: Qt.AlignHCenter

                    Kirigami.Icon {
                        source: root.vpnActive ? plasmoid.configuration.activeIcon : plasmoid.configuration.inactiveIcon
                        implicitWidth: Kirigami.Units.iconSizes.large
                        implicitHeight: Kirigami.Units.iconSizes.large
                        isMask: true
                        color: root.vpnActive ? Kirigami.Theme.positiveTextColor : Kirigami.Theme.disabledTextColor
                    }

                    ColumnLayout {
                        spacing: 2
                        PlasmaComponents.Label {
                            text: plasmoid.configuration.vpnConnectionName
                            font.bold: true
                            font.pointSize: Kirigami.Theme.defaultFont.pointSize * 1.15
                        }
                        PlasmaComponents.Label {
                            text: root.currentStatusText
                            font.pointSize: Kirigami.Theme.defaultFont.pointSize * 0.95
                            opacity: 0.85
                        }
                    }
                }

                PlasmaComponents.Button {
                    Layout.alignment: Qt.AlignHCenter
                    text: root.vpnActive ? i18n("Disconnect VPN") : i18n("Connect VPN")
                    icon.name: root.vpnActive ? "network-disconnect" : "network-connect"
                    onClicked: {
                        root.toggleVpn();
                    }
                }
            }
        }
    }
}
