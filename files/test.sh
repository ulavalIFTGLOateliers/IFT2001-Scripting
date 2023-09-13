#!/usr/bin/env bash

cd ~/server

# Lance le serveur en arriere plan
uvicorn main:app &
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

# TODO faire une requete HTTP a l'adresse localhost:8000

# TODO Si le resultat est une erreur, quitte avec un code 1 avec la commande `exit 1`
# $? contient le code de retour de la derniere commande
