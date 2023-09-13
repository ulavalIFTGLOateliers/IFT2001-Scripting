#!/usr/bin/env bash

# Creation du dossier output
mkdir output
# Deplacer les fichiers dans le dossier
mv *.out output/

# Suppression des fichiers .tmp
rm *.tmp
# Suppression du dossier
rm -r temp
