resource "aws_subnet" "sprints_public_1" {
    vpc_id = aws_vpc.sprints_vpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    tags = {
      "Name" = "sprints_public_us-east-1a"
      "kubernetes.io/cluster/eks" = "shared"
      "kubernetes.io/role/elb" = 1
    }
}
resource "aws_subnet" "sprints_public_2" {
    vpc_id = aws_vpc.sprints_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true
    tags = {
      "Name" = "sprints_public_us-east-1b"
      "kubernetes.io/cluster/eks" = "shared"
      "kubernetes.io/role/elb" = 1
    }
}

