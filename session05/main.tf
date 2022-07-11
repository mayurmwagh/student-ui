resource "aws_vpc" "main-vpc"{
    cidr_block = "10.0.0.0/16"

    tags = {
      name = var.vpc-tags
    }

}
######################################################
resource "aws_subnet" "pub-sub" {
     
    vpc_id = aws_vpc.main-vpc.id
    cidr_block = var.cidr_block-pub.pub0
     
     tags = {
        name = "${var.namespace}-pub1"
     }
}

resource "aws_subnet" "pub-sub-1" {
     
    vpc_id = aws_vpc.main-vpc.id
    cidr_block = var.cidr_block-pub.pub1

     tags = {
        name = "${var.namespace}-pub2"
     }
    
}


###-PRIVATE-SUBNET-1-#######
resource "aws_subnet" "pri-sub-1" {
     
    vpc_id = aws_vpc.main-vpc.id
    cidr_block = var.cidr_block-pri.pri0

    tags = {
    name = "${var.namespace}-sub-pri-1"
  }
}



resource "aws_subnet" "pri-sub-2" {
     
    vpc_id = aws_vpc.main-vpc.id
    cidr_block = var.cidr_block-pri.pri1

    tags = {
    name = "${var.namespace}-sub-pri-2"
  }
}



resource "aws_subnet" "pri-sub-3" {
     
    vpc_id = aws_vpc.main-vpc.id
    cidr_block = var.cidr_block-pri.pri2

    tags = {
    name = "${var.namespace}-sub-asso-3"
  }
}



####################################################################3


resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.pub-sub.id
  route_table_id = aws_route_table.rakesh.id

 
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.pub-sub-1.id
  route_table_id = aws_route_table.rakesh.id

  
}

############################################################################

resource "aws_route_table" "rakesh" {
  vpc_id = aws_vpc.main-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

 tags = {
    name = "${var.namespace}-RT"
  }
}

###################################################3#####

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main-vpc.id

   tags = {
    name = "${var.namespace}-igw"
  }
}


resource "aws_instance" "web" {
  ami           = var.instance_id
  instance_type = var.instance_type
  key_name = aws_key_pair.generated_key.id
  security_groups = [aws_security_group.allow_tls.id]
  subnet_id      = aws_subnet.pub-sub.id
  availability_zone           = var.availability_zone
  associate_public_ip_address = var.associate_public_ip_address
  
  tags = {
    Name = "vpc-1-pub"
  }
}    
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "batch-18"
  public_key = tls_private_key.example.public_key_openssh
}


resource "aws_security_group" "allow_tls" {
  name        = "rakesh_sg22"
  vpc_id = aws_vpc.main-vpc.id
  description = "allow tls inbound traffic"

  dynamic "ingress" {
    for_each = local.ingress_rules


    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "rakesh_sg22"
  }

}

resource "aws_eip" "lb" {
  instance = aws_instance.web.id
  vpc      = true
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.web.id
  allocation_id = aws_eip.lb.id
}
