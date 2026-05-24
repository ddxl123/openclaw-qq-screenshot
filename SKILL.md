---
name: qq-screenshot
description: Take a full-screen screenshot, compress it to ~1MB JPEG, and send via QQ channel using qqmedia tags. Use when the user asks to screenshot the screen and send it, or says "截图发给我" / "screenshot and send".
---

# QQ Screenshot

Capture the Mac screen, compress to ~1MB, and deliver via QQ bot media.

## Flow

1. Run the bundled script to capture + compress:
   ```bash
   bash ~/.openclaw/workspace/skills/qq-screenshot/scripts/screenshot.sh
   ```
   Output path printed on stdout (always `~/.openclaw/media/qqbot/screenshot.jpg`).

2. Send via QQ media tag:
   ```
   <qqmedia>/Users/<user>/.openclaw/media/qqbot/screenshot.jpg</qqmedia>
   ```
   Replace `<user>` with the actual macOS username (use `$HOME` or `whoami`).

## Cleanup

After sending the screenshot via `<qqmedia>`, **immediately delete the file** to free disk space:

```bash
rm -f ~/.openclaw/media/qqbot/screenshot.jpg
```

This prevents stale screenshots from accumulating in the media directory.

## Notes

- Script uses `screencapture -x` (no sound, captures all displays).
- Binary-searches JPEG quality (10–95) to land within 1MB.
- If screenshot is already <1MB, converts to JPEG at quality 95 without recompression.
- Output is always JPEG for QQ compatibility.
- Requires macOS with `sips` and `screencapture`.
