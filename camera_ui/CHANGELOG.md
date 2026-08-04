# Changelog

## 0.1.7

- **The Home Assistant plugin can now connect from inside the add-on.** The add-on was missing the Home Assistant API permission, so the plugin's automatic connection was always rejected. Requires plugin version 1.0.8.

## 0.1.3

- **Intel GPU and NPU now work for OpenVINO detection.** The app was missing the Intel OpenCL runtime, so OpenVINO only ever saw the CPU. The image now ships the same driver stack as the `intel` Docker flavor: iHD/QSV, Intel OpenCL (including the legacy runtime for Gen8-11 iGPUs) and the NPU user-space driver.
- The NPU (`/dev/accel/accel0`) and a second render node (`/dev/dri/renderD129`) are now passed through when present.
