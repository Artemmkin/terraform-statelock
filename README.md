## Terraform state file locking demo

1. Create an S3 bucket to store state file and DynamoDB table to enable state file locking.

```bash
$ cd ./terraform-required
$ terraform init
$ terraform apply
```
2. Grab the name of the bucket created from terraform output. It will be the laste part of ARN.

For example, if you got an output like this:
```
bucket_name = arn:aws:s3:::terraform-state-960
```

The name of the bucket is `terraform-state-960`.

3. Move back to the root directory. Change the name of the bucket in `remote-backend.tf` file:

```
terraform {
  backend "s3" {
    bucket = "terraform-state-960" # <= change this to the name of your bucket
    key    = "dev"
    region = "us-east-1"
    dynamodb_table = "terraform-statelock"
  }
}
```

4. Launch instance to check how state locking works. The instance resource uses a `local-exec` provisioner to delay the creation of a resource:
```
provisioner "local-exec" {
  command = "sleep 90"
}
```

To launch instance, run:

```bash
$ terraform init
$ terraform apply
```

5. While instance is creating, open another terminal and try to run terraform apply again in the same directory. The apply should fail because of the enabled state file locking:
```bash
$ terraform apply
Acquiring state lock. This may take a few moments...

Error: Error locking state: Error acquiring the state lock: ConditionalCheckFailedException: The conditional request failed
...
```
6. You may also be interested in opening a AWS Management Console and checking the contents of DynamoDB table `terraform-statelock` used for locking.

7. Destroy the playground:
* Run terraform destroy in the root directory 
* Remove the state files from the bucket:
```
$ aws --region us-east-1 s3 rm s3://terraform-state-960 --recursive # use the name of your bucket
```
* Run terraform destroy in `terraform-required` directory 
