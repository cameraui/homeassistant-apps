#!/bin/sh
# map supervisor add-on options to camera.ui env before s6 starts the service
opts=/data/options.json
envdir=/run/s6/container_environment
[ -f "$opts" ] || exit 0
mkdir -p "$envdir"

opt() {
    python3 -c "import json; v = json.load(open('$opts')).get('$1'); print('' if v is None else v)"
}

plugins=$(opt default_plugins)
[ -n "$plugins" ] && printf '%s' "$plugins" > "$envdir/CAMERA_UI_DEFAULT_PLUGINS"

recordings=$(opt recordings_path)
[ -n "$recordings" ] && printf '%s' "$recordings" > "$envdir/CAMERAUI_PLUGIN_NVR_STORAGE_PATH"

master=$(opt master_address)
[ -n "$master" ] && printf '%s' "$master" > "$envdir/CAMERA_UI_WORKER_MASTER"

code=$(opt pairing_code)
[ -n "$code" ] && printf '%s' "$code" > "$envdir/CAMERA_UI_WORKER_PAIRING_CODE"

name=$(opt worker_name)
[ -n "$name" ] && printf '%s' "$name" > "$envdir/CAMERA_UI_WORKER_NAME"

api_port=$(opt master_api_port)
[ -n "$api_port" ] && printf '%s' "$api_port" > "$envdir/CAMERA_UI_WORKER_API_PORT"

avahi=$(python3 -c "import json; print(str(json.load(open('$opts')).get('internal_avahi', True)).lower())")
printf '%s' "$avahi" > "$envdir/CAMERAUI_DOCKER_AVAHI"

exit 0
