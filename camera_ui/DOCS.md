# camera.ui

Self-hosted NVR and camera management. This app runs the full camera.ui server on your Home Assistant OS machine.

## First start

The first start downloads the camera.ui server and default plugins from npm. Depending on your connection this takes a few minutes, the app needs internet access for it. Later starts are fast.

Open the web UI at `https://<your-host>:3443` (or use the "Open Web UI" button). The certificate is self-signed, your browser will warn once.

## Options

### `default_plugins`

Comma-separated list of plugins installed on first boot. Defaults to the NVR plugin.

### `recordings_path`

Where recordings are stored. The default `/media/camera.ui` puts them into the Home Assistant media folder, so they show up in the media browser. Point it somewhere under `/data` if you don't want that.

### `internal_avahi`

The app ships its own mDNS stack for HomeKit pairing and camera discovery. If HomeKit pairing misbehaves on your setup, try turning this off so camera.ui uses the host's mDNS instead.

## Hardware acceleration

- **Intel/AMD GPU (amd64):** VA-API drivers are included. The GPU is passed through automatically when `/dev/dri` exists.
- **Coral (USB and PCIe) and Hailo:** supported, the runtimes are included. PCIe Coral and Hailo need their kernel drivers on the host, which Home Assistant OS may not ship for every board.
- **Raspberry Pi:** hardware decoding uses the V4L2 devices, passed through automatically.
- **NVIDIA:** not available on Home Assistant OS (the OS has no NVIDIA container toolkit).

## Network

The app uses host networking, required for WebRTC, HomeKit and camera discovery. Ports used: 3443 (web UI/API), 2000-2004 (streaming: go2rtc, RTSP, WebRTC).

## Data, backups, updates

Everything (configuration, database, certificates) lives in the app's `/data` and survives updates. Uninstalling the app deletes it, recordings under `/media` are kept.

Home Assistant backups of this app stay small: the camera.ui server itself is excluded and re-downloaded on restore, only your data is backed up. Restoring therefore needs internet access.
