#!/bin/bash

# Function to print usage information
print_usage() {
    echo "Usage: sh $0 [directory]"
    echo "- Lists all files (including hidden ones) in the specified directory"
    echo "- If no directory is specified, lists files in the current directory"
}

# Function to handle errors
handle_error() {
    echo "Error: $1"
    exit 1
}

# Main script

# Check if help was requested
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    print_usage
    exit 0
fi

# Check for too many arguments
if [ $# -gt 1 ]; then
    print_usage
    exit 1
fi

# Set directory to current directory if no argument provided
directory="${1:-.}"

# Check if directory exists and is readable
if [ ! -d "$directory" ]; then
    handle_error "Directory '$directory' does not exist"
fi

# Change to target directory
cd "$directory" || handle_error "Cannot change to directory '$directory'"

# Initialize array to store filenames
declare -a files

# Read all files (including hidden) into array
while IFS= read -r -d $'\0' file; do
    files+=("$file")
done < <(find . -maxdepth 1 -print0)

# Sort filenames
IFS=$'\n' sorted=($(sort <<<"${files[*]}"))
unset IFS

# Print all files
for file in "${sorted[@]}"; do
    # Remove './' from the beginning of each filename
    filename="${file#./}"
    # Skip empty filenames
    [ -n "$filename" ] && echo "$filename"
done

exit 0