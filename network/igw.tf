resource "aws_internet_gateway" "sprints_igw" {
  vpc_id = aws_vpc.sprints_vpc.id
  tags = {
    "Name" = "sprints_igw"
  }
}