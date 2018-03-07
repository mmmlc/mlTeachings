#!/usr/bin/env bash

docker build -t notebook .
docker run -d -p 8888:8888 --name notebook -v $PWD:/home/jovyan notebook start-notebook.sh --NotebookApp.token=''