resource "aws_dynamodb_table" "terraform_statelock" {
  name           = "terraform-statelock"
  read_capacity  = "5"
  write_capacity = "5"
  hash_key       = "LockID"              # The table must have a primary key named LockID for state locking

  attribute {
    name = "LockID"
    type = "S"
  }
}
