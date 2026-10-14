#!/usr/bin/env bash
set -euo pipefail

WATCH=0
MANUAL=0

for arg in "$@"; do
    case "$arg" in
        --watch)  WATCH=1 ;;
        --manual) MANUAL=1 ;;
        *) echo "Unknown argument: $arg" >&2; exit 2 ;;
    esac
done

if (( WATCH )); then
    args=()
    if (( MANUAL )); then
        args+=(--manual)
    fi

    # Re-run this script on changes. If --meson was given, keep it.
    watchexec -e vala -r -- "$0" "${args[@]}"
    exit 0
fi

if (( MANUAL )); then
    valac                               \
        -X -Wno-discarded-qualifiers    \
        --pkg gtk4                      \
        -o ./builddir/src/galculator    \
        ./src/Galculator.vala
    ./builddir/src/galculator
    exit 0
fi

[[ -d builddir ]] || meson setup builddir
meson compile -C builddir
meson devenv -C builddir ./builddir/src/galculator
