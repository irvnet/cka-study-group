
resource "aws_instance" "worker-1" {
  ami           = var.AMI_ID
  instance_type = "t2.large"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "20"
    delete_on_termination = "true"
  }

  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.all-traffic.id]
  key_name               = "asamples"

  tags = {
    Name = "kubeadm-worker-1"
    proj = "cka-review"
  }

}
