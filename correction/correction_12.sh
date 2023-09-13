#!/bin/env bash

if [ ! -f ~/out_12.txt ]; then
    echo "Incorrect! ~/out_12.txt n'existe pas"
    exit 1
fi

correct_content=$(grep Error ~/ApplicationData/output/logs/messages.txt | uniq | sed 's/Error \(4[0-9]\+\)/Warning \1/g')
content=$(cat ~/out_12.txt)

if [ "$content" = "$correct_content" ]; then
    echo "Correct!"
else
    echo "Incorrect!"
    echo "Le contenu de ~/out_12.txt est incorrect"
    exit 1
fi
