#!/bin/bash

while getopts "s:" arg; do
  case $arg in
    s) session=$OPTARG;;
  esac
done

if [ -z "$session" ]; then
  echo "No session number provided"
  exit 1
fi

if [ $session -lt 1 ]; then
  echo "Session number must be greater than 0"
  exit 1
fi

if [ $session -gt 4 ]; then
  echo "Session number must be lower than 4"
  exit 1
fi

code "./demos/helpers/session0$session"

if [ $session -lt 5 ]
then
    code "./demos/docker/session0$session"
    cd "./demos/docker/session0$session"
else
    code "./demos/k8s/session0$session"
    cd "./demos/k8s/session0$session"
fi