-- ========================================
-- LAT Scanner Inventaire - Supabase Setup
-- ========================================
-- Copier-coller ce script dans Supabase SQL Editor
-- (Table Editor → SQL Editor → New query)

-- 1. TABLE: tables_travail
CREATE TABLE IF NOT EXISTS tables_travail (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  nom TEXT NOT NULL UNIQUE,
  description TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

INSERT INTO tables_travail (nom, description)
VALUES ('DC74', 'Table DC74 - APEX Mobile Scanner')
ON CONFLICT (nom) DO NOTHING;

-- 2. TABLE: positions
CREATE TABLE IF NOT EXISTS positions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  table_id UUID REFERENCES tables_travail(id),
  code_position TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(table_id, code_position)
);

INSERT INTO positions (table_id, code_position)
SELECT
  (SELECT id FROM tables_travail WHERE nom = 'DC74'),
  code
FROM (
  SELECT 'M1' AS code UNION ALL SELECT 'M2' UNION ALL SELECT 'M3' UNION ALL SELECT 'M4' UNION ALL SELECT 'M5'
  UNION ALL
  SELECT 'S1' UNION ALL SELECT 'S2' UNION ALL SELECT 'S3' UNION ALL SELECT 'S4' UNION ALL SELECT 'S5'
) AS positions
ON CONFLICT (table_id, code_position) DO NOTHING;

-- 3. TABLE: pieces
CREATE TABLE IF NOT EXISTS pieces (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  no_piece TEXT NOT NULL UNIQUE,
  statut TEXT NOT NULL DEFAULT 'Inventaire - Prêt',
  position_id UUID REFERENCES positions(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Auto-update updated_at
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS pieces_updated_at ON pieces;
CREATE TRIGGER pieces_updated_at
BEFORE UPDATE ON pieces
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

-- 4. TABLE: historique
CREATE TABLE IF NOT EXISTS historique (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  piece_id UUID REFERENCES pieces(id),
  no_piece TEXT NOT NULL,
  ancien_statut TEXT,
  nouveau_statut TEXT NOT NULL,
  type_action TEXT NOT NULL,
  position_id UUID REFERENCES positions(id),
  code_position TEXT,
  notes TEXT,
  debut_statut TIMESTAMPTZ DEFAULT NOW()
);

-- 5. TABLE: audit
CREATE TABLE IF NOT EXISTS audit (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  type_entite TEXT NOT NULL,
  entite_id UUID NOT NULL,
  action TEXT NOT NULL,
  avant JSONB,
  apres JSONB,
  raison TEXT,
  effectue_par TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 6. TABLE: entretiens
CREATE TABLE IF NOT EXISTS entretiens (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  piece_id UUID REFERENCES pieces(id),
  position_id UUID REFERENCES positions(id),
  type_entretien TEXT NOT NULL,
  precision_autre TEXT,
  raison TEXT,
  effectue_par TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 7. TABLE: expeditions_huot
CREATE TABLE IF NOT EXISTS expeditions_huot (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  piece_id UUID REFERENCES pieces(id),
  no_piece TEXT NOT NULL,
  expedie_par TEXT,
  expedie_le TIMESTAMPTZ DEFAULT NOW(),
  supprime BOOLEAN DEFAULT FALSE
);

-- ========================================
-- ROW LEVEL SECURITY (RLS)
-- ========================================

-- Enable RLS on all tables
ALTER TABLE tables_travail ENABLE ROW LEVEL SECURITY;
ALTER TABLE positions ENABLE ROW LEVEL SECURITY;
ALTER TABLE pieces ENABLE ROW LEVEL SECURITY;
ALTER TABLE historique ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit ENABLE ROW LEVEL SECURITY;
ALTER TABLE entretiens ENABLE ROW LEVEL SECURITY;
ALTER TABLE expeditions_huot ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if any
DROP POLICY IF EXISTS "Enable all access for anon" ON tables_travail;
DROP POLICY IF EXISTS "Enable all access for anon" ON positions;
DROP POLICY IF EXISTS "Enable all access for anon" ON pieces;
DROP POLICY IF EXISTS "Enable all access for anon" ON historique;
DROP POLICY IF EXISTS "Enable all access for anon" ON audit;
DROP POLICY IF EXISTS "Enable all access for anon" ON entretiens;
DROP POLICY IF EXISTS "Enable all access for anon" ON expeditions_huot;

-- Create policies for all access
CREATE POLICY "Enable all access for anon" ON tables_travail FOR ALL USING (true);
CREATE POLICY "Enable all access for anon" ON positions FOR ALL USING (true);
CREATE POLICY "Enable all access for anon" ON pieces FOR ALL USING (true);
CREATE POLICY "Enable all access for anon" ON historique FOR ALL USING (true);
CREATE POLICY "Enable all access for anon" ON audit FOR ALL USING (true);
CREATE POLICY "Enable all access for anon" ON entretiens FOR ALL USING (true);
CREATE POLICY "Enable all access for anon" ON expeditions_huot FOR ALL USING (true);

-- ========================================
-- VERIFICATION
-- ========================================

SELECT 'Setup Complete!' AS status;
SELECT 'Tables count:' AS info, COUNT(*) AS count FROM tables_travail;
SELECT 'Positions count:' AS info, COUNT(*) AS count FROM positions;
SELECT 'DC74 Positions:' AS info, code_position FROM positions
  WHERE table_id = (SELECT id FROM tables_travail WHERE nom = 'DC74')
  ORDER BY code_position;
