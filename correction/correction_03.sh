#!/bin/env bash

if [ ! -d ~/log_backup ]; then
    echo "Incorrect!"
    echo "log_backup n'existe pas"
    exit 1
fi

correct_content=$(cat ~/ApplicationData/output/logs/build.log)
content=$(cat ~/log_backup/build_backup.log)

if [ "$content" = "$correct_content" ]; then
    echo "Correct!"
else
    echo "Incorrect build_backup.log est incorrect!"
    exit 1
fi
