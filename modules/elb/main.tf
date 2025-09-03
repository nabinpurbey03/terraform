# Application Load Balancer
resource "aws_lb" "alb" {
  name               = "${var.name}-alb"
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = var.alb_sg_ids
  enable_deletion_protection = false

  tags = {
    Name = "tf-${var.name}-alb"
  }
}

# Target Group for ASG instances
resource "aws_lb_target_group" "tg" {
  name     = "${var.name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }
}

# HTTP Listener (port 80)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

# HTTPS Listener (port 443) -> redirect to 80
resource "aws_lb_listener" "https_redirect" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"

  default_action {
    type = "redirect"
    redirect {
      protocol    = "HTTP"
      port        = "80"
      status_code = "HTTP_301"
    }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "asg" {
  name                      = "${var.name}-asg"
  max_size                  = var.asg_max_size
  min_size                  = var.asg_min_size
  desired_capacity          = var.asg_desired_capacity
  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }
  vpc_zone_identifier       = var.public_subnets
  target_group_arns         = [aws_lb_target_group.tg.arn]

  health_check_type         = "EC2"
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "${var.name}-asg-instance"
    propagate_at_launch = true
  }
}
