# Préparation de la VM

Pour préparer la machine virtuelle:
1. `sudo apt update && sudo apt install -y git`
2. `mkdir .atelier && cd .atelier && git clone https://github.com/willGuimont/ateliers-iftglo-2001.git`
3. `cd ateliers-iftglo-2001`
4. Exécuter `./helper/install.sh`.
5. Exécuter `python3 ./helper/prepare_bashrc.py && source ~/.bashrc`.
6. Copier les fichiers de `files` dans le dossier home de l'utilisateur, `cd ~/.atelier/ateliers-iftglo-2001/files && cp -r . ~/`.

