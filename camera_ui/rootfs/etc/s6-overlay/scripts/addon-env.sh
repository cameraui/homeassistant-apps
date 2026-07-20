# base image sets S6_KEEP_ENV=1, which makes with-contenv skip the env dir; apply it manually
for f in /run/s6/container_environment/*; do
    [ -f "$f" ] && export "$(basename "$f")=$(cat "$f")"
done
