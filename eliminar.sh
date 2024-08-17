#!/bin/bash

# Función para manejar errores
handle_error() {
    echo "Error: $1"
    exit 1
}

# Eliminar recursos de Terraform
echo "Eliminando recursos de Terraform..."
tflocal destroy -auto-approve || handle_error "No se pudo eliminar los recursos de Terraform."

# Esperar un momento para asegurar que Terraform haya terminado
sleep 10

# Eliminar recursos de Docker Compose
echo "Eliminando recursos de Docker Compose..."
docker-compose down -v || handle_error "No se pudo eliminar los recursos de Docker Compose."

# Esperar un momento para asegurar que los recursos de Docker se hayan detenido
sleep 10

# Eliminar el namespace en Minikube
echo "Eliminando el namespace localstack en Minikube..."
kubectl delete namespace localstack || handle_error "No se pudo eliminar el namespace localstack en Minikube."

# Opcional: Eliminar Minikube
echo "Eliminando Minikube..."
minikube stop && minikube delete --all || handle_error "No se pudo eliminar Minikube."

echo "Proceso de eliminación completado con éxito."
