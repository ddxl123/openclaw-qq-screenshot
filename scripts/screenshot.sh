#!/bin/bash
# screenshot.sh — Full-screen screenshot → compress to ~1MB JPEG
# Usage: screenshot.sh [output_path]
# If output_path is omitted, writes to ~/.openclaw/media/qqbot/screenshot.jpg

set -euo pipefail

MEDIA_DIR="$HOME/.openclaw/media/qqbot"
OUTPUT="${1:-$MEDIA_DIR/screenshot.jpg}"
TMP_PNG=$(mktemp /tmp/oc-screenshot-XXXXXX.png)

mkdir -p "$MEDIA_DIR"

# 1. Capture full screen
screencapture -x "$TMP_PNG"

# 2. Get original size
ORIG_SIZE=$(stat -f%z "$TMP_PNG")
TARGET_BYTES=1048576  # 1MB

if [ "$ORIG_SIZE" -le "$TARGET_BYTES" ]; then
  # Already under 1MB, convert to JPEG as-is
  sips -s format jpeg -s formatOptions 95 "$TMP_PNG" --out "$OUTPUT" >/dev/null 2>&1
else
  # Binary search for the right quality to hit ~1MB
  LO=10; HI=95; BEST=50
  while [ "$LO" -le "$HI" ]; do
    MID=$(( (LO + HI) / 2 ))
    sips -s format jpeg -s formatOptions "$MID" "$TMP_PNG" --out "$OUTPUT" >/dev/null 2>&1
    SIZE=$(stat -f%z "$OUTPUT")
    if [ "$SIZE" -le "$TARGET_BYTES" ]; then
      BEST="$MID"
      LO=$(( MID + 1 ))
    else
      HI=$(( MID - 1 ))
    fi
  done
  # Final render with best quality
  sips -s format jpeg -s formatOptions "$BEST" "$TMP_PNG" --out "$OUTPUT" >/dev/null 2>&1
fi

rm -f "$TMP_PNG"

FINAL_SIZE=$(stat -f%z "$OUTPUT")
echo "$OUTPUT"
echo "size=${FINAL_SIZE}"
