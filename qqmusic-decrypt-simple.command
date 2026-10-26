#!/bin/bash
# qqmusic-decrypt 简化版启动器
# 用法：把本脚本放到要解密的音乐所在目录，双击运行（或终端执行 ./qqmusic-decrypt-simple.command）
# 逻辑：
#   1. 若 ~/Library/QQMusicDecrypted/qqmusic-decrypt-mac-simple 已存在 → 直接运行
#   2. 否则检查当前目录是否有 qqmusic-decrypt-mac-simple：
#      - 有 → 移动到 ~/Library/QQMusicDecrypted/ 后运行
#      - 没有 → 提示缺少二进制并退出
# 程序会自动解密当前目录，输出到 ~/Music/QQMusicDecrypted/，完成后按 Enter 退出。
set -u
cd "$(dirname "$0")" || exit 1

DEST_DIR="$HOME/Library/QQMusicDecrypted"
DEST_BIN="$DEST_DIR/qqmusic-decrypt-mac-simple"

run_bin() {
  xattr -dr com.apple.quarantine "$DEST_BIN" 2>/dev/null
  chmod +x "$DEST_BIN" 2>/dev/null
  # --simple：直接解密当前目录（本脚本所在目录），输出 ~/Music/QQMusicDecrypted/，完成按 Enter 退出
  exec "$DEST_BIN" --simple
}

if [ -f "$DEST_BIN" ]; then
  run_bin
fi

if [ -f "./qqmusic-decrypt-mac-simple" ]; then
  mkdir -p "$DEST_DIR"
  mv -f "./qqmusic-decrypt-mac-simple" "$DEST_BIN"
  run_bin
fi

echo "qqmusic-decrypt-mac-simple 不存在"
echo "请把 qqmusic-decrypt-mac-simple 放到当前目录后重新打开本脚本。"
read -r -p "按 Enter 退出..." _
exit 1
