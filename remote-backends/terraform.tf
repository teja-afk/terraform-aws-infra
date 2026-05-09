terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "my-remote-backend-s3-bucket"
    dynamodb_table = "remote-backend-dynamodb-table"
    use_lockfile = true
    key = "terraform.tfstate"
    region = "us-west-2" 
  }
}