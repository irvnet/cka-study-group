
resource "aws_security_group" "all-traffic" {
  vpc_id      = module.vpc.vpc_id
  name        = "all-traffic"
  description = "security group allowing all traffic for ingress/egress"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0 
    to_port     = 0 
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    proj      = "k8s-node"
    terraform = true
    env       = "test"
  }


}

