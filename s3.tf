resource "aws_s3_bucket" "b" {
  bucket = "mybucket-${var.name-tag}"
  acl    = "public-read"
  
  tags = {
        Name    ="s3_${var.name-tag}"
        Owner   ="${var.owner-tag}"
        Project ="${var.project-tag}"
    }
}

terraform {
  backend "s3" {
    bucket = "mybucket-${var.name-tag}"
    key    = "./terraform.tfstate"
    region = "us-east-1"
  }
}