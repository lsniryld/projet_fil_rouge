output "eip_public_ip" {
  value = aws_eip.myeip.public_ip
}

output "eip_allocation_id" {
  value = aws_eip.myeip.allocation_id
}
