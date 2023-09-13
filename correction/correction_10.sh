#!/bin/env bash

correct_content=$(grep Error ~/ApplicationData/output/logs/messages.txt | uniq)
content=$(cat ~/errors_2.txt)

if [ ! -f ~/errors_2.txt ]; then
    echo "Incorrect! ~/errors_2.txt n'existe pas"
    exit 1
fi

if [ "$content" = "$correct_content" ]; then
    echo "Correct!"
else
    echo "Incorrect!"
    exit 1
fi
