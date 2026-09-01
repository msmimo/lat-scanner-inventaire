# 🎯 交互式工作台布局

## ✨ 新功能概述

现在Scanner界面包含一个**可视化的交互式工作台布局图**，用户可以直接点击位置来选择，无需使用下拉菜单。

---

## 📐 布局设计

### 工作台布局（DC74）

```
        — NORD —
┌─────┬─────┬─────┬─────┬─────┐
│ #1  │ #2  │ #3  │ #4  │ #5  │
│ M1  │ M2  │ M3  │ M4  │ M5  │  ← Master (浅灰色)
└─────┴─────┴─────┴─────┴─────┘

┌─────┬─────┬─────┬─────┬─────┐
│ S1  │ S2  │ S3  │ S4  │ S5  │  ← Slave (深灰色)
└─────┴─────┴─────┴─────┴─────┘
        — SUD —
```

### 位置映射

| 行 | 标识 | 位置代码 | 颜色 | 形状 |
|---|------|---------|------|------|
| NORD (上排) | #1-#5 | M1-M5 | 浅灰色 | 方角矩形 |
| SUD (下排) | - | S1-S5 | 深灰色 | 圆角矩形 |

---

## 🎨 视觉设计

### 颜色方案

#### Master位置 (M1-M5)
```css
背景: 浅灰色渐变 (#c4c4c4 → #a8a8a8)
边框: #8a8a8a
文字: 黑色
形状: 8px圆角
```

#### Slave位置 (S1-S5)
```css
背景: 深灰色渐变 (#6b7280 → #4b5563)
边框: #374151
文字: 白色
形状: 12px圆角
```

### 交互状态

#### 1. 默认状态
- Master: 浅灰色
- Slave: 深灰色

#### 2. 悬停状态 (hover)
```css
transform: scale(1.05)
box-shadow: 0 4px 12px rgba(0,0,0,0.15)
```

