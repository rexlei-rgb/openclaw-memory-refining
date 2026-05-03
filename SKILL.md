---
name: memory-refining
description: 三层记忆分层与自动提炼系统。当需要建立/维护记忆系统、设计记忆方案、或执行每周记忆提炼时触发。包含日/提炼/长期三层架构、active-projects项目追踪、memory-refining.sh自动脚本、Cron每周22:00自动执行提炼任务。
---

# Memory Refining - 记忆分层与自动提炼

## 核心理念

记忆系统不是越多越好，而是分层清晰、只进验证过的内容。

三层架构：
- **Layer 1**: `memory/YYYY-MM-DD.md` — 每日原始日志，进什么记什么，不过滤
- **Layer 2**: `memory/refining/YYYY-Wnn.md` — 每周提炼区，由 cron 自动生成
- **Layer 3**: `MEMORY.md` — 长期记忆，只有经过验证的决策才能进

## 文件结构

```
memory/
├── YYYY-MM-DD.md          # 每日日志
├── refining/
│   └── YYYY-Wnn.md        # 每周提炼结果（cron自动生成）
├── active-projects.md     # 活跃项目追踪，每个session自动加载
└── memory-refining.sh     # 提炼脚本
```

## 日志格式

每个 session 结束时写入 `memory/YYYY-MM-DD.md`：

```markdown
# YYYY-MM-DD 日志

## 今天完成的事

## 项目断点更新

## 雷雨反馈

## 待补充
```

## 每周提炼脚本

位置：`scripts/memory-refining.sh`

功能：
1. 扫描本周所有日志文件
2. 提取 `**高优先级**` 条目
3. 生成 `refining/YYYY-Wnn.md` 提炼文件
4. 由 agent 判断哪些 promote 进 MEMORY.md 或更新 active-projects.md

## Active Projects 追踪

每个活跃项目一条记录，格式：

```markdown
## 项目名称
- 启动: YYYY-MM-DD
- 目标: 简短描述
- 阶段: 当前状态
- 阻断: 有/无
- 下一步: 明确的下一步行动
- 更新: YYYY-MM-DD
```

超过3个月无更新的项目移入归档。

## Cron 提炼任务

每周日 22:00 自动执行 `memory-refining.sh`，然后：
1. 读取生成的 refining 文件
2. 判断哪些内容需要 promote 进 MEMORY.md
3. 更新 active-projects.md 中的项目状态
4. 如有重要事项，创建 `memory/refining/PENDING-ALERT.md` 待确认

## MEMORY.md 写入规则

- 必须是经过验证的决策（不是猜测）
- 项目必须有明确当前状态
- 每条标注来源日期
- 冲突时覆盖并注明

## 使用场景

- 用户问"我的记忆系统怎么设计" → 激活此 skill
- 需要执行每周提炼 → 跑 `scripts/memory-refining.sh`
- 新 session 开始 → 自动加载 `memory/active-projects.md`
- 需要写日志 → 写入 `memory/YYYY-MM-DD.md`