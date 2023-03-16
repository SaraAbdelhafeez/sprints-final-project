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
  # Install kubectl
  user_data = <<EOF
#!/bin/bash

# Download the latest release 
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Validate the binary
# Download the kubectl checksum file
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

# Validate the kubectl binary against the checksum file
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

# Install kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Test to ensure the version you installed is up-to-date
kubectl version --client --output=yaml    

# install helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
sudo chmod 700 get_helm.sh
./get_helm.sh

# install awscli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip
unzip awscliv2.zip
sudo ./aws/install

EOF
  

}

resource "aws_network_interface_sg_attachment" "jenkins_sg_attachment" {
  security_group_id    = aws_security_group.allow_ssh_8080.id
  network_interface_id = aws_instance.jenkins.primary_network_interface_id

  provisioner "local-exec" { 
    
    command = "echo '[jenkins]\n${aws_instance.jenkins.public_ip} ansible_user=ubuntu\n[docker]\n${aws_instance.jenkins.public_ip} ansible_user=ubuntu\n[aws]\n${aws_instance.jenkins.public_ip} ansible_user=ubuntu' > ./inventory "
  }
  provisioner "local-exec" { 
    
    command = "sleep 1m"
  }
  provisioner "local-exec" { 
    
    command = "ansible-playbook -i inventory --private-key ./jenkins_key.pem ./project.yml --ssh-common-args='-o StrictHostKeyChecking=no'"
  }

 

}




