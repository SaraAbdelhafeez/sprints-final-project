data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "jenkins" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = var.public1_subnet_id
  key_name = "${aws_key_pair.key_pair.key_name}"
  associate_public_ip_address = true
  tags = {
    Name = "jenkins"
  }
  user_data = <<EOF
    #!/bin/bash
    # Install docker
    apt-get update
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) \
      stable"
    apt-get update
    apt-get install -y docker
    usermod -aG docker ubuntu

    # Install docker-compose
    curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose

    chmod 777 /var/run/docker.sock
    EOF

}

resource "aws_network_interface_sg_attachment" "jenkins_sg_attachment" {
  security_group_id    = aws_security_group.allow_ssh_8080.id
  network_interface_id = aws_instance.jenkins.primary_network_interface_id

  provisioner "local-exec" { 
    
    command = "echo '[jenkins]\n${aws_instance.jenkins.public_ip} ansible_user=ubuntu\n[docker]\n${aws_instance.jenkins.public_ip} ansible_user=ubuntu' > ./inventory "
  }
  provisioner "local-exec" { 
    
    command = "sleep 1m"
  }
  provisioner "local-exec" { 
    
    command = "ansible-playbook -i inventory --private-key ./jenkins_key.pem ./project.yml --ssh-common-args='-o StrictHostKeyChecking=no'"
  }
}




