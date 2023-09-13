
with open('/home/glo2001/.bashrc', 'a') as f:
    f.write('export PATH=$PATH:~/.atelier/ateliers-iftglo-2001/correction\n')
    f.write('export PATH=$PATH:~/.local/bin\n')

with open('/home/glo2001/.gitconfig', 'a') as f:
    f.write('''[user]
    email = glo2001@ulaval.ca
    name = Glo 2001
            ''')
