resource "aws_instance" "pivpn_instance" {
  ami           = data.aws_ami.pivpn_ami.id # Referencia o novo data source
  instance_type = "t2.micro"
  key_name      = aws_key_pair.generated_key.key_name
  
  vpc_security_group_ids      = [aws_security_group.pivpn.id]
  associate_public_ip_address = true
  subnet_id                   = data.aws_subnet.public[0].id

  # Ajuste automático do PiVPN ao subir a instância
  user_data = <<-EOF
              #!/bin/bash
              PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
              sed -i "s/127.0.0.1/$PUBLIC_IP/" /etc/pivpn/wireguard/setupVars.conf
              systemctl restart wg-quick@wg0
              EOF

  tags = {
    Name = "PiVPN"
    App  = "pivpn"
  }
}

resource "aws_eip" "pivpn_eip" {
  domain = "vpc"
}

resource "aws_eip_association" "pivpn_eip_association" {
  instance_id   = aws_instance.pivpn_instance.id
  allocation_id = aws_eip.pivpn_eip.id
}

