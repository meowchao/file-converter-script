#!/bin/bash

read -p "Enter the path to the file: " input_file

if [ ! -f "$input_file" ]; then
    echo "File not found!"
    exit 1
fi

read -p "Enter the output file type (e.g., docx, pptx, pdf): " output_type

read -p "Do you want to keep the original file? (y/n): " keep_original

dir=$(dirname "$input_file")
filename=$(basename "$input_file")
extension="${filename##*.}"
filename_without_ext="${filename%.*}"

output_file="$dir/$filename_without_ext.$output_type"

echo "Converting file..."
soffice --headless --convert-to "$output_type" "$input_file" --outdir "$dir"

if [ $? -eq 0 ]; then
    echo "File converted successfully to $output_file"
else
    echo "File conversion failed!"
    exit 1
fi

if [ "$keep_original" == "n" ]; then
    rm "$input_file"
    echo "Original file deleted."
fi
