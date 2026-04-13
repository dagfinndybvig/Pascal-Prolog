#!/usr/bin/env sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$SCRIPT_DIR"

BIN_PATH=$(mktemp /tmp/pascal_hello.XXXXXX)
trap 'rm -f "$BIN_PATH"' EXIT INT TERM

swipl -q -s pascal_compiler.pl -- build examples/hello.pas "$BIN_PATH"
"$BIN_PATH"
