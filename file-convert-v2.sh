#!/bin/bash

#clear the screen
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




files=$(ls -1p | grep -v / | grep -v '^\.')



echo "Select files to convert :"
selected_files=$(echo "$files" | gum choose --no-limit )

# Show selected files
echo ""
echo "Selected files:"
echo "$selected_files"

# Ask for target format
echo ""
echo "Select target format:"
target_format=$(gum choose "pdf" "docx" "pptx" "ppt" "txt" "html")
echo "you choose: $target_format"

echo ""
keep_original=$(gum choose --header "Keep original files?" "Yes" "No")

# Confirmation
echo ""
gum confirm "Proceed with conversion?" || exit 1 

# Processing logic
echo ""
gum spin --spinner dot --title "Converting files..." -- sleep 2

# your actual logic

echo "$selected_files" | while IFS= read -r file; do
    if [ -n "$file" ]; then
        filename="${file%.*}"
        extension="${file##*.}"
        
        
        echo "Converting: $file "to" ${filename}.${target_format}"
        
        #conversion logiv
        libreoffice --headless --convert-to "$target_format" "$selected_files" --outdir converted-files


        if [ "$keep_original" = "No" ]; then
            echo "  Deleting original: $file"
            # rm "$file"
        fi
    fi
done

echo ""
echo "Conversion complete!"
