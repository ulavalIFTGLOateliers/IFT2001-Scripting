#!/bin/env bash

num_files=$(find ~/ApplicationData/output/logs -maxdepth 1 -name "*.tmp" | wc -l)

if [[ ! $num_files -eq 0 ]]; then
    echo "Incorrect!"
    echo "Les fichiers *.tmp sont encore dans logs"
    exit 1
fi

if [ -d ~/ApplicationData/output/logs/temp ]; then
    echo "Incorrect!"
    echo "temp n'a pas été supprimé"
    exit 1
fi

echo "Correct!"
