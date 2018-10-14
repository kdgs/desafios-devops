#!/bin/bash
/usr/bin/kubectl create -f files/00-namespace.yml,files/01-service.yml,files/02-deployment.yml,files/03-ingress.yml
