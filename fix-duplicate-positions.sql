-- LAT Scanner Inventaire - Fix Duplicate Positions
-- Ce script corrige les positions qui ont plusieurs pièces en "Mise en production"
-- Seule la pièce la plus récente (updated_at) sera conservée à chaque position

-- Étape 1: Identifier et corriger les doublons
WITH ranked_pieces AS (
  SELECT
    p.id,
    p.no_piece,
    p.position_id,
    p.statut,
    p.updated_at,
    p.created_at,
    pos.code_position,
    ROW_NUMBER() OVER (
      PARTITION BY p.position_id
      ORDER BY COALESCE(p.updated_at, p.created_at) DESC
    ) as rang
  FROM pieces p
  LEFT JOIN positions pos ON p.position_id = pos.id
  WHERE p.position_id IS NOT NULL
    AND p.statut = 'Mise en production'
),
pieces_a_retirer AS (
  SELECT
    id,
    no_piece,
    position_id,
    code_position,
    updated_at
  FROM ranked_pieces
  WHERE rang > 1  -- Toutes sauf la plus récente
)
-- Mettre à jour les pièces en doublon
UPDATE pieces
SET
  statut = 'Inventaire - À entretenir',
  position_id = NULL,
  updated_at = NOW()
WHERE id IN (SELECT id FROM pieces_a_retirer);

-- Afficher les pièces qui ont été corrigées
SELECT
  p.id,
  p.no_piece,
  'Inventaire - À entretenir' as nouveau_statut,
  par.code_position as ancienne_position,
  'Corrigé: Position occupée par une pièce plus récente' as note
FROM pieces_a_retirer par
JOIN pieces p ON p.id = par.id;

-- Étape 2: Corriger les pièces "Mise en production" sans position
UPDATE pieces
SET
  statut = 'Inventaire - À entretenir',
  updated_at = NOW()
WHERE statut = 'Mise en production'
  AND position_id IS NULL;

-- Étape 3: Corriger les pièces avec position mais pas "Mise en production"
UPDATE pieces
SET
  position_id = NULL,
  updated_at = NOW()
WHERE position_id IS NOT NULL
  AND statut != 'Mise en production';

-- Vérification finale: afficher toutes les positions avec leurs pièces
SELECT
  pos.code_position,
  COUNT(*) as nb_pieces,
  STRING_AGG(p.no_piece, ', ') as pieces
FROM positions pos
LEFT JOIN pieces p ON p.position_id = pos.id AND p.statut = 'Mise en production'
WHERE p.id IS NOT NULL
GROUP BY pos.code_position
ORDER BY pos.code_position;
