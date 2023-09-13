#!/bin/env bash

    if [ ! -d ~/ApplicationData/output/logs/output ]; then
        echo "Incorrect!"
        echo "output n'existe pas"
        exit 1
    fi

num_files=$(find ~/ApplicationData/output/logs -maxdepth 1 -name "*.out" | wc -l)

if [[ $num_files -eq 0 ]]; then
    num_files=$(find ~/ApplicationData/output/logs/output_backup -maxdepth 1 -name "*.out" | wc -l)
    if [[ $num_files -eq 10 ]]; then
        echo "Correct!"
    else
        echo "Incorrect!"
        echo "Les fichiers *.out ne sont pas dans output_backup"
        exit 1
    fi
else
    echo "Incorrect!"
    echo "Les fichiers *.out sont encore dans logs"
    exit 1
fi
