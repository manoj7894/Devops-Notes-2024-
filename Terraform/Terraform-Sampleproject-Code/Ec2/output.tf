#output "public_ip_address" {
#  value = aws_instance.example_instance.public_ip
#}

output "public_ip_addresses" {
  value = aws_instance.example_instance[*].public_ip
}