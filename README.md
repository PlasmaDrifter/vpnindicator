# VPN Status Indicator

A KDE Plasma panel widget that shows whether your VPN (WireGuard `wg0` / PureVPN) is connected, with a click-to-toggle button.

![vpnindicator](vpnindicator.png) ![vpnindicator](vpnindicator2.png)
![vpnindicator](desktop-2.png)

## Features

- Green / red indicator showing live VPN connection status
- Click the widget to connect or disconnect
- Monitors the `wg0` WireGuard interface by default
- Lightweight — uses a simple shell command to check status
- No external dependencies beyond WireGuard tools

## Requirements

- KDE Plasma 6.0+
- WireGuard (`wg-quick`) installed and configured
- Appropriate `sudo` / polkit rules for `wg-quick up/down` without a password prompt

## Installation

```bash
cd ~/.local/share/plasma/plasmoids/
git clone https://github.com/PlasmaDrifter/vpnindicator local.widget.vpnindicator
```

Then right-click your panel → **Add Widgets** → search for **VPN Status Indicator**.

## Configuration

Right-click the widget → **Configure…**

| Option | Description |
|--------|-------------|
| Interface | WireGuard interface name (default: `wg0`) |
| Connected colour | Indicator colour when VPN is up |
| Disconnected colour | Indicator colour when VPN is down |

