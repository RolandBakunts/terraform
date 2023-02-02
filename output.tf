output "public_ip" {
	value = aws_instance.image.public_ip
}

output "public_ips" {
	value = aws_instance.instances.*.public_ip
}