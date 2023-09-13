#!/bin/env bash

correct_content=$(grep Error ~/ApplicationData/output/logs/messages.txt)
content=$(cat ~/errors.txt)

if [ ! -f ~/errors.txt ]; then
    echo "Incorrect! ~/errors.sh n'existe pas"
    exit 1
fi

if [ "$content" = "$correct_content" ]; then
    echo "Correct!"
else
    echo "Incorrect!"
    exit 1
fi
