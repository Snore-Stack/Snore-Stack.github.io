#!/usr/bin/env sh
echo "Watching /assets for changes..."

while true; do
    inotifywait -r -e create,modify,move /assets

    echo "Change detected, converting..."
    find /assets -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) -print0 |
    while IFS= read -r -d '' file; do
        output="${file%.*}.webp"
        cwebp -q 80 "$file" -o "$output"
        echo "Deleting : $file"
        rm $file
    done
done
