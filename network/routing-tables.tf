resource "aws_route_table" "sprints_public" {
    vpc_id = aws_vpc.sprints_vpc.id
  
    tags = {
      "Name" = "sprints_public"
    }
}

resource "aws_route" "public_route" {
  route_table_id            = aws_route_table.sprints_public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.sprints_igw.id
}

resource "aws_route_table_association" "sprints_public_1" {
    subnet_id = aws_subnet.sprints_public_1.id
    route_table_id = aws_route_table.sprints_public.id
}

resource "aws_route_table_association" "sprints_public_2" {
    subnet_id = aws_subnet.sprints_public_2.id
    route_table_id = aws_route_table.sprints_public.id
}