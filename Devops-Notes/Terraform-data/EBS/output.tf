output "ebs_volume_id" {
  value = aws_ebs_volume.example.id
}

output "ebs_volume_size" {
  value = aws_ebs_volume.example.size
}

output "ebs_volume_device" {
  value = aws_volume_attachment.ebs_att.device_name
}