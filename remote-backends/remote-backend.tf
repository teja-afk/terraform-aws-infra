# s3
resource "aws_s3_bucket" "remote-s3-bucket" {
  bucket = "my-remote-backend-s3-bucket"

  tags = {
    Name = "my-remote-backend-s3-bucket"
  }
}


# dynamodb
resource "aws_dynamodb_table" "dynamodb-table" {
  name         = "remote-backend-dynamodb-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockId"

  attribute {
    name = "LockId"
    type = "S"
  }
}