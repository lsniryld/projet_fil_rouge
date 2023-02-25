resource "aws_instance" "myec2" { 
   ami             = "ami-033b95fb8079dc481"
   instance_type   = var.instancetype
   tags            = var.aws_common_tag
   security_groups = ["${var.sgname}"]
   availability_zone = var.zone_name

   provisioner "local-exec" {
     command = "echo IP: ${var.eip_output} > /var/jenkins_home/workspace/${var.projet_name}/public_ip.txt"
   }

   root_block_device {
     delete_on_termination = true
   }
}
