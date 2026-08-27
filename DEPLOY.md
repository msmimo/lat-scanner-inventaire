# 📦 Déploiement GitHub Pages - Guide Pas à Pas

## Option 1: Via l'interface web GitHub (Plus simple)

### Étape 1: Créer un nouveau repository
1. Allez sur https://github.com
2. Cliquez sur le **+** en haut à droite → **New repository**
3. Nommez-le `lat-scanner-inventaire` (ou autre nom)
4. Choisissez **Public** (gratuit) ou **Private** (nécessite GitHub Pro)
5. **NE cochez PAS** "Add a README file"
6. Cliquez **Create repository**

### Étape 2: Uploader les fichiers
1. Sur la page du nouveau repo, cliquez **uploading an existing file**
2. **Glissez-déposez** tous ces fichiers depuis `c:\source\LAT SCANNER INVENTAIRE\`:
   ```
   ✅ mobile.html
   ✅ index.html
   ✅ scanner-dc74.html
   ✅ shared/ (dossier complet)
   ✅ .gitignore
   ✅ README.md
   ```
3. **N'uploadez PAS:**
   ```
   ❌ node_modules/
   ❌ server-http.js
   ❌ server-https.js
   ❌ fichiers .output
   ```
4. Ajoutez un message de commit: `Initial commit - APEX mobile scanner`
5. Cliquez **Commit changes**

### Étape 3: Activer GitHub Pages
1. Dans votre repo, cliquez **Settings** (en haut)
2. Dans le menu de gauche, cliquez **Pages**
3. Sous **Source**, sélectionnez:
   - Branch: **main** (ou **master**)
   - Folder: **/ (root)**
4. Cliquez **Save**
5. Attendez 1-2 minutes

### Étape 4: Accéder à votre site
Votre site sera disponible à:
```
https://[votre-username].github.io/[nom-du-repo]/mobile.html
```

Par exemple:
```
https://msmimo-ai.github.io/lat-scanner-inventaire/mobile.html
```

---

## ⚙️ Configuration Supabase

**IMPORTANT:** Avant d'utiliser l'application, vous devez configurer Supabase.

### Modifier shared/api.js

1. Sur GitHub, naviguez vers `shared/api.js`
2. Cliquez sur le crayon ✏️ (Edit)
3. Modifiez ces lignes:

```javascript
const SUPABASE_URL = 'https://puydipjoykvwzpwnjedi.supabase.co';  // Votre URL Supabase
const SUPABASE_ANON_KEY = 'eyJhbG...';  // Votre clé anonyme Supabase
```

4. Remplacez par vos vraies valeurs Supabase
5. Cliquez **Commit changes**
6. Attendez 30 secondes que GitHub Pages se mette à jour

---

## 📱 Test sur Mobile

Une fois déployé:

1. Ouvrez Safari/Chrome sur votre téléphone
2. Allez sur `https://[votre-username].github.io/[nom-du-repo]/mobile.html`
3. **Ajoutez à l'écran d'accueil:**
   - Safari iOS: Partager → Ajouter à l'écran d'accueil
   - Chrome Android: Menu → Installer l'application

### Permissions Caméra (HTTPS activé automatiquement)

Maintenant que vous êtes sur HTTPS via GitHub Pages:
- ✅ Le scanner QR **fonctionne** (Safari/Chrome demandera la permission)
- ✅ La saisie manuelle fonctionne toujours

---

## 🔄 Mettre à jour le site

Pour mettre à jour après modifications:

1. Sur GitHub, naviguez vers le fichier à modifier
2. Cliquez ✏️ Edit
3. Faites vos changements
4. Cliquez **Commit changes**
5. Attendez 30-60 secondes
6. Rafraîchissez votre page mobile

---

## 📂 Structure du Projet

```
lat-scanner-inventaire/
├── mobile.html              # 📱 Application principale (à ouvrir sur mobile)
├── index.html               # 🏠 Page d'accueil
├── scanner-dc74.html        # 🔧 Scanner APEX standalone
├── shared/
│   ├── api.js              # ⚙️ Configuration Supabase (À MODIFIER!)
│   ├── mobile.js           # 🎯 Logique JavaScript
│   └── mobile.css          # 🎨 Styles + APEX design
├── .gitignore              # 🚫 Fichiers à ignorer
└── README.md               # 📖 Documentation
```

---

## ✅ Checklist de Déploiement

- [ ] Repository GitHub créé
- [ ] Tous les fichiers uploadés (sauf node_modules)
- [ ] GitHub Pages activé (Settings → Pages)
- [ ] `shared/api.js` modifié avec vos identifiants Supabase
- [ ] Site accessible via `https://[username].github.io/[repo]/mobile.html`
- [ ] Testé sur mobile (caméra + saisie manuelle)
- [ ] Ajouté à l'écran d'accueil du téléphone

---

## 🆘 Problèmes Courants

### "404 Page not found"
- Vérifiez que GitHub Pages est activé (Settings → Pages)
- Attendez 1-2 minutes après activation
- L'URL doit contenir `/mobile.html` à la fin

### "Caméra ne fonctionne pas"
- Assurez-vous d'utiliser HTTPS (GitHub Pages le fait automatiquement)
- Autorisez la permission caméra dans les paramètres du navigateur
- Sinon, utilisez la saisie manuelle ✎

### "Configuration Supabase requise"
- Vous devez modifier `shared/api.js` avec vos vraies valeurs
- Voir section "Configuration Supabase" ci-dessus

### "Ancien cache / page ne se met pas à jour"
- Sur mobile: Menu → Paramètres → Effacer les données du site
- Ou: Mode navigation privée pour tester

---

## 🎉 C'est tout!

Votre application est maintenant déployée et accessible depuis n'importe où!

**URL d'exemple:**
```
https://msmimo-ai.github.io/lat-scanner-inventaire/mobile.html
```

**Bookmark cette URL** sur votre téléphone pour un accès rapide! 📲
