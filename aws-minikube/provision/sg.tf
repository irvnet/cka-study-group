
resource "aws_security_group" "allow-ssh" {
  vpc_id      = module.vpc.vpc_id
  name        = "allow-ssh"
  description = "security group that allows ssh and all egress traffic"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # TFE access (HTTP; redirects to HTTPS)
  #   ingress {
  #       from_port = 80
  #       to_port = 80
  #       protocol = "tcp"
  #       cidr_blocks = ["0.0.0.0/0"]
  #   }

  #   # TFE access (HTTPS)
  #   ingress {
  #       from_port = 443
  #       to_port = 443
  #       protocol = "tcp"
  #       cidr_blocks = ["0.0.0.0/0"]
  #   }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #   ingress {
  #       from_port = 8800
  #       to_port = 8800
  #       protocol = "tcp"
  #       cidr_blocks = ["0.0.0.0/0"]
  #   }

  tags = {
    proj      = "k8s-node"
    terraform = true
    env       = "test"
  }


}

