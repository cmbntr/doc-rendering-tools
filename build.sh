#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
cd "${SCRIPT_DIR}" || exit 1

podman build -t localhost/doc-rendering-tools-build:latest --target=deliver .
podman kill drt_build || true
podman run --name drt_build -d --rm -p 9000:8000 localhost/doc-rendering-tools-build:latest
rm -f doc-rendering-tools-img.tar.gz || true
wget http://localhost:9000/doc-rendering-tools-img.tar.gz
podman kill drt_build

dd if=./doc-rendering-tools-img.tar.gz | gunzip | podman load
podman image rm localhost/doc-rendering-tools-build:latest
