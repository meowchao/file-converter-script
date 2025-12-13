#!/bin/bash

echo -e "\033[H\033[2J"

gum style \
    --foreground 212 --border-foreground 212 --border double \
    --width 100 --margin "1 2" --padding "2 4" \
    '


███████╗██╗██╗     ███████╗
██╔════╝██║██║     ██╔════╝
█████╗  ██║██║     █████╗
██╔══╝  ██║██║     ██╔══╝
██║     ██║███████╗███████╗
╚═╝     ╚═╝╚══════╝╚══════╝

 ██████╗ ██████╗ ███╗   ██╗██╗   ██╗███████╗██████╗ ████████╗███████╗██████╗
██╔════╝██╔═══██╗████╗  ██║██║   ██║██╔════╝██╔══██╗╚══██╔══╝██╔════╝██╔══██╗
██║     ██║   ██║██╔██╗ ██║██║   ██║█████╗  ██████╔╝   ██║   █████╗  ██████╔╝
██║     ██║   ██║██║╚██╗██║╚██╗ ██╔╝██╔══╝  ██╔══██╗   ██║   ██╔══╝  ██╔══██╗
╚██████╗╚██████╔╝██║ ╚████║ ╚████╔╝ ███████╗██║  ██║   ██║   ███████╗██║  ██║
 ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝


made by spikeypear
'

files=$(find . -maxdepth 1 -type f -printf "%f\n")

echo "Select files to convert:"
selected_files=$(echo "$files" | gum choose --no-limit)

[ -z "$selected_files" ] && echo "No files selected." && exit 1

echo ""
echo "Selected files:"
echo "$selected_files"

echo ""
echo "Select target format:"
target_format=$(gum choose "pdf" "docx" "pptx" "ppt" "txt" "html")
echo "you chose: $target_format"

echo ""
keep_original=$(gum choose --header "Keep original files?" "Yes" "No")

echo ""
gum confirm "Proceed with conversion?" || exit 1

mkdir -p converted-files

echo ""
gum spin --spinner dot --title "Converting files..." -- sleep 2


echo "$selected_files" | while IFS= read -r file; do
    [ -z "$file" ] && continue
    filename="${file%.*}"

    file_start=$(date +%s)
    echo "Converting: $file → ${filename}.${target_format}"

    if libreoffice --headless --convert-to "$target_format" "$file" --outdir converted-files >/dev/null 2>&1; then
        file_end=$(date +%s)
        file_elapsed=$((file_end - file_start))
        echo "  ✓ Completed in ${file_elapsed}s"

        if [ "$keep_original" = "No" ]; then
            echo "  Deleting original: $file"
            rm "$file"
        fi
    else
        echo "  ERROR converting $file"
    fi
done
echo ""
echo "Conversion complete!"
