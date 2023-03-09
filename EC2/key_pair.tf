resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "jenkins_key"      # Create a "jenkins_key" to AWS!!
  public_key = tls_private_key.pk.public_key_openssh

  provisioner "local-exec" { # Create a "jenkins_key" to your computer!!
    command = "echo '${tls_private_key.pk.private_key_pem}' > ./jenkins_key.pem "
  }
  provisioner "local-exec" { 
    
    command = "chmod 400 jenkins_key.pem"
  }

}