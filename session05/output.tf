output "public_info" {
    value = aws_instance.web.public_ip

}

output "security_groups" {
  value = aws_security_group.allow_tls.id
}
