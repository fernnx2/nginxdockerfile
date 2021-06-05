#!/bin/bash
docker run --rm -d --name nodo1 -p 91:80 web-expediente-medico
docker run --rm -d --name nodo2 -p 92:80 web-expediente-medico