# [VIBECODED] mp3folder-to-tracklist

Generates a `tracklist.txt` file containing the start timestamp of each MP3 track in a folder.

## Requirements

- macOS (`afinfo` is included with the operating system)
- Bash

## Usage

Make the script executable (only required once):

```bash
chmod +x mp3folder-to-tracklist.sh
```

Run it with the folder containing your MP3 files:

```bash
./mp3folder-to-tracklist.sh "/path/to/your/folder"
```

If no folder is provided, the script uses the current directory:

```bash
./mp3folder-to-tracklist.sh
```

The result is saved as `tracklist.txt` inside the MP3 folder. Files are sorted alphabetically, so names such as `01 - Title.mp3` and `02 - Title.mp3` preserve the intended track order.

## Pauses between tracks

By default, the script adds one second between consecutive tracks. Change the `PAUSA` variable at the beginning of the script to use a different value, or set it to `0` to disable pauses.
