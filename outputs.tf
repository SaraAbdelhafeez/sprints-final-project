output "flask-app-ecr-url" {
  value = module.ECR.flask-app-ecr-url
}
output "mysql-db-ecr-url" {
  value = module.ECR.mysql-db-ecr-url
}

output "jenkins_ip" {
  value = module.EC2.jenkins_ip
}