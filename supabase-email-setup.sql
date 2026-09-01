-- ========================================
-- LAT Scanner - Email Notification System
-- ========================================
-- 在 Supabase SQL Editor 中运行此脚本

-- 创建通知待发送表
CREATE TABLE IF NOT EXISTS pending_notification (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  triggered_at TIMESTAMPTZ DEFAULT NOW(),
  sent_snapshot BOOLEAN DEFAULT FALSE,
  notes TEXT
);

-- 启用 RLS
ALTER TABLE pending_notification ENABLE ROW LEVEL SECURITY;

-- 允许公开访问（因为前端需要插入记录）
DROP POLICY IF EXISTS "Enable all access for anon" ON pending_notification;
CREATE POLICY "Enable all access for anon" ON pending_notification FOR ALL USING (true);

-- 创建索引加速查询
CREATE INDEX IF NOT EXISTS idx_pending_sent ON pending_notification(sent_snapshot, triggered_at);

-- 验证
SELECT 'Email notification table created!' AS status;
