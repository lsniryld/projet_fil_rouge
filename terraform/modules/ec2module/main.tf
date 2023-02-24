resource "aws_instance" "myec2" { 
   ami             = "ami-033b95fb8079dc481"
   instance_type   = var.instancetype
   key_name        = "devops"
   tags            = var.aws_common_tag
   availability_zone = "${var.zone_name}"
   security_groups = ["${var.sgname}"]

   provisioner "local-exec" {
     command = "echo IP: ${var.public_ip} > /var/jenkins_home/workspace/${var.projet_name}/public_ip.txt"
   }

   root_block_device {
     delete_on_termination = true
   }
}
