#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
NODE_DIR="$ROOT_DIR/.local/node-v18.20.8-linux-x64/bin"

if [ ! -x "$NODE_DIR/node" ]; then
  echo "Local Node 18 not found at: $NODE_DIR" >&2
  echo "Expected setup under $ROOT_DIR/.local" >&2
  exit 1
fi

export PATH="$NODE_DIR:$PATH"
exec "$@"
