#!/bin/bash

# Secondi da aggiungere tra una traccia e la successiva.
# Imposta 0 se non vuoi aggiungere pause.
PAUSA=1

# Usa la cartella indicata come argomento,
# oppure la cartella corrente.
CARTELLA="${1:-.}"

OUTPUT="$CARTELLA/tracklist.txt"
tempo_totale=0

# Azzera il file di output.
> "$OUTPUT"

formatta_tempo() {
    local totale=$1
    local ore=$((totale / 3600))
    local minuti=$(((totale % 3600) / 60))
    local secondi=$((totale % 60))

    if (( ore > 0 )); then
        printf "%02d:%02d:%02d" "$ore" "$minuti" "$secondi"
    else
        printf "%02d:%02d" "$minuti" "$secondi"
    fi
}

# Legge i file MP3 in ordine alfabetico.
# Con nomi 01, 02, 03... corrisponde all'ordine delle tracce.
while IFS= read -r -d '' file; do

    nome=$(basename "$file" .mp3)

    # Rimuove il prefisso iniziale, per esempio:
    # "01 - Prima traccia" -> "Prima traccia"
    titolo=$(printf '%s' "$nome" | sed -E 's/^[[:space:]]*[0-9]+[[:space:]]*[-–—._)][[:space:]]*//')

    timestamp=$(formatta_tempo "$tempo_totale")
    printf "%s - %s\n" "$timestamp" "$titolo" >> "$OUTPUT"

    # afinfo restituisce la durata in secondi, anche con decimali.
    durata=$(afinfo "$file" |
        awk -F': ' '/estimated duration/ {
            printf "%.0f", $2
            exit
        }')

    if [[ -z "$durata" ]]; then
        echo "Errore: impossibile leggere la durata di $file" >&2
        exit 1
    fi

    tempo_totale=$((tempo_totale + durata + PAUSA))

done < <(
    find "$CARTELLA" -maxdepth 1 -type f \
        \( -iname "*.mp3" \) \
        -print0 |
    sort -z
)

echo "Tracklist generata: $OUTPUT"