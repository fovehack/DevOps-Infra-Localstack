provider "aws" {
  region                      = var.aws_region
  access_key                  = "fake_access_key"
  secret_key                  = "fake_secret_key"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  endpoints {
    s3       = "http://localhost:4566"
    dynamodb = "http://localhost:4566"
    ec2      = "http://localhost:4566"
  }
}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.subnet_cidr

  tags = {
    Name = "my-subnet"
  }
}

resource "aws_instance" "my_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.my_subnet.id

  tags = {
    Name = "my-instance"
  }
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = var.s3_bucket_name

  tags = {
    Name = "my-bucket"
  }
}

resource "aws_dynamodb_table" "my_table" {
  name           = var.dynamodb_table_name
  hash_key       = "Id"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "Id"
    type = "S"
  }

  tags = {
    Name = "MyDynamoDBTable"
  }
}
