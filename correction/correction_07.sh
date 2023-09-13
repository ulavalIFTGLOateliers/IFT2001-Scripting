#!/bin/env bash

~/ApplicationData/output/logs/diagnostic.sh > /dev/null 2>&1

if [ ! -f ~/ApplicationData/output/logs/cleanup.sh ]; then
    echo "Incorrect! cleanup.sh n'existe pas"
    exit 1
fi

if [ ! -x ~/ApplicationData/output/logs/cleanup.sh ]; then
    echo "Incorrect! cleanup.sh n'est pas exécutable"
    exit 1
fi


~/ApplicationData/output/logs/cleanup.sh > /dev/null 2>&1

correction_05.sh
correction_06.sh
