provider "aws" {
  region        = "${var.aws_region}"
  access_key    = "${var.access_key}"
  secret_key    = "${var.secret_key}"
}

data "aws_ami" "image_name" {
  filter {
    name   = "name"
    values = ["${var.image_name}"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_vpc" "main" {
  id = "${var.vpc_id}"
}

resource "aws_key_pair" "public-key-kelson-dell" {
  key_name   = "public-key-kelson-dell"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCcDpzuxd+60oWz+EYgL8zy4VyMnElzmn7/plDmpgqwpysay3fsYSNvsgrHUaSkjEGP6YZH4lc5Ar2GdVFZA3q2F0O/s4O+6bZpPU0Uc08uBll/AmugGbjLZ8BqKBkTJQ+pNFTMaUYVzSHa8+Ik2WwvM+/tIo3KuS2ANSWwNCZQJQYcOGobS/U/X0+Mj5fPE3d0XV+h+AVOELJLC8T/b56sP99ATIacvdCF08+rVE5HlJE3/pCqCydZs6/XuaD3KYhr2zoYffZTxtb7u2T68MD5PpiYCe496DYV48AKJpN5yXO4GumkZk+knoPwhJcjqCFa3Q8/RBhtzHDWTRCG9LXT4XX1wMSNEdS71+tVr3brZ7R9gvd6au85WcvHLw/JzWsKKFwHtdcwJal7SsOdaPuJhBjEUQ0KdeKtNSlfJyU7MJ9Qkn3uR+aEHsGcvAaIL+GVVEMP/DTgL87DId7IGda9fiB/WLwD9Z+fZAuYwZre6x0dNM1FbhnYv7BK51E04Uhk2sUYFlgOiFY3PSvsOYoyXvM88mdxlg4o/wQgiWKHdLlCq34JAFGTbYjhTEwb0ORH9sBdNiKxjMFgxj4iWxxzxrpAeYwPSiwifc1wxp/gQlLjUnJDUfeCKuOlTpyNax5LncPUEJOEuLock7ltuScxGbPXhnoWKgBAPIcw901m9w== kelson@KelsonLT"
}

resource "aws_security_group" "allow_http_https" {
  name        = "allow_http_https"
  description = "Allow http/https traffic"
  vpc_id      = "${data.aws_vpc.main.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_output" {
  name        = "allow_output"
  description = "Allow output traffic"
  vpc_id      = "${data.aws_vpc.main.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh traffic"
  vpc_id      = "${data.aws_vpc.main.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.ssh_permited_access}"]
  }
}

resource "aws_instance" "desafio-devops" {
  ami           = "${data.aws_ami.image_name.id}"
  instance_type = "${var.instance_type}"
  key_name      = "public-key-kelson-dell"

  security_groups = [
    "${aws_security_group.allow_http_https.name}",
    "${aws_security_group.allow_ssh.name}",
    "${aws_security_group.allow_output.name}",
  ]

  provisioner "remote-exec" {
    inline = [
      "sudo apt remove docker docker-engine docker.io -y",
      "sudo apt update",
      "sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"",
      "sudo apt update",
      "sudo apt install python aptitude docker-ce python-pip -y",
      "sudo pip install docker"
    ]

    connection {
        type = "ssh"
        user = "ubuntu"
    }
  }

  provisioner "local-exec" {
    command = "sleep 30; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i '${aws_instance.desafio-devops.public_ip},' ./ansible/playbook.yml"
  }

  tags {
    Name = "Desafio-DevOps"
  }
}

output "instance_ip" {
  value = "${aws_instance.desafio-devops.public_ip}"
}
