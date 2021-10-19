provider "aws" {}

variable "az" {
  default = {
    "0" = "us-east-2a"
    "1" = "us-east-2b"
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.10.10.0/24"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "VPCName"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "GWName"
  }
}

resource "aws_route_table" "table2" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Table2Name"
  }
}

resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.table2.id
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_subnet" "main1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.10.10.0/25"
  availability_zone = "${var.az[0]}"
  map_public_ip_on_launch = true
  tags = {
    Name = "MainSubnet1"
  }
}

resource "aws_subnet" "main2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.10.10.128/25"
  availability_zone = "${var.az[1]}"
  map_public_ip_on_launch = true
  tags = {
    Name = "MainSubnet2"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = "${aws_subnet.main1.id}"
  route_table_id = "${aws_route_table.table2.id}"
}

resource "aws_route_table_association" "b" {
  subnet_id      = "${aws_subnet.main2.id}"
  route_table_id = "${aws_route_table.table2.id}"
}

resource "aws_security_group" "sg" {
  name        = "my_sec_group"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_launch_configuration" "lc" {
  name          = "my_config"
  image_id      = "ami-074cce78125f09d61"
  key_name      = "my_key_pair"
  security_groups = [aws_security_group.sg.id]
  instance_type = "t2.micro"
  user_data = file("userdata.txt")
}


resource "aws_elb" "lb" {
  name               = "MyLB"
  subnets           = [aws_subnet.main1.id, aws_subnet.main2.id]
  security_groups = [aws_security_group.sg.id]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    target              = "HTTP:80/index.html"
    interval            = 10
  }
  tags = {
    Name = "MainLB"
  }
}


resource "aws_autoscaling_group" "ag" {
  name                      = "MyASGroup"
  vpc_zone_identifier       = [aws_subnet.main1.id, aws_subnet.main2.id]
  launch_configuration      = aws_launch_configuration.lc.name
  max_size                  = 2
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  load_balancers            = [aws_elb.lb.name]
  depends_on = [aws_elb.lb]
}
