#!/bin/bash

# Définition des répertoires
SRC_DIR="/mnt/pve/moviesNFS/"  # Répertoire source où chercher le film
DEST_DIR="/serie_music/movie/"  # Répertoire de destination
PROCESSED_LIST="/home/scripts/processed_movies.txt"  # Liste des films déjà traités
API_KEY="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"  # Clé API TMDb
MIN_RATING=5.0  # Copier les films avec un vote_average >= 5.0

# Vérifier si jq est installé
if ! command -v jq &> /dev/null; then
    echo "❌ Erreur : jq n'est pas installé. Installez-le avec : sudo apt install jq -y ou opkg install jq"
    exit 1
fi

# Vérifier si la liste des films traités existe, sinon la créer
touch "$PROCESSED_LIST"

# Fonction pour obtenir le rating depuis TMDb
get_tmdb_rating() {
    local movie_name="$1"
    local movie_year="$2"
    local query_url="https://api.themoviedb.org/3/search/movie?api_key=$API_KEY&query=$(echo "$movie_name" | tr ' ' '+')&year=$movie_year"
    
    echo "🔍 Recherche sur TMDb : \"$movie_name\" ($movie_year)"
    
    local response=$(curl -s "$query_url")
    local rating=$(echo "$response" | jq -r '.results | max_by(.vote_count) | .vote_average' | tr -d '[:space:]' | tr -cd '0-9.')
    
    if [[ -z "$rating" || "$rating" == "0" ]]; then
        echo "Unknown"
    else
        echo "$rating"
    fi
}

# Traiter tous les répertoires
for dir in "$SRC_DIR"*/; do
    movie_name=$(basename "$dir" | sed -E 's/\(.*\)//' | xargs)
    movie_year=$(basename "$dir" | grep -oE '\\([0-9]{4}\\)' | tr -d '()')
    
    # Vérifier si le film a déjà été traité
    if grep -Fxq "$movie_name ($movie_year)" "$PROCESSED_LIST"; then
        echo "⏭️ [IGNORÉ] Film déjà traité : \"$movie_name ($movie_year)\""
        continue
    fi
    
    RATING=$(get_tmdb_rating "$movie_name" "$movie_year")
    echo "⭐ Résultat TMDb : \"$movie_name\" ($movie_year) - Rating: ${RATING}"
    
    if [[ "$RATING" != "Unknown" && $(echo "$RATING >= $MIN_RATING" | bc -l) -eq 1 ]]; then
        echo "✅ [ACCEPTÉ] Copie en cours du film : \"$movie_name ($movie_year)\" (Rating: $RATING)"
        dest_dir="$DEST_DIR$(basename "$dir")"
        mkdir -p "$dest_dir"
        
        rsync -avu --progress --protect-args "$dir/" "$dest_dir/"
        
        echo "✅ [Copie réussie] : \"$dir\" -> \"$dest_dir\""
        
        # Ajouter le film à la liste des films traités
        echo "$movie_name ($movie_year)" >> "$PROCESSED_LIST"
    else
        echo "⏭️ [IGNORÉ] Rating trop bas ou inconnu pour : \"$movie_name ($movie_year)\""
    fi

done

echo "🎬✅ Copie terminée pour tous les répertoires valides !"
