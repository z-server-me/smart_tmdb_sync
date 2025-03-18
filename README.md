# 🎬 Smart TMDb Sync

## 📌 Description
**Smart TMDb Sync** est un script Bash permettant de **synchroniser automatiquement des films** en fonction de leur note sur [TMDb](https://www.themoviedb.org). Seuls les films ayant une **note supérieure ou égale à 5** sont copiés vers le dossier cible.

✅ **Caractéristiques principales** :
- Recherche de films dans un dossier source.
- Analyse automatique des notes via l'API TMDb.
- Filtrage intelligent (ignore les films avec une note < 5 ou inconnue).
- Copie complète du répertoire du film validé.
- Gestion d'une liste des films déjà traités pour éviter les doublons.
- Affichage détaillé du processus avec logs en direct.

---

## 🚀 Installation
### 1️⃣ **Installer les dépendances** (si non installées) :
```bash
sudo apt install jq -y  # Pour Debian/Ubuntu
opkg install jq          # Pour les systèmes basés sur Entware
```

### 2️⃣ **Configurer votre clé API TMDb**
Avant d'exécuter le script, **éditez `smart_tmdb_sync.sh`** et remplacez `XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX` par votre clé API TMDb :
```bash
nano smart_tmdb_sync.sh
```
```bash
API_KEY="YOUR_TMDB_API_KEY"
```

### 3️⃣ **Lancer le script**
```bash
bash smart_tmdb_sync.sh
```

---

## ⚙️ Configuration
Le script est paramétrable via des variables internes :
- **`SRC_DIR`** : Répertoire source contenant les films.
- **`DEST_DIR`** : Répertoire de destination des films validés.
- **`MIN_RATING`** : Seuil minimal de note pour valider un film (par défaut `5.0`).
- **`PROCESSED_LIST`** : Fichier contenant la liste des films déjà traités.

Vous pouvez modifier ces valeurs directement dans `smart_tmdb_sync.sh`.

---

## 📜 Exemples de logs
```
🔍 Recherche sur TMDb : "Inception (2010)"
⭐ Résultat TMDb : "Inception (2010)" - Rating: 8.8
✅ [ACCEPTÉ] Copie en cours du film : "Inception (2010)"
sending incremental file list
✅ [Copie réussie] : "/mnt/pve/moviesNFS/Inception (2010)/" -> "/serie_music/movie/Inception (2010)"
```

```
🔍 Recherche sur TMDb : "Movie X (2023)"
⭐ Résultat TMDb : "Movie X (2023)" - Rating: 4.2
⏭️ [IGNORÉ] Rating trop bas ou inconnu pour : "Movie X (2023)"
```

---

## 📌 Améliorations futures
- Ajout d'une interface interactive.
- Support multi-thread pour accélérer la copie.
- Intégration d'une option pour filtrer par genre.

---

## 📝 Licence
**Smart TMDb Sync** est distribué sous licence **MIT**.

💡 **Contribuer** : Vous pouvez proposer des améliorations en ouvrant une issue ou un pull request sur GitHub.

🎬 **Développé par [z-server-me](https://github.com/z-server-me)** avec ❤️ pour les cinéphiles et les passionnés d'automatisation.

