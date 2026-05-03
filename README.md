# memory-refining

三层记忆分层与自动提炼系统 for OpenClaw。

---

## 核心理念

记忆系统不是越多越好，而是**分层清晰、只进验证过的内容**。

```
Layer 1: 日志层（原始积累）
    ↓ 每周自动提炼
Layer 2: 提炼区（结构化整理）
    ↓ 人工确认 promote
Layer 3: 长期记忆（经过验证的决策）
```

---

## 功能特性

### 🗂️ 三层架构

| 层级 | 文件 | 内容 | 管理方式 |
|------|------|------|---------|
| Layer 1 | `memory/YYYY-MM-DD.md` | 每日原始日志，进什么记什么 | 不做过滤 |
| Layer 2 | `memory/refining/YYYY-Wnn.md` | 每周提炼结果 | cron 自动生成 |
| Layer 3 | `MEMORY.md` | 长期记忆 | 显式 promote 规则 |

### 📋 Active Projects 追踪

每个活跃项目一条记录，自动在每次 session 加载：
- 当前阶段 / 阻断因素 / 下一步行动
- 超过3个月无更新自动归档

### ⚙️ 自动提炼 Cron

每周日 22:00 自动执行：
1. 扫描本周所有日志
2. 提取高优先级 `**...**` 条目
3. 生成 `refining/YYYY-Wnn.md` 提炼文件
4. 由 agent 判断 promote 进 MEMORY.md

---

## 安装方式

### 方式一：直接安装（推荐）

```bash
clawhub install memory-refining
```

### 方式二：从源码安装

```bash
# 克隆仓库
git clone https://github.com/rexlei-rgb/openclaw-memory-refining.git
# 进入目录
cd openclaw-memory-refining
# 打包 skill
tar -czf memory-refining.skill SKILL.md scripts/
```

### 方式三：通过 OpenClaw Web UI

上传 `memory-refining.skill` 文件到 OpenClaw 安装。

---

## 目录结构

```
openclaw-memory-refining/
├── README.md                    # 本文件
├── LICENSE                    # MIT 开源协议
├── SKILL.md                   # Skill 定义（触发条件 + 使用说明）
├── scripts/
│   └── memory-refining.sh     # 每周自动提炼脚本
└── memory-refining.skill     # 打包好的 skill 文件
```

---

## 文件说明

### SKILL.md

Skill 定义文件，包含：
- 触发条件（description）
- 三层架构说明
- 日志格式规范
- active-projects 格式
- cron 配置说明

### scripts/memory-refining.sh

自动提炼脚本，功能：
- 扫描本周日志（`memory/*.md`）
- 提取高优先级条目（`**包裹的内容**`）
- 生成 `refining/YYYY-Wnn.md` 文件
- 由 agent 后续处理 promote 逻辑

---

## 使用说明

### 每日日志写入

每个 session 结束时，自动或手动写入：

```markdown
# YYYY-MM-DD 日志

## 今天完成的事

## 项目断点更新

## 雷雨反馈

## 待补充
- [ ]
```

### 高优先级标记

日志中使用 `**...**` 包裹的内容会被自动提取进提炼区：

```markdown
今天完成了 **小红书浏览器控制打通** 这个重要里程碑
```

### Active Projects 更新

每次项目有实质性进展时更新 `memory/active-projects.md`：

```markdown
## 项目名称
- 启动: YYYY-MM-DD
- 阶段: 当前状态
- 阻断: 有/无
- 下一步: 明确的下一步行动
- 更新: YYYY-MM-DD
```

### Promote 规则

进入 Layer 3 (MEMORY.md) 的内容必须是：
- ✅ 经过验证的决策（不是猜测）
- ✅ 有明确的项目状态
- ✅ 标注来源日期
- ❌ 不是临时想法或中间过程

---

## Cron 任务配置

skill 安装后会自动注册每周日 22:00 的 cron 任务。

查看当前 cron 任务：

```bash
openclaw cron list
```

手动触发提炼：

```bash
cd memory && bash memory-refining.sh
```

---

## 依赖要求

- OpenClaw Pi 版本
- xvfb-run（用于无头浏览器场景，如需）
- bash 环境
- python3（用于日期计算）

---

## 作者

**rexlei-rgb** (rex.lei@icloud.com)

---

## License

MIT License - 随便用，保留署名即可。
