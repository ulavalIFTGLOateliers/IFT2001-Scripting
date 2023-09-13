#!/bin/env bash

if [ ! -f ~/out_13.txt ]; then
    echo "Incorrect! ~/out_13.txt n'existe pas"
    exit 1
fi

correct_content=$(find ~/Documents -type f | xargs du -sb | sort -rh | head -n 5)
correct_content2=$(cd ~ ; find Documents -type f | xargs du -sb | sort -rh | head -n 5)
content=$(cat ~/out_13.txt)

if [ "$content" = "$correct_content" ] || [ "$content" = "$correct_content2" ]; then
    echo "Correct!"
else
    echo "Incorrect!"
    echo "Le contenu de ~/out_13.txt est incorrect"
    exit 1
fi
