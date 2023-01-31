output "ec2_output" {
  value = aws_instance.myec2.id
}

output "ec2_zone" {
  value = aws_instance.myec2.availability_zone
}
