import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    TextField {
        id: cfg_vpnInterface
        Kirigami.FormData.label: i18n("VPN Interface (e.g. wg0):")
        placeholderText: "wg0"
    }

    TextField {
        id: cfg_vpnConnectionName
        Kirigami.FormData.label: i18n("NetworkManager Connection Name:")
        placeholderText: "PureVPN"
    }

    SpinBox {
        id: cfg_checkInterval
        Kirigami.FormData.label: i18n("Check Interval (seconds):")
        from: 1
        to: 60
        stepSize: 1
    }

    TextField {
        id: cfg_activeIcon
        Kirigami.FormData.label: i18n("Active Icon:")
        placeholderText: "network-vpn-activated"
    }

    TextField {
        id: cfg_inactiveIcon
        Kirigami.FormData.label: i18n("Inactive Icon:")
        placeholderText: "network-vpn-disconnected"
    }
}
