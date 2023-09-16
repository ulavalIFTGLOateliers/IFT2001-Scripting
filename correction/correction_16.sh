#!/bin/env bash

cd ~/server

python3 -m uvicorn main:app &

server_pid=$!
stop_server() {
  kill $server_pid &> /dev/null
}
trap stop_server EXIT
sleep 1

curl localhost:8000 &> /dev/null

if [ $? -eq 0 ]; then
  echo "Correct! Le server est fonctionnel"
else
  echo "Incorrect! Le server n'est pas fonctionnel"
  exit 1
fi
