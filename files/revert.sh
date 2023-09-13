#!/usr/bin/env bash

cd ~/server

revert_last_commit() {
  git reset HEAD~1 --hard
}

exit_status=1
# TODO faire une boucle while tant que $exit_status n'est pas egal a 0
# A chaque iteration, executez le script test.sh
# Si le script termine avec un code 0, arreter le script exit 0
# Sinon, appelez la fonction `revert_last_commit`
