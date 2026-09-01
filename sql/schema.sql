-- LAT SCANNER INVENTAIRE — schema Supabase (Postgres)
-- Systeme independant de APEX1/APEX2. A executer dans l'editeur SQL du projet Supabase dedie a cet outil.

create extension if not exists pgcrypto;

-- ============================================================
-- 1. Moules / sieges (fixtures fixes, identifiees par numero unique)
-- ============================================================
create table if not exists moules_sieges (
  id uuid primary key default gen_random_uuid(),
  numero int not null unique,
  type text not null check (type in ('moule', 'siege')),
  actif boolean not null default true,
  created_at timestamptz not null default now(),
  constraint numero_parite check (
    (type = 'moule' and numero % 2 = 0) or
    (type = 'siege' and numero % 2 = 1)
  )
);

-- ============================================================
-- 2. Tables physiques (une table = un poste de travail avec plusieurs positions)
-- ============================================================
create table if not exists tables_travail (
  id uuid primary key default gen_random_uuid(),
  nom text not null unique,
  description text,
  created_at timestamptz not null default now()
);

-- ============================================================
-- 3. Positions (emplacement sur une table, lie a un moule/siege)
-- ============================================================
create table if not exists positions (
  id uuid primary key default gen_random_uuid(),
  table_id uuid not null references tables_travail(id) on delete cascade,
  code_position text not null,
  moule_siege_id uuid references moules_sieges(id),
  created_at timestamptz not null default now(),
  unique (table_id, code_position)
);

-- ============================================================
-- 4. Pieces (composants remplacables, statut suit le cycle de vie)
-- ============================================================
create table if not exists pieces (
  id uuid primary key default gen_random_uuid(),
  no_piece text not null unique,
  statut text not null default 'Inventaire - Prêt' check (statut in (
    'Inventaire - Prêt',
    'Chez Huot',
    'Mise en production',
    'Remisée - Rebutée',
    'Inventaire - À entretenir'
  )),
  position_id uuid references positions(id),
  updated_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

-- ============================================================
-- 5. Historique (chaque changement de statut / installation / remplacement)
-- ============================================================
create table if not exists historique (
  id uuid primary key default gen_random_uuid(),
  piece_id uuid references pieces(id),
  no_piece text not null,
  ancien_statut text,
  nouveau_statut text not null,
  type_action text not null check (type_action in (
    'installation', 'installation_forcee', 'remplacement', 'entretien',
    'expedition_huot', 'modification_statut', 'suppression', 'autre'
  )),
  position_id uuid references positions(id),
  code_position text,
  operateur text,
  debut_statut timestamptz not null default now(),
  fin_statut timestamptz,
  notes text,
  created_at timestamptz not null default now()
);

-- ============================================================
-- 6. Entretiens (justification quand une piece est forcee en production)
-- ============================================================
create table if not exists entretiens (
  id uuid primary key default gen_random_uuid(),
  piece_id uuid references pieces(id),
  position_id uuid references positions(id),
  type_entretien text not null,
  precision_autre text,
  raison text,
  effectue_par text,
  created_at timestamptz not null default now()
);

-- ============================================================
-- 7. Expeditions vers Huot (module entrepot)
-- ============================================================
create table if not exists expeditions_huot (
  id uuid primary key default gen_random_uuid(),
  piece_id uuid references pieces(id),
  no_piece text not null,
  destination text not null default 'Huot',
  expedie_par text,
  expedie_le timestamptz not null default now(),
  supprime boolean not null default false,
  notes text,
  created_at timestamptz not null default now()
);

-- ============================================================
-- 8. Audit log (toute modification / suppression sensible)
-- ============================================================
create table if not exists audit_logs (
  id uuid primary key default gen_random_uuid(),
  type_entite text not null,
  entite_id uuid,
  action text not null,
  acteur text,
  avant jsonb,
  apres jsonb,
  raison text,
  created_at timestamptz not null default now()
);

-- ============================================================
-- 9. File d'attente de notifications (declenche l'envoi de courriel)
-- ============================================================
create table if not exists notifications_attente (
  id uuid primary key default gen_random_uuid(),
  historique_id uuid references historique(id) on delete cascade,
  declenche_le timestamptz not null default now(),
  envoye boolean not null default false
);

-- ============================================================
-- Trigger : chaque insertion dans historique met en file une notification
-- ============================================================
create or replace function notifier_historique()
returns trigger as $$
begin
  insert into notifications_attente (historique_id) values (new.id);
  return new;
end;
$$ language plpgsql;

drop trigger if exists historique_notifier on historique;
create trigger historique_notifier
  after insert on historique
  for each row execute function notifier_historique();

-- ============================================================
-- RLS (a activer une fois le projet en place ; select/insert ouverts, delete/update restreints)
-- ============================================================
alter table pieces enable row level security;
alter table positions enable row level security;
alter table historique enable row level security;
alter table entretiens enable row level security;
alter table expeditions_huot enable row level security;
alter table audit_logs enable row level security;
alter table notifications_attente enable row level security;
alter table moules_sieges enable row level security;
alter table tables_travail enable row level security;

create policy "select ouvert" on pieces for select using (true);
create policy "insert ouvert" on pieces for insert with check (true);
create policy "update ouvert" on pieces for update using (true);

create policy "select ouvert" on positions for select using (true);
create policy "insert ouvert" on positions for insert with check (true);
create policy "update ouvert" on positions for update using (true);

create policy "select ouvert" on historique for select using (true);
create policy "insert ouvert" on historique for insert with check (true);

create policy "select ouvert" on entretiens for select using (true);
create policy "insert ouvert" on entretiens for insert with check (true);

create policy "select ouvert" on expeditions_huot for select using (true);
create policy "insert ouvert" on expeditions_huot for insert with check (true);
create policy "update ouvert" on expeditions_huot for update using (true);

create policy "select ouvert" on audit_logs for select using (true);
create policy "insert ouvert" on audit_logs for insert with check (true);

create policy "select ouvert" on notifications_attente for select using (true);
create policy "insert ouvert" on notifications_attente for insert with check (true);
create policy "update ouvert" on notifications_attente for update using (true);

create policy "select ouvert" on moules_sieges for select using (true);
create policy "insert ouvert" on moules_sieges for insert with check (true);

create policy "select ouvert" on tables_travail for select using (true);
create policy "insert ouvert" on tables_travail for insert with check (true);
