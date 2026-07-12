# mp3folder-to-tracklist

Genera un file `tracklist.txt` con i timestamp iniziali delle tracce MP3 presenti in una cartella.

## Requisiti

- macOS (`afinfo` è incluso nel sistema)
- Bash

## Utilizzo

Rendi eseguibile lo script (solo la prima volta):

```bash
chmod +x mp3folder-to-tracklist.sh
```

Eseguilo indicando la cartella che contiene gli MP3:

```bash
./mp3folder-to-tracklist.sh "/percorso/della/cartella"
```

Se non specifichi una cartella, lo script usa quella corrente:

```bash
./mp3folder-to-tracklist.sh
```

Il risultato viene salvato come `tracklist.txt` nella cartella degli MP3. I file vengono ordinati alfabeticamente; nomi come `01 - Titolo.mp3`, `02 - Titolo.mp3` mantengono quindi l'ordine delle tracce.

## Pausa tra le tracce

Per impostazione predefinita viene aggiunto un secondo tra una traccia e la successiva. Modifica la variabile `PAUSA` all'inizio dello script per cambiare questo valore o impostalo a `0` per non aggiungere pause.
