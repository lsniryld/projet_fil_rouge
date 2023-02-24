variable "instancetype" {
  type        = string
  description = "set aws instance type"
  default     = "t2.nano"
}

variable "sgname" {
  type        = string
  description = "set security group name"
  default     = "niry-sg"
}

variable "aws_common_tag" {
  type        = map(any)
  description = "set aws tag"
  default = {
    Name = "ec2-niry"
  }
}

variable "name_maintainer" {
  type        = string
  description = "name of the maintainer"
  default     = "niry"
}

variable "eip_output" {
  type    = string
  default = "127.0.0.1"
}

variable "zone_name" {
  type        = string
  description = "zone name"
  default     = "us-east-1"
}

variable "projet_name" {
  type    = string
  default = "projet_fil_rouge"
}

variable "public_ip" {
  type    = string
  default = "127.0.0.1"
}
