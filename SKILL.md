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

After sending the screenshot via `<qqmedia>`, **do NOT delete the file immediately**.

1. 发送截图后，主动询问用户是否收到："截图已发送，请回复'收到'我再清理~"
2. **等用户明确回复**（如 "收到"、"ok"、"好了" 等确认语）后，再删除：
   ```bash
   rm -f ~/.openclaw/media/qqbot/screenshot.jpg
   ```
3. 删除后回复："👌 已清理~"

This ensures the file isn't removed before QQ finishes delivering it.

## Notes

- Script uses `screencapture -x` (no sound, captures all displays).
- Binary-searches JPEG quality (10–95) to land within 1MB.
- If screenshot is already <1MB, converts to JPEG at quality 95 without recompression.
- Output is always JPEG for QQ compatibility.
- Requires macOS with `sips` and `screencapture`.
