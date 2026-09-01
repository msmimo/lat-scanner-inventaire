# 📧 Guide de configuration - Système d'email automatique

## 🎯 Vue d'ensemble

Le système envoie automatiquement un email avec tous les statuts des pièces quand :
- ✅ Une pièce change de statut (scan, installation, expédition Huot, etc.)
- ⏰ Attente de 2 minutes pour regrouper les changements
- 📨 Envoi unique avec toutes les pièces

---

## 📋 Étape 1 : Créer la table SQL

1. Ouvrir **Supabase Dashboard** → Projet "ULAT TABLE"
2. Aller dans **SQL Editor**
3. Copier-coller le contenu de `supabase-email-setup.sql`
4. Cliquer **Run**
5. Vérifier : "Email notification table created!"

---

## 🚀 Étape 2 : Déployer l'Edge Function

### A. Installer Supabase CLI (si pas déjà fait)

**Windows (PowerShell):**
```powershell
scoop install supabase
```

**Ou télécharger depuis:** https://github.com/supabase/cli/releases

### B. Se connecter à Supabase

```powershell
cd "c:\source\LAT SCANNER INVENTAIRE"
supabase login
```

### C. Lier le projet

```powershell
supabase link --project-ref oopxhatozrtputqvylsn
```

### D. Modifier les destinataires

Ouvrir `supabase\functions\send-inventory-report\index.ts`

**Ligne 8 - Remplacer avec vos emails:**
```typescript
const RECIPIENTS = [
  "employee1@company.com",
  "employee2@company.com",
  "manager@company.com"
];
```

### E. Déployer la function

```powershell
supabase functions deploy send-inventory-report
```

---

## ⚙️ Étape 3 : Configurer le Cron (déclencheur automatique)

### Option A : Via Supabase Dashboard (recommandé)

1. **Database** → **Extensions** → Activer `pg_cron`
2. **SQL Editor** → Nouvelle requête :

```sql
-- Exécuter toutes les 3 minutes
SELECT cron.schedule(
  'send-inventory-emails',
  '*/3 * * * *',
  $$
  SELECT net.http_post(
    url := 'https://oopxhatozrtputqvylsn.supabase.co/functions/v1/send-inventory-report',
    headers := '{"Content-Type": "application/json", "Authorization": "Bearer ' || current_setting('app.settings.service_role_key') || '"}'::jsonb
  ) AS request_id;
  $$
);
```

### Option B : Via externe (si pg_cron indisponible)

Utiliser un service comme **cron-job.org** ou **EasyCron** :
- URL: `https://oopxhatozrtputqvylsn.supabase.co/functions/v1/send-inventory-report`
- Fréquence: Toutes les 3 minutes
- Méthode: POST
- Header: `Authorization: Bearer YOUR_ANON_KEY`

---

## 📧 Étape 4 : Vérifier Resend

1. Aller sur https://resend.com/emails
2. Après un changement de statut sur le scanner, attendre 2 minutes
3. Vérifier qu'un email est envoyé

**Format de l'email:**
```
📋 Rapport d'inventaire - Table DC74
Date: 2025-01-15 14:30:00

╔═══════════════════════════════════════════════════════════════╗
║ No. Pièce │ Table │ Statut              │ Position │ ...    ║
╠═══════════════════════════════════════════════════════════════╣
║ 123456    │ DC74  │ Mise en production  │ M3       │ ...    ║
║ 789012    │ DC74  │ Inventaire - Prêt   │ —        │ ...    ║
╚═══════════════════════════════════════════════════════════════╝
```

---

## 🔧 Étape 5 : Mettre à jour le frontend

### IMPORTANT : Vérifier deploy/shared/api.js

**Fichier:** `deploy\shared\api.js`

**Lignes 3-4 - Remplacer avec vos vraies credentials:**
```javascript
const SUPABASE_URL = 'https://oopxhatozrtputqvylsn.supabase.co';
const SUPABASE_KEY = 'eyJhbGc...VOTRE_VRAIE_CLE';
```

### Uploader sur GitHub

```powershell
cd deploy
git add .
git commit -m "Add email notification system"
git push
```

---

## ✅ Test complet

1. **Scanner une pièce** sur mobile → https://msmimo.github.io/lat-scanner-inventaire/
2. Vérifier dans **Supabase** → Table `pending_notification` :
   - Une ligne avec `sent_snapshot = false`
3. Attendre **2 minutes**
4. Le cron déclenche l'Edge Function
5. Vérifier dans **Resend** → Emails envoyés
6. Vérifier dans **Supabase** → `sent_snapshot = true`

---

## 🐛 Dépannage

### Problème : Pas d'email reçu

**1. Vérifier les secrets Supabase:**
- Dashboard → Settings → Edge Functions → Secrets
- `RESEND_API_KEY` existe ?
- `SUPABASE_URL` correct ?
- `SUPABASE_SERVICE_ROLE_KEY` existe ?

**2. Vérifier les logs de la function:**
```powershell
supabase functions logs send-inventory-report
```

**3. Tester manuellement la function:**
```powershell
curl -X POST https://oopxhatozrtputqvylsn.supabase.co/functions/v1/send-inventory-report \
  -H "Authorization: Bearer YOUR_ANON_KEY"
```

### Problème : pending_notification vide

- Le frontend n'appelle pas `triggerEmailNotification()`
- Vérifier que `deploy/shared/api.js` et `mobile.js` sont à jour
- Vérifier la console browser : erreurs JavaScript ?

---

## 📝 Résumé des fichiers créés

```
LAT SCANNER INVENTAIRE/
├── supabase-email-setup.sql          ← SQL pour créer la table
├── supabase/functions/
│   └── send-inventory-report/
│       └── index.ts                   ← Edge Function
├── shared/
│   ├── api.js                         ← Ajouté triggerEmailNotification()
│   └── mobile.js                      ← Appelle la fonction après changements
└── EMAIL-SETUP-GUIDE.md              ← Ce guide
```

---

## 🎉 C'est terminé !

Une fois configuré, le système est **100% automatique** :
- ✅ Aucun bouton à cliquer
- ✅ Email envoyé après chaque changement (avec délai de 2 min)
- ✅ Toutes les pièces incluses dans le rapport
