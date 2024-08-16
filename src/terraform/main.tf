# main.tf

provider "aws" {
  region = "us-east-1"  # Escolha a região desejada
}

# API Gateway
resource "aws_api_gateway_rest_api" "api_gateway" {
  name        = "api_gateway"
  description = "API Gateway for Meu App"
}

# EventBridge
resource "aws_cloudwatch_event_rule" "eventbridge" {
  name = "eventbridge_rule"
}

# Elastic Load Balancer
resource "aws_elb" "elb" {
  name = "load_balancer"

  availability_zones = ["us-east-1a", "us-east-1b"]

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    protocol          = "HTTP"
  }

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
    healthy_threshold    = 2
    unhealthy_threshold  = 2
  }
}

# Lambda Function
resource "aws_lambda_function" "lambda_service" {
  function_name = "lambda_service"
  
  # Configure Lambda execution role and code location
  role            = "arn:aws:iam::123456789012:role/lambda_exec_role"
  handler         = "index.handler"
  runtime         = "python3.8"
  filename         = "lambda_function.zip"  # Pacote ZIP com o código da Lambda
}

# RDS Database
resource "aws_db_instance" "rds" {
  identifier        = "mydb"
  instance_class    = "db.t2.micro"
  engine            = "mysql"
  username          = "admin"
  password          = "password"
  allocated_storage = 20
  db_name           = "mydatabase"
}

# S3 Bucket
resource "aws_s3_bucket" "bucket" {
  bucket = "my-app-bucket"
}

# Outputs
output "api_gateway_id" {
  value = aws_api_gateway_rest_api.api_gateway.id
}

output "eventbridge_rule_arn" {
  value = aws_cloudwatch_event_rule.eventbridge.arn
}

output "elb_dns_name" {
  value = aws_elb.elb.dns_name
}

output "lambda_function_name" {
  value = aws_lambda_function.lambda_service.function_name
}

output "rds_endpoint" {
  value = aws_db_instance.rds.endpoint
}

output "s3_bucket_name" {
  value = aws_s3_bucket.bucket.bucket
}
