data "aws_ami" "pivpn_ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "tag:Name"
    values = ["pivpn-base"] 
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


data "aws_vpc" "this" {
  tags = {
    Name = "cloud-labs-vpc"
  }
}


data "aws_subnet" "public" {
  // Gambiarra pra poder usar o data source pra uma subnet
  count = 1
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
  tags = {
    Tier = "Public"
  }
  //Definir CIDR Block da subnet desejada- DebTec 01
  cidr_block = "10.0.101.0/24"
}

