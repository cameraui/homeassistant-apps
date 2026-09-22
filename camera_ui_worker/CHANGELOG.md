# Changelog

## 0.1.11

- Dependency updates.

## 0.1.10

- Dependency updates.

## 0.1.9

- Dependency updates.

## 0.1.8

- Dependency updates.

## 0.1.7

- Dependency updates.

## 0.1.6

- Dependency updates.

## 0.1.5

- Dependency updates.

## 0.1.4

- Dependency updates.

## 0.1.3

- **Intel GPU and NPU now work for OpenVINO detection.** The app was missing the Intel OpenCL runtime, so OpenVINO only ever saw the CPU. The image now ships the same driver stack as the `intel` Docker flavor: iHD/QSV, Intel OpenCL (including the legacy runtime for Gen8-11 iGPUs) and the NPU user-space driver.
- The NPU (`/dev/accel/accel0`) and a second render node (`/dev/dri/renderD129`) are now passed through when present.
