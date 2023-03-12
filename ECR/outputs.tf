output "flask-app-ecr-url" {
  value = aws_ecr_repository.flask-app.repository_url
}
output "mysql-db-ecr-url" {
  value = aws_ecr_repository.mysql-db.repository_url
}