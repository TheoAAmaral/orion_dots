#!/bin/bash

# Diretório temporário para salvar capas
TMP_DIR="/tmp/spotify-cover"
mkdir -p "$TMP_DIR"

# Última faixa notificada
last_id=""

while sleep 0.2; do
    # ID único da faixa (combina título + artista)
    title=$(playerctl metadata xesam:title 2>/dev/null)
    artist=$(playerctl metadata xesam:artist 2>/dev/null)
    art_url=$(playerctl metadata mpris:artUrl 2>/dev/null)

    # Se playerctl falhar (Spotify fechado), pula
    [[ -z "$title" || -z "$artist" ]] && continue

    id="${artist}-${title}"

    # Só notifica se a faixa mudou
    if [[ "$id" != "$last_id" ]]; then
        # Baixa a imagem do álbum se disponível
        if [[ "$art_url" =~ ^https?:// ]]; then
            cover_path="$TMP_DIR/cover.jpg"
            curl -s -L "$art_url" -o "$cover_path"
        else
            cover_path=""
        fi

        # Envia notificação
        if [[ -f "$cover_path" ]]; then
            notify-send -i "$cover_path" "🎶 $title" "$artist"
        else
            notify-send "🎶 $title" "$artist"
        fi

        last_id="$id"
    fi
done
