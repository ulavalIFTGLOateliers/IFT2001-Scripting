#!/usr/bin/env bash

cd ~/server

# Lance le serveur en arriere plan
python3 -m uvicorn main:app &
# Sauvegarde le process ID (pid) du serveur avec $!
server_pid=$!

# La fonction `stop_server` arrete le processus du serveur
stop_server() {
  kill $server_pid
}

# Enregistre la fonction `stop_server` qui sera appelee quand ce script terminera
trap stop_server EXIT

# Attendre que le server soit pret
sleep 1

# TODO faire une requete HTTP a l'adresse localhost:8080
curl localhost:8000 > /dev/null 2> /dev/null

# TODO Si le resultat est une erreur, quitte avec un code 1 avec la commande `exit 1`
# $? contient le code de retour de la derniere commande
if [ $? -eq 0 ]; then
  echo "Server is up"
else
  echo "Server is down"
  exit 1
fi
