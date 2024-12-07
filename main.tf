provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0c02fb55956c7d316" # Example AMI ID
  instance_type = "t2.micro"
  tags = {
    Name = "AppServer"
  }
}

resource "aws_elb" "app_lb" {
  name               = "app-lb"
  availability_zones = ["us-east-1a", "us-east-1b"]

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  instances = [aws_instance.app_server.id]
}

resource "aws_db_instance" "app_db" {
  identifier            = "app-db"
  engine                = "mysql"
  instance_class        = "db.t2.micro"
  allocated_storage     = 20
  name                  = "appdb"
  username              = "admin"
  password              = "password"
  publicly_accessible   = true
  skip_final_snapshot   = true
}
