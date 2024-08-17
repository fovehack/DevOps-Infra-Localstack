#!/bin/bash

# Inicializa Terraform
tflocal init

# Ejecuta Terraform apply y redirige la salida
tflocal apply -auto-approve

# Guarda solo los outputs en un archivo
tflocal output > outputs.txt
