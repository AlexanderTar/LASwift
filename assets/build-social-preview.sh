#!/usr/bin/env bash
# Renders assets/social-preview.html to assets/social-preview.png (1280x640, the GitHub
# social preview size) and assets/icon.png (512x512, the README header icon) with headless
# Chrome. Set CHROME to use a different browser binary.
set -euo pipefail
dir="$(cd "$(dirname "$0")" && pwd)"
chrome="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
"$chrome" --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=1 \
  --window-size=1280,640 --screenshot="$dir/social-preview.png" "file://$dir/social-preview.html" >/dev/null 2>&1
"$chrome" --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=1 \
  --default-background-color=00000000 \
  --window-size=512,512 --screenshot="$dir/icon.png" "file://$dir/social-preview.html?icon" >/dev/null 2>&1
sips -g pixelWidth -g pixelHeight "$dir/social-preview.png" "$dir/icon.png"
