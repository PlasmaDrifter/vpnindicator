import QtQuick
import org.kde.plasma.configuration
import org.kde.kirigami as Kirigami

ConfigModel {
    ConfigCategory {
        name: i18n("General")
        icon: "configure"
        source: "configGeneral.qml"
    }
}
