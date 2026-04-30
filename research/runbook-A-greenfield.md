# Runbook A：白纸构建（Greenfield Design）

> 从零构建最优组合，**完全不看当前组合**。
> 用户说"给我看一个新组合""重新构建"时走这个。
> 产出是"理论最优组合"，**不走提案流程**，**不能执行**。

---

## 🚨 执行方式（强制）

**主 Claude 不参与推导。** 必须 spawn subagent 跑 6 步流程，主 Claude 只做 3 件事：

1. spawn subagent（subagent_type: "general-purpose"），用 `.claude/commands/greenfield.md` 里的 prompt 模板
2. 等 subagent 输出报告
3. **原样转述** subagent 报告，顶部加一行 `[白纸构建，未对照当前组合]`

**禁止：**
- ❌ 主 Claude 自己跑 6 步（必污染当前组合视角）
- ❌ 收到报告后追加"和当前组合对比"段
- ❌ 收到报告后追加"建议执行"段

## 触发

- 用户说 `/greenfield` slash command
- 用户说"白纸构建"、"重新构建组合"、"如果从零开始你会怎么配"、"理论最优是什么"

## 绝对禁止（subagent 必须遵守）

- ❌ 读 `investment/portfolio-config.txt` / `portfolio-versions.md` / `holding-summary.md`
- ❌ 读 CLAUDE.md "当前组合"段 / "当前版本审核结论"段 / "历史决策记录"段
- ❌ 报告里出现"当前组合"或具体版本号
- ❌ 解释"和当前组合差在哪"
- ❌ 给"建议执行"结论
- ❌ 走提案流程
- ❌ 触发 portfolio-config 修改

## Subagent 推导流程（6 步）

### Step 1：IPS 约束加载
列出：年化目标、风控阈值、持仓约束、税务约束、Horizon。

### Step 2：宏观 Regime
当前市场定位。

### Step 3：SAA + 行业倾斜
基于约束 + regime 的大类和行业分配。

### Step 4：候选池 + 8 filter 评分
从全市场筛到 15-30 只候选，跑 8 filter。

### Step 5：数学化权重
Kelly + MVO 推权重，应用穿透和板块约束。

### Step 6：最终组合 + 压力测试

## 输出格式

```markdown
# 白纸构建组合 [YYYY-MM-DD]

**类型：** 研究（非执行）

## 推导过程
[Step 1-5 过程]

## 最终组合
| 代码 | 权重 | 评分 | Kelly/4 |
|---|---|---|---|
| ... | | | |

## 压力测试
2008 / 2022 / 2020 / 2000 回撤 vs IPS 阈值

## 预期回报
年化估算

## 使用说明
- 本报告是"理论最优"参考
- 不提议执行
- 不和当前组合对比
- 如果今天从零开始建仓，这就是答案
```

**没有 "vs 当前组合" 段落。没有 "执行建议"。没有 "差异说明"。**

---

## 用户用法

- 好奇理论最优长什么样 → 对照当前组合自己比（不是 Claude 比）
- 想验证 Claude 有没有偏向当前组合 → 看白纸构建是否真的从头推
- **不是**用来决定换不换股

---

## 版本

v1.0。
