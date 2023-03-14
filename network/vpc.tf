resource "aws_vpc" "sprints_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  enable_classiclink = false
  enable_classiclink_dns_support = false
  
  tags = {
    Name = "sprints_vpc"
  }
}