#!/bin/bash

## taint and recreate the controller and worker nodes to re-install
## w/out tearing downw the whole vpc..

terraform taint aws_instance.controller-0
terraform taint aws_instance.worker-0
terraform taint aws_instance.worker-1

terraform apply -auto-approve

