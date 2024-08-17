output "s3_bucket_name" {
  description = "El nombre del bucket S3"
  value       = aws_s3_bucket.my_bucket.id
}

output "dynamodb_table_name" {
  description = "El nombre de la tabla DynamoDB"
  value       = aws_dynamodb_table.my_table.name
}

output "vpc_id" {
  description = "El ID de la VPC"
  value       = aws_vpc.my_vpc.id
}

output "subnet_id" {
  description = "El ID de la Subnet"
  value       = aws_subnet.my_subnet.id
}

output "instance_id" {
  description = "El ID de la instancia EC2"
  value       = aws_instance.my_instance.id
}
