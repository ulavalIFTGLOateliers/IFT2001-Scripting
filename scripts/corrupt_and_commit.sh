#/bin/env bash

cd files/server

string_length=100

for ((i=1; i<=15; i++))
do
    echo $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $string_length | head -n 1) > main.py
    sleep 0.5
    git add main.py
    git commit -m "corrupt commit $i"
done
