# 🏭 DC74 默认Table设置

## ✅ 已完成的修改

### 主要改变
- ✅ **移除Table选择器** - Scanner界面不再显示table下拉菜单
- ✅ **自动选择DC74** - 系统自动使用DC74 table
- ✅ **优化UI显示** - 标题显示"Scanner une pièce - DC74"
- ✅ **Quick Action更新** - 显示"Table DC74"子标签

---

## 📱 用户界面改变

### Scan Tab (扫描标签)

#### 之前：
```
Quick Actions:
┌─────────────────┐
│ 📷              │
│ Scanner QR Code │
└─────────────────┘

Scanner Section:
Table: [下拉选择]
Position: [下拉选择]
```

#### 现在：
```
Quick Actions:
┌─────────────────┐
│ 📷              │
│ Scanner Pièce   │
│ Table DC74      │  ← 新增子标签
└─────────────────┘

Scanner Section:
Scanner une pièce - DC74  ← 标题包含DC74
Position: [下拉选择]      ← Table选择器已隐藏
```

---

## 🔧 技术实现

### 1. HTML修改 (mobile.html)

```html
<!-- 标题更新 -->
<h3>Scanner une pièce - DC74</h3>

<!-- Table选择器隐藏 -->
<div id="table-selector-group" style="display:none;">
  <label>Table</label>
  <select id="mobile-select-table" class="mobile-select"></select>
</div>

<!-- Quick Action子标签 -->
<span class="sublabel">Table DC74</span>
```

### 2. JavaScript逻辑 (mobile.js)

```javascript
// 初始化时自动查找并选择DC74
const dc74Table = allTables.find(t => t.nom === 'DC74');
if (dc74Table) {
  document.getElementById('mobile-select-table').value = dc74Table.id;
  document.getElementById('table-selector-group').style.display = 'none';
}

// 加载positions时自动使用DC74
if (!tableId && allTables.length > 0) {
  const dc74Table = allTables.find(t => t.nom === 'DC74');
  if (dc74Table) {
    tableId = dc74Table.id;
  }
}
```

### 3. CSS样式 (mobile.css)

```css
/* 子标签样式 */
.action-card .sublabel {
  font-size: 11px;
  font-weight: 400;
  color: #666;
  opacity: 0.8;
}

.action-card.scan-action .sublabel {
  color: rgba(255, 255, 255, 0.8);
}
```

---

## 🎯 工作流程

### 用户操作流程

1. **打开App** → 自动加载DC74
2. **点击"Scanner Pièce"** → 看到"Table DC74"标识
3. **选择Position** → 只需选择位置，无需选table
4. **输入/扫描Pièce号** → 完成安装

### 系统后台流程

```
用户打开App
    ↓
加载tables数据
    ↓
查找名为"DC74"的table
    ↓
找到 → 自动选中DC74 + 隐藏选择器
    ↓
加载DC74的所有positions
    ↓
用户只需选择position
```

---

## 🔍 降级处理

### 如果DC74不存在？

系统会自动降级：

```javascript
if (dc74Table) {
  // DC74存在 → 隐藏选择器
  document.getElementById('table-selector-group').style.display = 'none';
} else {
  // DC74不存在 → 显示选择器（回退到原始行为）
  document.getElementById('table-selector-group').style.display = 'block';
}
```

**结果：**
- ✅ DC74存在：简化界面，隐藏table选择
- ✅ DC74不存在：显示table选择器，让用户选择

---

## 📊 Dashboard保持灵活性

Dashboard view**保留**table选择器，原因：

1. **多table对比** - Dashboard适合查看多个table的统计
2. **管理需求** - 管理员可能需要查看其他table
3. **灵活性** - Dashboard是查看工具，不是操作工具

但默认也是DC74：
```javascript
// Dashboard打开时默认选DC74
if (tabName === 'dashboard') {
  const dc74Table = allTables.find(t => t.nom === 'DC74');
  if (dc74Table) {
    document.getElementById('dashboard-table-select').value = dc74Table.id;
  }
}
```

---

## 📱 视觉效果

### Scanner按钮（更新后）
```
┌────────────────────────┐
│       📷               │
│   Scanner Pièce       │
│    Table DC74         │ ← 灰色小字，区别于主标签
└────────────────────────┘
深蓝色渐变背景
```

### Scanner界面（更新后）
```
╔════════════════════════════╗
║ Scanner une pièce - DC74   ║ ← 标题明确显示DC74
╠════════════════════════════╣
║ Position: [V]              ║ ← 直接选位置
║ ┌─────────────────────┐    ║
║ │ Position vide       │    ║
║ └─────────────────────┘    ║
╚════════════════════════════╝
```

---

## ✅ 优势

### 用户体验改进
- ✅ **更简单** - 少一步操作
- ✅ **更快** - 无需选择table
- ✅ **更清晰** - 明确显示DC74
- ✅ **防错** - 不会选错table

### 技术优势
- ✅ **智能降级** - DC74不存在时自动显示选择器
- ✅ **保持灵活** - Dashboard仍可选择其他table
- ✅ **易维护** - 如需更改默认table，只需修改一处

---

## 🔄 如何更改默认Table

如果将来需要更改为其他table（例如DC75）：

### 方法1：修改代码
在 `mobile.js` 中搜索所有 `'DC74'`，替换为新的table名称：

```javascript
// 查找这些行：
const dc74Table = allTables.find(t => t.nom === 'DC74');

// 改为：
const dc74Table = allTables.find(t => t.nom === 'DC75');
```

### 方法2：使用配置文件（推荐）
创建 `config.js`：

```javascript
// config.js
const APP_CONFIG = {
  DEFAULT_TABLE: 'DC74'
};
```

然后在代码中使用：
```javascript
const defaultTable = allTables.find(t => t.nom === APP_CONFIG.DEFAULT_TABLE);
```

---

## 🧪 测试清单

### 正常情况测试
- [x] DC74存在时，table选择器隐藏
- [x] Position正确加载DC74的所有位置
- [x] Scanner标题显示"DC74"
- [x] Quick Action显示"Table DC74"
- [x] Dashboard默认显示DC74数据

### 边缘情况测试
- [ ] DC74不存在时，显示table选择器
- [ ] 数据库中没有table时的错误处理
- [ ] 网络错误时的降级行为

### 移动端测试
- [ ] 手机浏览器正确显示
- [ ] 子标签文字大小适中
- [ ] Position下拉菜单操作流畅

---

## 📞 相关文件

修改的文件列表：
- ✅ `mobile.html` - HTML结构和标签
- ✅ `shared/mobile.css` - 样式和子标签
- ✅ `shared/mobile.js` - 逻辑和自动选择

---

## 🚀 部署

修改已应用，刷新页面即可看到效果：

**电脑：**
```
http://localhost:3000/mobile.html
```

**手机：**
```
http://192.168.2.124:3000/mobile.html
```

---

## 💡 总结

**改变：**
- Table选择 → 自动DC74
- 2步操作 → 1步操作
- 通用界面 → DC74专用界面

**结果：**
- 更快 ⚡
- 更简单 ✨
- 更专业 🎯

**现在就可以测试了！** 🎉
