#!/usr/bin/env bash

set -euo pipefail && \
source .env && \
sudo mkdir -p "$HOST_DATA"/{plugins,} "$HOST_MUSIC" && \
sudo chown -R "$USER":"$USER" "$HOST_DATA" "$HOST_MUSIC"