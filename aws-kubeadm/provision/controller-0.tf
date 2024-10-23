resource "aws_instance" "controller-0" {
  ami           = var.AMI_ID
  instance_type = "t3.xlarge"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "20"
    delete_on_termination = "true"
  }

  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.all-traffic.id]
  key_name               = "asamples"

  tags = {
    Name = "kubeadm-controller-0"
    proj = "cka-review"
  }

}
