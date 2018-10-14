variable "aws_region" {}

variable "access_key" {}
variable "secret_key" {}

variable "ssh_permited_access" {}

variable "image_name" {
    type    = "string"
    default = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20180912"
}

variable "instance_type" {
    type    = "string"
    default = "t2.micro"
}

variable "vpc_id" {
    type    = "string"
    default = "vpc-32629356"
}
