#!/bin/sh
echo -ne '\033c\033]0;2D Platformer\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/2D Platformer.exe.x86_64" "$@"
