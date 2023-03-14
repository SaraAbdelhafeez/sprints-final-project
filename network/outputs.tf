output "vpc_id" {
  value = aws_vpc.sprints_vpc.id
  description = "vpc id."
}

output "public1_subnet_id" {
  value = aws_subnet.sprints_public_1.id
}

output "public2_subnet_id" {
  value = aws_subnet.sprints_public_2.id
}