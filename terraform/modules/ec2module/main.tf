data "aws_ami" "ubuntu-18_04" {
  most_recent = true
  owners      = ["${var.ubuntu_account_number}"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

resource "aws_instance" "myec2" { 
   ami             = data.aws_ami.ubuntu-18_04.id
   instance_type   = var.instancetype
   key_name        = "devops-${var.name_maintainer}"
   tags            = var.aws_common_tag
   availability_zone = "${var.zone_name}"
   security_groups = ["${var.sgname}"]

   provisioner "remote-exec" {
     inline = [
       "sudo apt update -y",
       "sudo apt install -y nginx",
       "sudo systemctl start nginx"
     ]
   }
   connection {
     type        = "ssh"
     user        = "ubuntu"
     private_key = file("./devops-niry.pem")
     host        = self.public_ip
   }

   provisioner "local-exec" {
     command = "echo PUBLIC IP: ${var.eip_output} ; ID: ${aws_instance.myec2.id} ; AZ: ${aws_instance.myec2.availability_zone}; >> ip_ec2.txt"
   }

   root_block_device {
     delete_on_termination = true
   }
}
