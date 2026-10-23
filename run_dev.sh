#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 <ios|android> <device-id>" >&2
  echo "Find device IDs with: flutter devices" >&2
}

if [[ $# -ne 2 ]]; then
  usage
  exit 2
fi

platform="$1"
case "$platform" in
  ios|android) ;;
  *)
    usage
    exit 2
    ;;
esac

device_id="$2"

exec flutter run \
  --target=lib/main.dart \
  --device-id="$device_id" \
  --dart-define=BACKEND_URL=https://rickandmortyapi.com \
  --dart-define=ENVIRONMENT=Dev \
  --dart-define=cronetHttpNoPlay=true
