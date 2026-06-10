#!/bin/bash
set -e

# Fetches the latest stable Flutter version and updates the build workflow

releases_json=$(curl -s https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json)

channel_hash=$(echo "$releases_json" | jq -r '.current_release.stable')
stable_version=$(echo "$releases_json" | jq -r --arg HASH "$channel_hash" \
    '.releases[] | select(.hash == $HASH).version')

if [ -z "$stable_version" ]; then
    echo "Error: could not fetch latest stable Flutter version"
    exit 1
fi

echo "Latest stable version: $stable_version"

stable_version=$stable_version \
    yq -i '.env.FLUTTER_VERSION = env(stable_version)' .github/workflows/build.yml

exit 0
