#!/bin/env bash

if [ -x ~/ApplicationData/output/logs/diagnostic.sh ]; then
    echo "Correct!"
else
    echo "Incorrect! diagnostic.sh n'est pas exécutable"
    exit 1
fi
