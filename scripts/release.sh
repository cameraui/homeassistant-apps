#!/bin/bash
set -euo pipefail

# Bump both add-ons to the same version (they share one image, so their versions
# must match), commit, tag vX.Y.Z and push. The CI workflow builds and publishes
# the image on the tag.
#
#   scripts/release.sh patch
#   scripts/release.sh 0.2.0 --yes

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

usage() {
  cat <<EOF
Usage: scripts/release.sh <version|major|minor|patch> [--yes] [--skip-checks]

Examples:
  scripts/release.sh patch
  scripts/release.sh 0.2.0

Options:
  --yes, -y       Push without the confirmation prompt.
  --skip-checks   Skip the local config validation.
EOF
  exit 1
}

SPEC="${1:-}"
YES=false
SKIP_CHECKS=false
for arg in "${@:2}"; do
  case "$arg" in
    --yes | -y) YES=true ;;
    --skip-checks) SKIP_CHECKS=true ;;
    *)
      echo "Unknown option: $arg"
      usage
      ;;
  esac
done

[ -z "$SPEC" ] && usage

cd "$ROOT"

CONFIGS=(camera_ui/config.yaml camera_ui_worker/config.yaml)

# Safety: clean tree, on main, not behind origin.
if [ -n "$(git status --porcelain)" ]; then
  echo -e "${RED}Working tree not clean - commit or stash first.${NC}"
  exit 1
fi
branch="$(git rev-parse --abbrev-ref HEAD)"
if [ "$branch" != "main" ]; then
  echo -e "${RED}Not on main (on '$branch').${NC}"
  exit 1
fi
git fetch -q origin main || true
if [ -n "$(git rev-list HEAD..origin/main 2>/dev/null)" ]; then
  echo -e "${RED}Local main is behind origin/main - pull first.${NC}"
  exit 1
fi

version_of() { grep -E '^version:' "$1" | head -1 | sed -E 's/version:[[:space:]]*//'; }

cur="$(version_of camera_ui/config.yaml)"
worker_cur="$(version_of camera_ui_worker/config.yaml)"
if [ "$cur" != "$worker_cur" ]; then
  echo -e "${RED}Add-ons are out of lockstep: camera_ui=$cur, worker=$worker_cur. Align them first.${NC}"
  exit 1
fi

bump() {
  local IFS='.'
  read -r ma mi pa <<<"$1"
  case "$2" in
    major) echo "$((ma + 1)).0.0" ;;
    minor) echo "$ma.$((mi + 1)).0" ;;
    patch) echo "$ma.$mi.$((pa + 1))" ;;
  esac
}

case "$SPEC" in
  major | minor | patch) NEW="$(bump "$cur" "$SPEC")" ;;
  *) NEW="$SPEC" ;;
esac

if ! echo "$NEW" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
  echo -e "${RED}Invalid version '$NEW' (expected X.Y.Z).${NC}"
  exit 1
fi

TAG="v$NEW"
if git rev-parse "$TAG" >/dev/null 2>&1; then
  echo -e "${RED}Tag $TAG already exists.${NC}"
  exit 1
fi

echo -e "${CYAN}Releasing add-ons: $cur -> $NEW (tag $TAG)${NC}"

if [ "$SKIP_CHECKS" = false ]; then
  for f in "${CONFIGS[@]}"; do
    python3 -c "import yaml; yaml.safe_load(open('$f'))" || {
      echo -e "${RED}$f is not valid YAML.${NC}"
      exit 1
    }
  done
fi

for f in "${CONFIGS[@]}"; do
  sed -i.bak -E "s/^version:.*/version: $NEW/" "$f"
  rm -f "$f.bak"
done
git add "${CONFIGS[@]}"

git commit -q -m "release: v$NEW"
echo -e "${GREEN}Committed version bump.${NC}"

git tag "$TAG"
echo -e "${GREEN}Created tag $TAG.${NC}"

if [ "$YES" = false ]; then
  printf "Push main + %s and trigger the release? [y/N] " "$TAG"
  read -r ans
  case "$ans" in
    y | Y | yes) ;;
    *)
      git tag -d "$TAG" >/dev/null
      git reset -q --hard HEAD~1
      echo "Aborted - tag and bump commit were undone locally."
      exit 0
      ;;
  esac
fi

git push -q origin main
git push -q origin "$TAG"
echo -e "${GREEN}Pushed. Watch the publish workflow under the repo's Actions tab.${NC}"
