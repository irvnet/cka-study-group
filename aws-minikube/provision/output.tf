
output "ssh-cmd" {
  value = "ssh -i ~/.ssh/asamples.pem ubuntu@${aws_instance.controller-0.public_ip}"
}
