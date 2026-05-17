

resource "aws_ecr_repository" "frontend_repo" {
  name                 = "innovatech-frontend"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true 
  }
    force_delete = true
}

resource "aws_ecr_repository" "ventas_repo" {
  name                 = "innovatech-ventas"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
    force_delete = true
}

resource "aws_ecr_repository" "despachos_repo" {
  name                 = "innovatech-despachos"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  force_delete = true
}

resource "aws_launch_template" "front_template" {
  name_prefix   = "front-template"
  image_id      = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ssh_access.key_name

  iam_instance_profile {
    name = data.aws_iam_instance_profile.lab_profile.name
  }

  network_interfaces {
    subnet_id                   = aws_subnet.public.id
    associate_public_ip_address = true
    security_groups             = [aws_security_group.web_sg.id]
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    # Esperar conexión a internet
    until curl -s --head http://www.google.com | head -n 1 | grep "200 OK" > /dev/null; do
      echo "Esperando conexión a internet..."
      sleep 5
    done

    yum update -y
    amazon-linux-extras install docker -y
    systemctl enable docker
    systemctl start docker
    
    # Permisos para el usuario ec2-user y clonación limpia
    usermod -aG docker ec2-user
    yum install git -y

    # Preparar carpeta del proyecto para el pipeline
    mkdir -p /home/ec2-user/innovatech-project
    chown -R ec2-user:ec2-user /home/ec2-user/innovatech-project
  EOF
  )
}

resource "aws_launch_template" "back_template" {
  name_prefix   = "back-template"
  image_id      = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ssh_access.key_name

  iam_instance_profile {
    name = data.aws_iam_instance_profile.lab_profile.name
  }

  network_interfaces {
    subnet_id                   = aws_subnet.private.id
    associate_public_ip_address = false 
    security_groups             = [aws_security_group.backend_sg.id]
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    # Esperar conexión mediante la NAT Gateway configurada
    until curl -s --head http://www.google.com | head -n 1 | grep "200 OK" > /dev/null; do
      echo "Esperando conexión a internet..."
      sleep 5
    done

    yum update -y
    amazon-linux-extras install docker -y
    yum install git nmap-ncat -y  

    systemctl enable docker
    systemctl start docker
    usermod -aG docker ec2-user

    # Instalar Docker Compose CLI Plugin (Esencial para orquestar Ventas + Despachos + MySQL Container)
    mkdir -p /usr/local/lib/docker/cli-plugins/
    curl -SL https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
    chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

    # Preparar el directorio de trabajo donde el pipeline meterá el docker-compose y el init.sql
    mkdir -p /home/ec2-user/innovatech-project/db
    chown -R ec2-user:ec2-user /home/ec2-user/innovatech-project
  EOF
  )
}

resource "aws_instance" "front_server" {
  launch_template {
    id      = aws_launch_template.front_template.id
    version = "$Latest"
  }

  tags = {
    Name = "Front-Server-Innovatech"
  }
}

resource "aws_instance" "back_server" {
  launch_template {
    id      = aws_launch_template.back_template.id
    version = "$Latest"
  }

  tags = {
    Name = "Back-Server-Innovatech"
  }
  
  depends_on = [aws_nat_gateway.nat_gw] 
}