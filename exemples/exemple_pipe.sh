# Trouve les 5 premiers .txt en ordre alphabetique
ls -l | grep ".txt" | sort | head -n 5
# En ordre, voici ce que la commande fait
# 1. Liste les fichiers
# 2. Ne garde que les fichiers contenant .txt dans leur nom
# 3. Trie selon l'ordre alphabetique
# 4. Ne conserve que les 5 premiers resultats

# Ne conserve que les lignes contenant le texte "warning"
# remplace "warning" par "error", puis ecrit le resultat dans output.txt
cat data.txt | grep "warning" | sed 's/warning/error/g' > output.txt
# En ordre, voici ce que la commande fait
# 1. Affiche le contenu de data.txt
# 2. Filtre les lignes afin de ne conserver que les lignes contenant "warning"
# 3. Applique un regex pour remplacer "warning" par "error"
# 4. > permet d'ecrire le resultat dans le fichier output.txt

# Genere un fichier de test
echo -e "1\t2\n2\t3\n3\t4\n" > foo.txt
# En ordre, voici ce que la commande fait
# 1. Affiche une chaine de caractere formatee
#    (l'argument -e fait en sorte que \t sera interprete comme une tabulation, \n comme un retour a la ligne)
# 2. Ecrit le resultat dans foo.txt

# Calcule la somme de chacune des colones
cat foo.txt | awk '{sum += $1; sum2 += $2} END {print sum; print sum2}' \
    | xargs echo "Sum of both columns"
# En ordre, voici ce que la commande fait
# 1. Affiche le contenu de foo.txt
# 2. Awk
#    a. Cree une variable sum, a laquelle on ajoute la valeur 
#       de la premiere colonne ($1) pour chaque ligne
#    b. Cree une variable sum2 a laquelle on ajoute la valeur 
#       de la deuxieme colonne ($2) pour chaque ligne.
#    c. Affiche les valeurs de sum et sum2
#    d. \ permet de continuer la commande sur la ligne suivante
# 3. Passe le resultat de awk a la commande echo qui va afficher la somme
