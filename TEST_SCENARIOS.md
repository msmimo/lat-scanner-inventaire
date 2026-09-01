# 🧪 测试场景 - 扫描工作流程

## 📋 测试准备

在Supabase中准备一些测试数据：

```sql
-- 1. 创建一个"Inventaire - Prêt"的零件
INSERT INTO pieces (no_piece, statut) VALUES ('TEST001', 'Inventaire - Prêt');

-- 2. 创建一个"Chez Huot"的零件
INSERT INTO pieces (no_piece, statut) VALUES ('TEST002', 'Chez Huot');

-- 3. 创建一个"Remisée - Rebutée"的零件
INSERT INTO pieces (no_piece, statut) VALUES ('TEST003', 'Remisée - Rebutée');

-- 4. 创建一个"Inventaire - À entretenir"的零件
INSERT INTO pieces (no_piece, statut) VALUES ('TEST004', 'Inventaire - À entretenir');
```

---

## 🎯 测试场景

### 场景1️⃣: 全新零件

**步骤：**
1. 扫描一个不存在的零件号（如：`999888`）
2. 应该弹出确认：
   ```
   🆕 NOUVELLE PIÈCE: 999888
   
   Confirmez-vous la mise en production de cette nouvelle pièce ?
   ```
3. 点击"确定"
4. **预期结果：**
   - ✅ 零件直接创建并安装
   - ✅ 状态直接是"Mise en production"
   - ✅ 位置变绿色
   - ✅ Toast提示："✓ Nouvelle pièce 999888 créée et installée sur M1"

---

### 场景2️⃣: Inventaire - Prêt（最流畅）

**步骤：**
1. 扫描零件：`TEST001`
2. **预期结果：**
   - ✅ **无需任何确认**
   - ✅ 直接安装成功
   - ✅ 位置变绿色
   - ✅ Toast提示："✓ Pièce TEST001 installée sur M1"

---

### 场景3️⃣: Remisée - Rebutée（禁止）

**步骤：**
1. 扫描零件：`TEST003`
2. **预期结果：**
   - ❌ **立即被拒绝**
   - ❌ 显示："🚫 Pièce rebutée - Installation interdite"
   - ❌ Toast错误消息：
     ```
     🚫 Cette pièce est rebutée.
     
     Informer le superviseur ou le groupe technique.
     ```
   - ❌ 位置保持原样，不安装

---

### 场景4️⃣: Chez Huot（需要选择maintenance）

**步骤：**
1. 扫描零件：`TEST002`
2. 应该弹出选择：
   ```
   🔧 MAINTENANCE REQUISE
   
   La pièce TEST002 est au statut: "Chez Huot"
   
   Quel type de maintenance a été effectué ?
   
   1. Entretien général (sablage, test d'huile, test d'eau)
   2. Huile - changement de gasket
   3. Huile - débouchage des trous
   4. Eau - changement de gasket
   5. Eau - débouchage des trous
   6. Eau - nettoyage du filtre de coin
   7. Autre (préciser)
   
   Entrez le numéro (ou Annuler):
   ```
3. 输入：`2`（Huile - changement de gasket）
4. **预期结果：**
   - ✅ 零件安装成功
   - ✅ 在`entretiens`表中创建记录
   - ✅ 位置变绿色
   - ✅ Toast提示："✓ Pièce TEST002 installée sur M1"

---

### 场景5️⃣: À entretenir + Autre maintenance

**步骤：**
1. 扫描零件：`TEST004`
2. 弹出maintenance选择
3. 输入：`7`（Autre）
4. 弹出输入框："Précisez le type de maintenance:"
5. 输入：`Réparation spéciale`
6. **预期结果：**
   - ✅ 零件安装成功
   - ✅ 在`entretiens`表中创建记录，包含"Réparation spéciale"
   - ✅ 位置变绿色

---

### 场景6️⃣: 已在production的零件（移动）

**步骤：**
1. 先安装TEST001到M1
2. 再扫描TEST001到M2
3. 应该弹出警告：
   ```
   ⚠️ ATTENTION
   
   La pièce TEST001 est déjà en production ailleurs.
   
   Confirmez-vous le déplacement vers cette position ?
   ```
4. 点击"确定"
5. **预期结果：**
   - ✅ 零件从M1移动到M2
   - ✅ M1变回灰色
   - ✅ M2变绿色

---

## ✅ 验证检查清单

测试完成后，验证：

- [ ] **pieces表**：零件的statut都更新为"Mise en production"
- [ ] **pieces表**：position_id指向正确的位置
- [ ] **historique表**：每次操作都有记录
- [ ] **audit表**：每次操作都有审计日志
- [ ] **entretiens表**：maintenance操作有记录（场景4、5）

---

## 🔍 SQL查询验证

```sql
-- 查看所有零件状态
SELECT no_piece, statut, position_id FROM pieces WHERE no_piece LIKE 'TEST%';

-- 查看历史记录
SELECT no_piece, type_action, ancien_statut, nouveau_statut, code_position 
FROM historique 
WHERE no_piece LIKE 'TEST%' 
ORDER BY debut_statut DESC;

-- 查看maintenance记录
SELECT p.no_piece, e.type_entretien, e.raison, e.effectue_par, e.created_at
FROM entretiens e
JOIN pieces p ON p.id = e.piece_id
WHERE p.no_piece LIKE 'TEST%'
ORDER BY e.created_at DESC;

-- 查看audit日志
SELECT type_entite, action, effectue_par, created_at
FROM audit
WHERE created_at > NOW() - INTERVAL '1 hour'
ORDER BY created_at DESC;
```

---

## 🎉 全部测试通过的标志

- ✅ 所有6个场景都按预期工作
- ✅ 数据库记录完整正确
- ✅ 用户体验流畅
- ✅ 错误提示清晰明确
