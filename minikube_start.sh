#!/bin/bash

# Crear el directorio volume si no existe
echo "Creando el directorio volume si no existe..."
mkdir -p ./volume

# Iniciar Minikube
echo "Iniciando Minikube con 4 CPUs y 8192 MB de memoria..."
minikube start --cpus=4 --memory=8192

# Configurar kubectl para usar Minikube
echo "Configurando kubectl para usar el contexto de Minikube..."
kubectl config use-context minikube

# Habilitar complementos de Minikube
echo "Habilitando complementos de Minikube..."
minikube addons enable ingress
minikube addons enable dashboard
minikube addons enable metrics-server

echo "Minikube y complementos habilitados exitosamente."

# Iniciar el túnel
echo "Iniciando Minikube tunnel (se requieren privilegios de administrador)..."
minikube tunnel
