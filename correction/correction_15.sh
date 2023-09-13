#!/bin/env bash

if [ ! -x ~/test.sh ]; then
    echo "Incorrect! test.sh n'est pas exécutable"
    exit 1
fi

mv ~/server/main.py ~/server/main.py.bak

revert_backup() {
  mv ~/server/main.py.bak ~/server/main.py
}
trap revert_backup EXIT

cp -f ~/.hidden/main_broken.py ~/server/main.py

~/test.sh > /dev/null 2>&1

if [ $? -eq 1 ]; then
  echo "Correct: Code de retour 1 quand le serveur est cassé"
else
  echo "Incorrect: Code de retour 0 quand le serveur est cassé, devrait être 1"
fi

cp -f ~/.hidden/main_working.py ~/server/main.py

~/test.sh > /dev/null 2>&1

if [ $? -eq 0 ]; then
  echo "Correct: Code de retour 0 quand le serveur est fonctionnel"
else
  echo "Incorrect: Code de retour 1 quand le serveur est fonctionnel, devrait être 0"
fi
