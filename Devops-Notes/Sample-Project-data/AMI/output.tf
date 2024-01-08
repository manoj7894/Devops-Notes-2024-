output "ami_id" {
  value = aws_ami_from_instance.example.id
}

output "public_ip_addresses" {
  value = [aws_instance.first.public_ip, aws_instance.second.public_ip]
}