#### 3. 选中状态 (selected)
- Master: **蓝色渐变** (#3b82f6 → #2563eb)
- Slave: **深蓝色渐变** (#1a2b45 → #0f1a2e)
- 外发光效果
- Scale 1.08

#### 4. 状态指示器

**有件（Occupied）:**
- 右上角绿色圆点 🟢
- #10b981

**空位（Empty）:**
- 右上角灰色圆点 ⚫
- #9ca3af

---

## 🖱️ 交互逻辑

### 点击流程

```javascript
用户点击位置 (例如: M3)
    ↓
selectPosition('M3')
    ↓
查找position数据
    ↓
更新视觉状态（高亮选中）
    ↓
更新隐藏的select值
    ↓
显示位置状态
    ↓
触发haptic feedback（振动10ms）
```

### 函数调用链

```javascript
// 1. 选择位置
selectPosition(positionCode)
  ├─ 查找position对象
  ├─ 更新hidden select
  ├─ 更新视觉高亮
  ├─ 设置currentPosition
  ├─ 调用afficherEtatPositionMobile()
  └─ 触发振动反馈

// 2. 更新状态指示
updatePositionSlots()
  ├─ 获取DC74所有positions
  ├─ 查询已安装的pieces
  ├─ 更新每个slot的occupied/empty状态
  └─ 添加状态指示圆点
```

---

## 📱 用户体验

### 操作流程

**之前（下拉菜单）:**
1. 点击"Scanner Pièce"
2. 打开Position下拉菜单
3. 滚动查找M3
4. 点击选择
5. 继续操作

**现在（可视化布局）:**
1. 点击"Scanner Pièce"
2. **直接点击M3位置** ✨
3. 看到蓝色高亮确认
4. 继续操作

### 优势

- ✅ **直观** - 一眼看到所有位置
- ✅ **快速** - 点击即选，无需滚动
- ✅ **状态可见** - 绿点=有件，灰点=空位
- ✅ **触觉反馈** - 点击有振动确认
- ✅ **美观** - 符合实际工作台布局

---

## 🔧 技术实现

### HTML结构

```html
<div class="table-layout">
  <div class="layout-label">— NORD —</div>
  
  <!-- Master Row -->
  <div class="positions-row north-row">
    <div class="position-slot master" 
         data-position="M1" 
         onclick="selectPosition('M1')">
      <div class="slot-number">#1</div>
      <div class="slot-content">M1</div>
    </div>
    <!-- M2-M5 ... -->
  </div>
  
  <!-- Slave Row -->
  <div class="positions-row south-row">
    <div class="position-slot slave" 
         data-position="S1" 
         onclick="selectPosition('S1')">
      <div class="slot-content">S1</div>
    </div>
    <!-- S2-S5 ... -->
  </div>
  
  <div class="layout-label">— SUD —</div>
</div>
```

### CSS关键样式

```css
/* 网格布局 */
.positions-row {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 8px;
}

/* 可点击区域 */
.position-slot {
  aspect-ratio: 1;
  min-height: 60px;
  cursor: pointer;
  transition: all 0.2s ease;
}

/* 状态指示器 */
.position-slot.occupied::after {
  content: '';
  width: 10px;
  height: 10px;
  background: #10b981; /* 绿色 */
  border-radius: 50%;
}
```

### JavaScript核心函数

```javascript
// 选择位置
function selectPosition(positionCode) {
  const position = allPositions.find(p => 
    p.code_position === positionCode
  );
  
  // 更新选中状态
  document.querySelectorAll('.position-slot')
    .forEach(slot => slot.classList.remove('selected'));
  
  document.querySelector(`[data-position="${positionCode}"]`)
    .classList.add('selected');
  
  // 更新当前位置
  currentPosition = position;
  afficherEtatPositionMobile();
  
  // 触觉反馈
  if (navigator.vibrate) {
    navigator.vibrate(10);
  }
}

// 更新状态指示
async function updatePositionSlots() {
  const pieces = await sbSelect('pieces', 
    `*&position_id=in.(${positionIds.join(',')})`
  );
  
  const occupiedPositionIds = new Set(
    pieces.map(p => p.position_id)
  );
  
  positions.forEach(pos => {
    const slot = document.querySelector(
      `[data-position="${pos.code_position}"]`
    );
    
    if (occupiedPositionIds.has(pos.id)) {
      slot.classList.add('occupied');
    } else {
      slot.classList.add('empty');
    }
  });
}
```

---

## 📊 响应式设计

### 小屏幕优化 (< 375px)

```css
@media (max-width: 375px) {
  .position-slot {
    min-height: 50px;  /* 降低高度 */
    font-size: 14px;   /* 缩小字体 */
  }
  
  .slot-content {
    font-size: 16px;   /* 保持可读性 */
  }
}
```

### 大屏幕优化 (> 768px)

布局自动居中，最大宽度600px，保持紧凑。

---

## 🎯 使用场景

### 场景1: 快速安装
```
操作员拿着零件走到M3位置
    ↓
打开手机APP
    ↓
点击"Scanner Pièce"
    ↓
直接点击M3（蓝色高亮）
    ↓
输入零件号
    ↓
完成！
```

### 场景2: 检查状态
```
管理员想知道哪些位置有件
    ↓
打开Scanner界面
    ↓
一眼看到：
  - M1, M3, S2有绿点（有件）
  - M2, M4, M5, S1, S3, S4, S5灰点（空位）
```

### 场景3: 快速替换
```
需要替换S4位置的零件
    ↓
点击S4（看到绿点 = 确认有件）
    ↓
扫描新零件
    ↓
自动完成替换
```

---

## 🔄 自动更新时机

位置状态会在以下时机自动更新：

1. **初始化时** - `init()`
2. **打开Scanner时** - `demarrerScan()`
3. **安装成功后** - `installerPiece()`
4. **切换Tab回来时** - 可选增强

---

## 🧪 测试清单

### 视觉测试
- [ ] Master位置显示浅灰色
- [ ] Slave位置显示深灰色
- [ ] NORD和SUD标签正确显示
- [ ] 位置号码（#1-#5）显示在上排
- [ ] 网格对齐整齐

### 交互测试
- [ ] 点击M1-M5正常选中
- [ ] 点击S1-S5正常选中
- [ ] 选中后显示蓝色高亮
- [ ] 悬停时有scale效果
- [ ] 手机有振动反馈（如支持）

### 状态测试
- [ ] 有件位置显示绿色圆点
- [ ] 空位显示灰色圆点
- [ ] 状态文本正确显示
- [ ] 安装后状态自动更新

### 响应式测试
- [ ] 小屏手机正常显示
- [ ] 大屏手机正常显示
- [ ] 平板设备正常显示
- [ ] 横屏模式正常显示

---

## 💡 未来增强

### 短期优化
1. **长按显示详情**
   - 长按位置查看完整信息
   - 显示零件号、安装时间等

2. **颜色编码**
   - 不同状态用不同颜色
   - 例如：需维护=黄色

3. **动画效果**
   - 安装成功时的脉冲动画
   - 位置切换的过渡效果

### 中期优化
4. **批量操作**
   - 多选位置
   - 批量查看状态

5. **搜索高亮**
   - 输入零件号后高亮所在位置

6. **历史记录**
   - 显示最近操作的位置

### 长期优化
7. **3D视图**
   - 立体化的工作台视图
   - 更真实的空间感

8. **AR增强**
   - 摄像头叠加显示
   - 扫描实际工作台时显示数据

---

## 📞 技术支持

### 相关文件
- `mobile.html` - 布局HTML结构
- `shared/mobile.css` - 样式定义（.table-layout, .position-slot）
- `shared/mobile.js` - 交互逻辑（selectPosition, updatePositionSlots）

### 调试命令
```javascript
// 控制台查看当前位置
console.log(currentPosition);

// 强制刷新状态
updatePositionSlots();

// 查看所有位置数据
console.log(allPositions);
```

---

## ✨ 总结

**改进前:**
- 下拉菜单选择
- 需要滚动查找
- 无法看到整体状态

**改进后:**
- 可视化布局图
- 点击即选
- 状态一目了然
- 符合真实工作台布局

**用户反馈预期:**
- 更直观 👍
- 更快速 ⚡
- 更专业 🎯

---

**立即体验：**
```
http://localhost:3000/mobile.html
或
http://192.168.2.124:3000/mobile.html
```

点击"Scanner Pièce"查看新的交互式布局！🎉
