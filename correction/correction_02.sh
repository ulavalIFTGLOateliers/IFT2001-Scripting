#!/bin/env bash

correct_path="/home/glo2001/ApplicationData/output/logs"
content=$(cat ~/out_02.txt)

if [ "$content" = "$correct_path" ]; then
    echo "Correct!"
else
    echo "Incorrect!"
    echo "Chemin incorrect"
    exit 1
fi