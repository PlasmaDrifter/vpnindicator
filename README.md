# VPN Status Indicator Widget

[![KDE Plasma 6](https://img.shields.io/badge/KDE_Plasma-6.0+-3152A0?style=for-the-badge&logo=kde&logoColor=white)](https://kde.org/plasma-desktop/)
[![QML](https://img.shields.io/badge/UI-QML%2FQt6-41CD52?style=for-the-badge&logo=qt&logoColor=white)](https://doc.qt.io/qt-6/qtqml-index.html)
[![Category](https://img.shields.io/badge/Network%20%26%20Security-30B0C7?style=for-the-badge&logo=shield&logoColor=white)](https://github.com/PlasmaDrifter)
[![License](https://img.shields.io/badge/License-GPLv2-blue.svg?style=for-the-badge)](LICENSE)

A system tray and desktop indicator widget for NetworkManager VPN connections in KDE Plasma 6.

---

## Previews

![VPN Status Indicator Widget Preview](desktop-2.png)
![VPN Connected Icon Status](vpnindicator2.png)
![VPN Disconnected Icon Status](vpnindicator.png)

---

## Features

- **Real-time**: VPN connection status monitoring via NetworkManager DBus
- **One-click**: VPN toggle connect/disconnect
- **Dynamic**: status icon indicators
- **Supports**: WireGuard, OpenVPN, and Cisco AnyConnect

## Requirements

- **Environment**: KDE Plasma 6.0 or higher
- **Framework**: Qt6 QML / Plasma Applet API

## Installation

### Option 1: Git Clone (Recommended)
```bash
mkdir -p ~/.local/share/plasma/plasmoids/
git clone https://github.com/PlasmaDrifter/vpnindicator.git ~/.local/share/plasma/plasmoids/local.widget.vpnindicator
```

### Option 2: Plasma Package Installer
```bash
kpackagetool6 -i ~/.local/share/plasma/plasmoids/local.widget.vpnindicator
```

Then right-click your desktop or panel $\rightarrow$ **Add Widgets...** and search for the widget name.

## Credits & License

- **Author / Maintainer**: PlasmaDrifter
- **License**: Licensed under the [GPLv2](LICENSE).
