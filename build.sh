#!/bin/bash
# Build helper for caustic-sdl3
# Works around stack alignment bug in the Caustic compiler
# Usage: ./build.sh <source.cst> [-o output] [extra ld flags...]

set -e

SRC="$1"
shift

OUT="/tmp/$(basename "$SRC" .cst)"
LDFLAGS="-lSDL3"

while [[ $# -gt 0 ]]; do
    case "$1" in
        -o) OUT="$2"; shift 2 ;;
        *) LDFLAGS="$LDFLAGS $1"; shift ;;
    esac
done

# 1. Compile
caustic "$SRC"

# 2. Fix stack alignment (compiler bug: uses sub/add rsp,60 instead of 56)
sed -i 's/sub rsp, 60/sub rsp, 56/g; s/add rsp, 60/add rsp, 56/g' "$SRC.s"

# 3. Assemble
caustic-as "$SRC.s"

# 4. Link
caustic-ld "$SRC.s.o" $LDFLAGS -o "$OUT"

echo "Built: $OUT"
