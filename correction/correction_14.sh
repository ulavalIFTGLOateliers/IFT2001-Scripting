#!/bin/env bash

if [ ! -f ~/out_14.txt ]; then
    echo "Incorrect! ~/out_14.txt n'existe pas"
    exit 1
fi

correct_content=$(awk '{print $5 " " $3}' ~/ApplicationData/db.tsv | sort -h | head -n 10 | awk '{print $2}')
content=$(cat ~/out_14.txt)

if [ "$content" = "$correct_content" ]; then
    echo "Correct!"
else
    echo "Incorrect!"
    echo "Le contenu de ~/out_14.txt est incorrect"
    exit 1
fi
