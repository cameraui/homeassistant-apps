# hardcoded FROM: supervisor's build_from regex rejects dots in image names ("camera.ui")
FROM ghcr.io/cameraui/camera.ui:cpu

# keep the first-boot npm install quiet in the add-on log
ENV NPM_CONFIG_LOGLEVEL=error

# amd64: same hwaccel stack as the docker :intel flavor — iHD/QSV, Intel NEO
# OpenCL (OpenVINO GPU needs NEO, mesa's ICD exposes no Intel device), legacy
# NEO for Gen8-11, NPU Level Zero. Reuse the script so the images can't drift.
# aarch64 decodes via V4L2, nothing to add.
ARG BUILD_ARCH
RUN if [ "${BUILD_ARCH}" = "amd64" ]; then \
        curl -fsSL https://raw.githubusercontent.com/cameraui/docker/main/scripts/install-hwaccel-intel.sh | bash && \
        DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
            mesa-opencl-icd \
            libdrm-amdgpu1 && \
        rm -rf /var/lib/apt/lists/*; \
    fi

COPY rootfs /
RUN chmod a+x /etc/cont-init.d/* /etc/s6-overlay/s6-rc.d/*/run
