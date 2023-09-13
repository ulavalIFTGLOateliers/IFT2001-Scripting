#!/bin/env bash

output_directory=~/ApplicationData/output/logs
num_files=10 

for ((i=1; i<=num_files; i++))
do
    filename="$output_directory/file$i.out"
    random_content=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 50 | head -n 1)
    echo "$random_content" > "$filename"
    echo "Generated $filename"
done

for ((i=1; i<=num_files; i++))
do
    filename="$output_directory/file$i.tmp"
    random_content=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 50 | head -n 1)
    echo "$random_content" > "$filename"
    echo "Generated $filename"
done

mkdir "$output_directory/temp"
for ((i=1; i<=num_files; i++))
do
    filename="$output_directory/temp/file$i.tmp"
    random_content=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 50 | head -n 1)
    echo "$random_content" > "$filename"
    echo "Generated $filename"
done

echo "Finished diagnostic"
