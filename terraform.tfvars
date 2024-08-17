# Variables generales
aws_region         = "us-east-1"  # Cambiar si necesitas desplegar en otra región

# Variables de S3
s3_bucket_name     = "my-bucket" # Nombre por defecto del bucket S3
# s3_bucket_name   = "my-custom-bucket" # Descomentar para usar un nombre personalizado

# Variables de DynamoDB
dynamodb_table_name = "MyTable"  # Cambiar si necesitas otro nombre para la tabla

# Variables de red
vpc_cidr           = "10.0.0.0/16"  # Cambiar si necesitas un bloque CIDR diferente
subnet_cidr        = "10.0.1.0/24"  # Cambiar si necesitas un bloque CIDR diferente para la subred

# Variables de EC2
instance_type      = "t2.micro"  # Cambiar si necesitas otro tipo de instancia
ami_id             = "ami-03e31863b8e1f70a5"  # Placeholder para LocalStack
