resource "aws_instance" "main" {
  ami           = "${data.aws_ami.amzn-linux.id}"
  instance_type = "t2.micro"

  tags {
    Name = "state-lock-demo"
  }

  provisioner "local-exec" {
    command = "sleep 90"
  }
}

data "aws_ami" "amzn-linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-*-x86_64-gp2"]
  }
}
