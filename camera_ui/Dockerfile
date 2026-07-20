# hardcoded FROM: supervisor's build_from regex rejects dots in image names ("camera.ui")
FROM ghcr.io/cameraui/camera.ui:cpu

# keep the first-boot npm install quiet in the add-on log
ENV NPM_CONFIG_LOGLEVEL=error

# VA-API userspace for Intel/AMD GPUs, amd64 only (aarch64 decodes via V4L2)
ARG BUILD_ARCH
RUN if [ "${BUILD_ARCH}" = "amd64" ]; then \
        apt-get update && \
        DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
            intel-media-va-driver-non-free \
            i965-va-driver \
            mesa-va-drivers \
            mesa-opencl-icd \
            mesa-vulkan-drivers \
            vainfo && \
        rm -rf /var/lib/apt/lists/*; \
    fi

COPY rootfs /
RUN chmod a+x /etc/cont-init.d/* /etc/s6-overlay/s6-rc.d/*/run
