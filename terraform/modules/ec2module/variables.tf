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

variable "ubuntu_account_number" {
  default = "099720109477"
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
