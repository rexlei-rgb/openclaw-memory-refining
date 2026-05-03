#!/bin/bash
# memory-refining.sh
# 每周日22:00自动运行，从本周日志提炼要点到refining目录

WORKSPACE="/home/rexlei/.openclaw/workspace"
MEMORY="$WORKSPACE/memory"
DATE=$(date +%Y-%m-%d)
WEEK=$(date +%G-W%V)

echo "[$DATE] 开始记忆提炼..."

# 获取本周日志
cd "$MEMORY" || exit 1

# 找本周的日志文件
WEEK_LOGS=$(ls [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9].md 2>/dev/null | while read f; do
  fdate=$(basename "$f" .md)
  fsec=$(date -d "$fdate" +%s 2>/dev/null)
  weekstart=$(date -d "last monday" +%s 2>/dev/null)
  weekend=$(date -d "next sunday" +%s 2>/dev/null)
  if [ -n "$fsec" ] && [ "$fsec" -ge "$weekstart" ] && [ "$fsec" -le "$weekend" ]; then
    echo "$f"
  fi
done)

if [ -z "$WEEK_LOGS" ]; then
  echo "本周无日志，跳过提炼"
  exit 0
fi

# 生成提炼文件
REFINING_FILE="$MEMORY/refining/${WEEK}.md"
cat > "$REFINING_FILE" << EOF
# 提炼区 - $WEEK

> 生成时间: $DATE

---

## 本周日志来源
$(echo "$WEEK_LOGS" | sed 's/^/- /')

## 重要事件提取

EOF

# 从日志中提取高优先级条目（**包裹的内容）
for log in $WEEK_LOGS; do
  echo "### 来源: $log" >> "$REFINING_FILE"
  grep -E '\*\*[^*]+\*\*' "$log" 2>/dev/null | sed 's/^/  /' >> "$REFINING_FILE" || echo "  (无高优先级条目)" >> "$REFINING_FILE"
  echo "" >> "$REFINING_FILE"
done

cat >> "$REFINING_FILE" << EOF

## 项目断点更新

-

## 待决事项

- [ ]

## 可丢弃

-

## 待Promote至长期记忆

-

---

*由书虾自动生成，请确认后执行promote操作*
EOF

echo "[$DATE] 提炼完成: $REFINING_FILE"
