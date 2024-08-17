variable "aws_region" {
  description = "La región en la que se despliegan los recursos de AWS"
  default     = "us-east-1"
}

variable "s3_bucket_name" {
  description = "El nombre del bucket S3"
  default     = "my-bucket"
}

variable "dynamodb_table_name" {
  description = "El nombre de la tabla DynamoDB"
  default     = "MyTable"
}

variable "vpc_cidr" {
  description = "El bloque CIDR para la VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "El bloque CIDR para la Subred"
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "El tipo de instancia EC2"
  default     = "t2.micro"
}

variable "ami_id" {
  description = "El ID de la AMI para la instancia EC2"
  default     = "ami-03e31863b8e1f70a5"
}
