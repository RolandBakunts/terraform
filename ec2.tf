# create public subnet
resource "aws_subnet" "public" {
  count             = var.instance_count
  vpc_id            = aws_vpc.yvn_intern_vpc.id
  cidr_block        = element(var.cidr-block-pb-subnet, count.index)
  availability_zone = element(var.azs, count.index)
  # map_public_ip_on_launch = true

  tags = {
    Name    ="PB_SUBNET${var.name-tag}${count.index+1}"
    Owner   ="${var.owner-tag}"
    Project ="${var.project-tag}"
  }
}

# Route table association with public subnets
resource "aws_route_table_association" "a" {
  count          = length(var.cidr-block-pb-subnet)
  subnet_id      = element(aws_subnet.public.*.id,count.index)
  route_table_id = aws_route_table.yvn_intern_route_table.id
}

resource "aws_instance" "instances" {
  count                       = var.instance_count
  ami                         = aws_ami_from_instance.ami.id
  instance_type               = var.instance-type
  subnet_id                   = element(aws_subnet.public.*.id,count.index)
  key_name                    = aws_key_pair.yvn_intern_key.id
  vpc_security_group_ids      = [aws_security_group.yvn_intern_security_group.id]
  associate_public_ip_address = true

  tags = {
        Name    ="ec2_${var.name-tag}_${count.index + 1}"
        Owner   ="${var.owner-tag}"
        Project ="${var.project-tag}"
    }
}