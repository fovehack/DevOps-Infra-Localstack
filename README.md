# AWS LocalStack Setup

Este proyecto proporciona una configuración completa para simular servicios de AWS localmente utilizando LocalStack, Docker, Minikube, kubernetes, Terraform y Ansible.

## Tabla de Contenidos
- [Preparar el Entorno Local](#preparar-el-entorno-local)
- [Iniciar Minikube](#iniciar-minikube)
- [Iniciar LocalStack con Docker Compose](#iniciar-localstack-con-docker-compose)
- [Aplicar la Configuración de Terraform](#aplicar-la-configuración-de-terraform)
- [Aplicar las Configuraciones de Kubernetes con Ansible](#aplicar-las-configuraciones-de-kubernetes-con-ansible)
- [Pruebas con AWS](#pruebas-con-aws)
- [Eliminar Recursos](#eliminar-recursos)
- [Contribuciones y Licencia](#contribuciones-y-licencia)


## Preparar el Entorno Local

Antes de comenzar, asegúrate de tener instaladas las siguientes herramientas:
- Docker: Para crear y gestionar contenedores.
```bash
docker --version
```
- Minikube: Para ejecutar Kubernetes localmente.
```bash
minikube version
```
- Terraform: Para la infraestructura como código.
```bash
terraform version
```
- Ansible: Para la gestión de configuraciones.
```bash
ansible --version
```

### Iniciar Minikube

Ejecuta el script `minikube_start.sh` para iniciar Minikube y configurar los complementos necesarios:
```bash
chmod +x minikube_start.sh
./minikube_start.sh
```
Este script realizará las siguientes acciones:
- Creará el directorio volume si no existe.
- Iniciará Minikube con 4 CPUs y 8192 MB de memoria.
- Configurará kubectl para utilizar el contexto de Minikube.
- Habilitará los complementos de Ingress, Dashboard, y Metrics Server.
- Iniciará un túnel de Minikube para acceder a servicios de tipo LoadBalancer (requiere privilegios de administrador).

## Iniciar LocalStack con Docker Compose

En esta sección, aprenderás a configurar y ejecutar LocalStack utilizando Docker Compose. LocalStack te permite simular un entorno de servicios de AWS localmente, lo que es útil para pruebas y desarrollo sin necesidad de acceder a los servicios en la nube.

### Configuración del archivo docker-compose.yml

- Archivo `docker-compose.yml`: Este archivo especifica la imagen de Docker, los puertos expuestos, los volúmenes montados y las variables de entorno necesarias para iniciar LocalStack.


### Iniciar LocalStack

Ejecuta el archivo `docker-compose.yml` para iniciar los servicios con Docker Compose.
```
docker-compose up -d
```

Esto iniciará LocalStack en segundo plano y expondrá el puerto 4566, que es el puerto por defecto para todos los servicios de AWS en LocalStack.

#### Verificar que el contenedor está corriendo:

Ejecuta el siguiente comando:
```
docker ps
```
Este comando listará todos los contenedores en ejecución. Deberías ver localstack en la lista, confirmando que está activo.

### Interactuar con LocalStack

1. Iniciar una sesión interactiva en el contenedor:
```
docker exec -it devops-infra-localstack-1 sh
```
- Esto te permitirá abrir una terminal dentro del contenedor de LocalStack para interactuar directamente con el sistema de archivos y los servicios.
2. Verificar el directorio montado:
- Navegar a este directorio te permitirá confirmar que los datos dentro del contenedor corresponden al contenido del directorio ./volume en tu máquina local.
```bash
cd /var/lib/localstack
ls
```
3. Verificar el estado de los servicios en LocalStack:
```
curl -X GET "http://localhost:4566/_localstack/health"
```
- Esto te mostrará un JSON con el estado de los servicios habilitados en LocalStack. Es una buena práctica verificar esto para asegurarse de que los servicios están activos y en buen estado.

### Usar la CLI de AWS con LocalStack
1. Crear un bucket en S3:
```
aws --endpoint-url=http://localhost:4566 s3 mb s3://my-test-bucket
```
- Esto creará un bucket en el servicio S3 simulado por LocalStack.

2. Listar los buckets en S3:
```
aws --endpoint-url=http://localhost:4566 s3 ls
```
- Este comando debería mostrar el bucket que acabas de crear, confirmando que la simulación está funcionando correctamente.

3. Ver Logs del Contenedor de LocalStack:
```
docker logs devops-infra-localstack-1
```
- Los logs son esenciales para depurar problemas y entender qué está sucediendo dentro del contenedor de LocalStack. Esto puede ser útil si algo no está funcionando como se espera.

## Aplicar la Configuración de Terraform

En esta sección, configuraremos y aplicaremos un conjunto de recursos de AWS simulados utilizando Terraform y LocalStack. Terraform te permite definir y aprovisionar infraestructura a través de código, lo cual es ideal para gestionar entornos locales con LocalStack.

### Configuración de Terraform

- Archivo `main.tf`: El archivo `main.tf` define los recursos de AWS, incluyendo una VPC, una subred, una instancia EC2, un bucket S3 y una tabla DynamoDB. También configura el proveedor de AWS para que use los endpoints locales de LocalStack.

- Archivo `outputs.tf`: El archivo `outputs.tf` define las salidas de Terraform para los recursos creados, lo que permite ver fácilmente los identificadores y nombres de los recursos.

- Archivo `terraform.tfvars` (Solo valores personalizados):Este archivo contiene valores específicos que sobrescriben los valores por defecto de `variables.tf`.

- Archivo `variables.tf`: Define las variables utilizadas en los otros archivos. Esto incluye descripciones y valores por defecto, lo que hace que la configuración sea más flexible y reutilizable.

### Inicializar y Aplicar Terraform

Ejecuta el script `start_terraform.sh` para iniciar y aplicar Terraform:
```bash
chmod +x start_terraform.sh
./start_terraform.sh
```
- Este script inicializa Terraform, aplica la configuración para crear los recursos en LocalStack y guarda los resultados de salida en el archivo `outputs.txt`.

## Aplicar las configuraciones de Kubernetes con Ansible:

En esta sección, aprenderás cómo automatizar el despliegue de una aplicación en un clúster de Kubernetes utilizando Ansible. Configurarás Ansible para gestionar los recursos de Kubernetes, definirás plantillas para los despliegues y finalmente aplicarás estas configuraciones en tu entorno de Kubernetes.

- Archivo `ansible.cfg`: Este archivo configura las opciones predeterminadas de Ansible, como la ruta del intérprete de Python.
- Archivo `inventory.ini`: Este archivo define los hosts que Ansible gestionará. En este caso, solo se gestionará el localhost.

### Configuración del Rol de Ansible para Desplegar en Kubernetes

- Archivo `roles/deploy-k8s/defaults/main.yml`: Este archivo contiene las variables por defecto que se usarán en el despliegue de Kubernetes.
- Archivo `roles/deploy-k8s/tasks/main.yml`: Este archivo contiene las tareas principales que Ansible ejecutará para realizar el despliegue en Kubernetes.
- Archivo `playbook.yml`: Este archivo es el playbook de Ansible que se ejecutará para realizar el despliegue.

### Plantilla de Despliegue para Kubernetes
- Archivo `roles/deploy-k8s/templates/deployment.j2`: Este archivo es una plantilla Jinja2 utilizada para generar el archivo de despliegue de Kubernetes

### Ejecución del Playbook de Ansible
- Para desplegar la aplicación "hello-world" en Kubernetes, ejecuta el siguiente comando:
```
ansible-playbook -i inventory.ini playbook.yml
```
### Verificar el Despliegue
- Una vez que hayas ejecutado el playbook, verifica que los recursos se han creado correctamente:
```
kubectl get namespaces
kubectl get all -n localstack
```
### Acceder al Servicio
- Para acceder al servicio NGINX desplegado, utiliza el siguiente comando para obtener la IP del servicio LoadBalancer:
```
minikube service hello-world-service --namespace=localstack
```
### Gestionar Recursos
- Si deseas ver el estado de tu clúster de manera gráfica, utiliza el dashboard de Kubernetes:
```
minikube dashboard
```
### Pruebas con AWS S3
- Listar Buckets S3:
```
aws --endpoint-url=http://localhost:4566 s3 ls

```
- Crear un nuevo bucket y comprobarlo:
```
aws --endpoint-url=http://localhost:4566 s3 mb s3://nuevo-bucket
aws --endpoint-url=http://localhost:4566 s3 ls
```
- Subir un archivo a S3:
```
echo "Este es un archivo de prueba" > testfile.txt
aws --endpoint-url=http://localhost:4566 s3 cp testfile.txt s3://my-bucket/
```
- Listar archivos en el bucket: 
```
aws --endpoint-url=http://localhost:4566 s3 ls s3://my-bucket/
```
- Descargar un archivo desde S3:
```
aws --endpoint-url=http://localhost:4566 s3 cp s3://my-bucket/testfile.txt downloaded_testfile.txt
```
- Borrar un archivo en S3:
```
aws --endpoint-url=http://localhost:4566 s3 rm s3://my-bucket/testfile.txt
aws --endpoint-url=http://localhost:4566 s3 ls s3://my-bucket/
```
- Eliminar un bucket (debe estar vacío):
```
aws --endpoint-url=http://localhost:4566 s3 rb s3://nuevo-bucket
aws --endpoint-url=http://localhost:4566 s3 ls
```
### Pruebas con AWS DynamoDB
- Listar Tablas DynamoDB:
```
aws --endpoint-url=http://localhost:4566 dynamodb list-tables
```
- Insertar un ítem en DynamoDB:
```
aws --endpoint-url=http://localhost:4566 dynamodb put-item --table-name MyTable --item '{"Id": {"S": "1"}, "Name": {"S": "TestName"}}'
```
- Leer un ítem desde DynamoDB:
```
aws --endpoint-url=http://localhost:4566 dynamodb get-item --table-name MyTable --key '{"Id": {"S": "1"}}'

```
- Escanear todos los ítems en una tabla:
```
aws --endpoint-url=http://localhost:4566 dynamodb scan --table-name MyTable
```
- Borrar un ítem en DynamoDB:
```
aws --endpoint-url=http://localhost:4566 dynamodb delete-item --table-name MyTable --key '{"Id": {"S": "1"}}'
```

### Pruebas con AWS VPC y Subnet

- Listar todas las VPCs:
```
aws --endpoint-url=http://localhost:4566 ec2 describe-vpcs
```
- Listar todas las subnets: 
```
aws --endpoint-url=http://localhost:4566 ec2 describe-subnets
```
- Verificar detalles de una VPC específica: 
```
aws --endpoint-url=http://localhost:4566 ec2 describe-vpcs --vpc-ids $(terraform output -raw vpc_id)
```
### Pruebas con AWS EC2 Instance
- Verificar Instancias EC2:
```
aws --endpoint-url=http://localhost:4566 ec2 describe-instances
```
- Verificar detalles de una instancia específica: 
```
aws --endpoint-url=http://localhost:4566 ec2 describe-instances --instance-ids $(terraform output -raw instance_id)
```
- Verificar el Estado de Volúmenes EBS:
```
aws --endpoint-url=http://localhost:4566 ec2 describe-volumes
```
##  Eliminar recursos
Esta sección describe cómo limpiar todos los recursos creados durante el despliegue, incluyendo aquellos gestionados por Terraform, Docker Compose y Kubernetes. La eliminación adecuada asegura que no queden elementos residuales en tu entorno local.
- Archivo `eliminar.sh`: Este script de shell se encarga de destruir los recursos creados y limpiar el entorno.

### Instrucciones para Ejecutar el Script

```bash
chmod +x eliminar.sh
./eliminar.sh
```
## Contribuciones y Licencia
Este proyecto está bajo la Licencia MIT. Para contribuir, realiza un fork y envía tus pull requests.





