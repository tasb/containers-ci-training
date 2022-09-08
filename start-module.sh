#!/bin/bash

while getopts "m:" arg; do
  case $arg in
    m) module=$OPTARG;;
  esac
done

if [ -z "$module" ]; then
  echo "No module number provided"
  exit 1
fi

if [ $module -lt 1 ]; then
  echo "Module number must be greater than 0"
  exit 1
fi

if [ $module -gt 7 ]; then
  echo "Module number must be lower than 7"
  exit 1
fi

code "./demos/helpers/module0$module"

if [ $module -gt 1 ]; then
  code "./demos/module0$module"
  cd "./demos/module0$module"
fi