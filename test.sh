#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
cd "${SCRIPT_DIR}" || exit 1

function drt() {
  podman run --rm -it --workdir /work -v "$(pwd):/work:Z" --tmpfs=/tmp \
  --userns keep-id --group-add keep-groups --user "$(id -u):$(id -g)" \
  localhost/doc-rendering-tools:latest $@
}

mkdir -p ./test-output || true
drt pandoc --list-output-formats > ./test-output/formats.txt
drt pandoc -F pandoc-imagine TEST.md -o ./test-output/TEST.html -t html5 -s --metadata title="TEST"
drt pandoc -F pandoc-imagine TEST.md -o ./test-output/TEST.pdf
