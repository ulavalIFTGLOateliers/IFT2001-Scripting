#!/usr/bin/env bash
# Les arguments du script sont disponibles avec $n (ou n est un nombre naturel)
echo "The script name is: $0"
echo "The first argument is: $1"
echo "The second argument is: $2"
echo "All arguments:$@"
# {@:2:3} veut dire prendre une slice commencant a 2 (1-based) de longueur 3
echo "Arguments from 2 to 4: ${@:2:3}"

# Variables, noter qu'il n'y a pas d'espace autour du signe =
name="John"
age=25
# $age permet de remplacer la valeur de la variable dans la chaine de caractere entre "
echo "My name is $name and I am $age years old."
# Variables d'environnement
echo "The value of HOME is: $HOME"

# Substitution
current_directory=$(pwd)
# Les substitutions fonctionnent seulement pour des double quotes "
echo "The current directory is: $current_directory using double quotes"
# Pas pour des single quotes '
echo 'The current directory is: $current_directory using single quotes'
# Il est aussi possible d'appeler une commande directement dans une chaine de caractere
path="$(pwd)"/my/path
echo "Path: $path"

# Conditionnels
if [ "$age" -ge 18 ]; then
  echo "You are an adult."
else
  echo "You are a minor."
fi

# Boucles
for i in 1 2 3 4 5
do
    echo $i
done

fruits=("apple" "banana" "orange")
for fruit in "${fruits[@]}"
do
    echo "I like $fruit"
done

counter=1
while [ $counter -le 5 ]
do
    echo $counter
    ((counter++))
done

# Function
greet() {
  echo "Hello, $1!"
}

greet "Alice"
