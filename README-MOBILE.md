# LAT Scanner Inventaire - Version Mobile

## 🚀 Démarrage rapide

### 1. Démarrer le serveur local

```bash
npm install
npm run dev
```

Le serveur démarre automatiquement sur **http://localhost:3000** et ouvre la page mobile.

### 2. Accéder à l'application

Ouvrez dans votre navigateur :
- **Version mobile** : http://localhost:3000/mobile.html
- Version desktop : http://localhost:3000/index.html

### 3. Configurer Supabase

Éditez le fichier `shared/api.js` et remplacez :

```javascript
const SUPABASE_URL = 'https://VOTRE-PROJET.supabase.co';
const SUPABASE_KEY = 'VOTRE_CLE_ANON_PUBLIC';
```

Par vos identifiants Supabase réels.

## 📱 Interface mobile

### Structure de l'application

L'interface mobile utilise une navigation par onglets en bas de l'écran :

#### 1. **📷 Scan** (Page d'accueil)
- **Scanner QR Code** : Scanner une pièce avec la caméra
- **Rechercher** : Rechercher une pièce par numéro
- **Historique récent** : Voir les 10 dernières actions

#### 2. **📊 Dashboard**
Statistiques en temps réel :
- Mise en production
- Inventaire - Prêt
- À entretenir
- Chez Huot
- Remisée - Rebutée

Vue par table de travail avec toutes les positions.

#### 3. **📦 Pièces**
Liste toutes les pièces organisées par statut :
- **Inventaire - Prêt** (vert)
- **Mise en production** (bleu)
- **Inventaire - À entretenir** (orange)
- **Remisée - Rebutée** (rouge)

Filtre de recherche en haut pour trouver rapidement une pièce.

#### 4. **🏭 Entrepôt Huot**
- Expédier une pièce vers Huot
- Liste des pièces actuellement chez Huot
- Historique des expéditions récentes

## 🎨 Fonctionnalités

### Scanner une pièce
1. Cliquez sur "Scanner QR Code"
2. Sélectionnez la table et la position
3. Scannez le QR code ou saisissez manuellement le numéro
4. La pièce est automatiquement installée

### Installation forcée
Si une pièce n'est pas au statut "Inventaire - Prêt" :
1. Un modal s'affiche pour confirmer
2. Sélectionnez le type d'entretien requis
3. Ajoutez une raison/précision
4. Confirmez l'installation forcée

### Changer le statut d'une pièce
1. Allez dans l'onglet **Pièces**
2. Cliquez sur l'icône ⚙️ à droite d'une pièce
3. Sélectionnez le nouveau statut
4. Ajoutez une raison (optionnel)

## 🔧 Configuration des scripts

Dans `package.json` :

```json
{
  "scripts": {
    "start": "http-server . -p 3000 -o",
    "dev": "http-server . -p 3000 -o /mobile.html"
  }
}
```

- `npm start` : Ouvre la page d'accueil desktop
- `npm run dev` : Ouvre directement la version mobile

## 📱 Optimisations mobiles

- ✅ Touch-friendly (zones de toucher ≥ 44px)
- ✅ Navigation à une main (bottom nav)
- ✅ Support des encoches iPhone (safe-area)
- ✅ Animations fluides
- ✅ Mode PWA-ready
- ✅ Responsive design
- ✅ Pas de zoom involontaire
- ✅ Clavier numérique pour les numéros de pièce

## 🛠️ Structure des fichiers

```
LAT SCANNER INVENTAIRE/
├── mobile.html              # Page mobile principale
├── index.html               # Page desktop d'accueil
├── scanner.html             # Scanner desktop
├── pieces.html              # Gestion des pièces desktop
├── entrepot.html            # Entrepôt Huot desktop
├── historique.html          # Historique desktop
├── shared/
│   ├── api.js              # Configuration Supabase & API helpers
│   ├── style.css           # Styles desktop
│   ├── mobile.css          # Styles mobile optimisés
│   └── mobile.js           # Logique mobile (single-page app)
└── package.json            # Configuration Node.js
```

## 🐛 Dépannage

### La page ne charge pas
- Vérifiez que le serveur est démarré : `npm run dev`
- Vérifiez le port 3000 : http://localhost:3000/mobile.html

### "Configuration Supabase requise"
- Éditez `shared/api.js` avec vos vrais identifiants Supabase
- Rechargez la page (F5)

### Le scanner ne fonctionne pas
- Autorisez l'accès à la caméra dans votre navigateur
- Sur mobile : utilisez HTTPS ou localhost uniquement
- En production : un certificat SSL est requis

### Les données ne se chargent pas
- Ouvrez la console développeur (F12)
- Vérifiez les erreurs d'API
- Vérifiez que les tables Supabase existent

## 📚 Base de données Supabase requise

Tables nécessaires :
- `tables_travail` : Tables de travail
- `positions` : Positions sur les tables
- `pieces` : Pièces avec statut
- `historique` : Historique des changements
- `audit_logs` : Logs d'audit
- `expeditions_huot` : Expéditions vers Huot
- `entretiens` : Types d'entretien

## 📞 Support

Pour toute question, consultez la documentation complète ou contactez l'équipe de développement.
