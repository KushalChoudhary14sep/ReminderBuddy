#!/bin/bash
ROOT_FOLDER="./"
find "$ROOT_FOLDER" -type f -name "swifgen.yml" -exec rm -f {} +
OUTPUT_FILE="swiftgen.yml"
CONFIG_FILE="$ROOT_FOLDER/$OUTPUT_FILE"
if ! command -v swiftgen &> /dev/null; then
    echo "SwiftGen is not installed. Installing..."
    if ! command -v brew &> /dev/null; then
        echo "Homebrew is not installed. Please install Homebrew first."
        exit 1
    fi
    brew install swiftgen
else
    echo "SwiftGen is already installed."
fi
if ! command -v xcodegen &> /dev/null; then
    echo "XcodeGen is not installed. Installing..."
    if ! command -v brew &> /dev/null; then
        echo "Homebrew is not installed. Please install Homebrew first."
        exit 1
    fi
    brew install xcodegen
else
    echo "XcodeGen is already installed."
fi
echo "xcassets:" > "$CONFIG_FILE"
echo "  inputs:" >> "$CONFIG_FILE"
find "$ROOT_FOLDER" -type d -name "*.xcassets" -not -path "*/Pods/*" | while read -r folder; do
    echo "    - \"$folder\"" >> "$CONFIG_FILE"
done
echo "  outputs:" >> "$CONFIG_FILE"
echo "    - templateName: swift5" >> "$CONFIG_FILE"
echo "      output: ReminderBuddy/Resources/AssetEnum.swift" >> "$CONFIG_FILE"

echo "" >> "$CONFIG_FILE"

echo "strings:" >> "$CONFIG_FILE"
echo "  inputs:" >> "$CONFIG_FILE"

find "$ROOT_FOLDER" -type d -name "en.lproj" | while read -r folder; do
    folder_path=$(dirname "$folder")

    # Check if the folder path contains the term "resources"
    if [[ $folder_path == *"Resources"* && $folder_path != *"Pods"* ]]; then
        # Add code resources from en.lproj to the configuration file
         echo "    - "$folder_path/en.lproj"" >> "$CONFIG_FILE"
    fi
done

echo "  outputs:" >> "$CONFIG_FILE"
echo "    - templateName: structured-swift5" >> "$CONFIG_FILE"
echo "      output: ReminderBuddy/Resources/Localisation/LocalizableStrings.swift" >> "$CONFIG_FILE"
echo "      params:" >> "$CONFIG_FILE"
echo "        enumName: Local" >> "$CONFIG_FILE"


