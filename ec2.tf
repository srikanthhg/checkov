resource "aws_instance" "bootstrap" {
  ami                         = data.aws_ami.ubuntu.id
  subnet_id                   = "subnet-0f219f655b0b7fc30"
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  key_name                    = "hipstershop"

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 30
    volume_type = "gp3"
  }

  tags = {
    Name = "Bootstrap"
  }
}