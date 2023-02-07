#create security group for Load Balancer
resource "aws_security_group" "yvn_intern_security_group_load_balancer" {
  name        = "allow_alb"
  description = "Allow ALB inbound traffic"
  vpc_id      = aws_vpc.yvn_intern_vpc.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.cidr-block-route_tb]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [var.cidr-block-route_tb]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.cidr-block-route_tb]
  }

    tags = {
        Name="ScGr${var.name-tag}"
        Owner="${var.owner-tag}"
        Project="${var.project-tag}"
    }
}


resource "aws_lb" "alb" {
  name               = "yvn-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.yvn_intern_security_group_load_balancer.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]
#   subnets            = element(aws_subnet.public.*.id)

#   enable_deletion_protection = true


  tags = {
        Name    ="alb_${var.name-tag}_${var.instance_count + 1}"
        Owner   ="${var.owner-tag}"
        Project ="${var.project-tag}"
    }
}

resource "aws_lb_target_group" "alb-group" {
  name        = "yvn-alb-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.yvn_intern_vpc.id

  health_check {
    enabled              = true
    interval             = "300"
    path                 = "/index.html"
    timeout              = "60"
    matcher              = "200"
    healthy_threshold    = "5"
    unhealthy_threshold  = "5"
  }
}

resource "aws_alb_listener" "listener_http" {
  load_balancer_arn = "${aws_lb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.alb-group.arn}"
    type             = "forward"
  }
}