terraform {
  backend "s3" {
    bucket = "terraform-state-960" # change it to the name of the name of your bucket
    key    = "dev"
    region = "us-east-1"
    dynamodb_table = "terraform-statelock"
  }
}
