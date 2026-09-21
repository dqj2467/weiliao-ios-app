#!/usr/bin/env bash
# 把 xcodegen 生成的 Xcode 16 格式工程（objectVersion 77）降级为 Xcode 14/15 可读格式
# 原因：云端 macos-14 运行器默认 Xcode 15.4，无法打开格式 77 的工程文件
set -e

PBX="Weiliao.xcodeproj/project.pbxproj"

if [ ! -f "$PBX" ]; then
  echo "!! 找不到 $PBX"
  exit 1
fi

echo "== 降级前 =="
grep -E "objectVersion|compatibilityVersion" "$PBX" || true

# 1) 工程格式版本降到 56（Xcode 14 格式，Xcode 15 可正常打开）
sed -i '' -E 's/objectVersion = [0-9]+;/objectVersion = 56;/g' "$PBX"

# 2) 删除 Xcode 16 新增的 preferredProjectObjectVersion 字段
sed -i '' -E '/preferredProjectObjectVersion = [0-9]+;/d' "$PBX"

# 3) 兼容性版本一并降级，避免 Xcode 15 再次报错
sed -i '' -E 's/compatibilityVersion = "Xcode [0-9.]+";/compatibilityVersion = "Xcode 14.0";/g' "$PBX"

echo "== 降级后 =="
grep -E "objectVersion|compatibilityVersion" "$PBX" || true
echo "== 工程格式处理完成 =="
