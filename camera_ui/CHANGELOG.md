# Changelog

## 0.2.0

- **Stopping or restarting the add-on no longer cuts camera.ui off while it shuts down.** Home Assistant now waits up to 30 seconds, so cameras and plugins stop cleanly.
- **Home Assistant backups no longer contain camera.ui's own backups.** The scheduled camera.ui archives in the default folder and unfinished restore uploads are left out, so a Home Assistant backup does not grow with every camera.ui backup.
- **A camera.ui update that does not start is rolled back.** The previous server version starts again, and its log says which update failed.

## 0.1.11

- Dependency updates.

## 0.1.10

- Dependency updates.

## 0.1.9

- Dependency updates.

## 0.1.8

- Dependency updates.

## 0.1.7

- **The Home Assistant plugin can now connect from inside the add-on.** The add-on was missing the Home Assistant API permission, so the plugin's automatic connection was always rejected. Requires plugin version 1.0.8.

## 0.1.6

- Dependency updates.

## 0.1.5

- Dependency updates.

## 0.1.4

- Dependency updates.

## 0.1.3

- **Intel GPU and NPU now work for OpenVINO detection.** The app was missing the Intel OpenCL runtime, so OpenVINO only ever saw the CPU. The image now ships the same driver stack as the `intel` Docker flavor: iHD/QSV, Intel OpenCL (including the legacy runtime for Gen8-11 iGPUs) and the NPU user-space driver.
- The NPU (`/dev/accel/accel0`) and a second render node (`/dev/dri/renderD129`) are now passed through when present.
