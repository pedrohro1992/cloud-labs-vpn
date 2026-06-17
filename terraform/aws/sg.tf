//tODO Adicionar dynamic_block para regras de ingress e egress do security_group
resource "aws_security_group" "pivpn" {
  description = "PiVPN Security group"
  name        = "${var.cluster_name}-pivpn"
  vpc_id      = data.aws_vpc.this.id
  tags = {
    Application = "pivpn"
  }
}

resource "aws_security_group_rule" "pivpn_ssh_port" {
  description       = "Enable ssh to PiVPN server"
  type              = "ingress"
  security_group_id = aws_security_group.pivpn.id

  from_port   = var.ssh_server_port
  to_port     = var.ssh_server_port
  protocol    = var.server_protocol
  cidr_blocks = var.public_cidr_blocks
}

resource "aws_security_group_rule" "pivpn_vpn_port" {
  description       = "Enable ssh to PiVPN server"
  type              = "ingress"
  security_group_id = aws_security_group.pivpn.id

  from_port   = var.pivpn_port
  to_port     = var.pivpn_port
  protocol    = var.pivpn_protocol
  cidr_blocks = var.public_cidr_blocks
}

resource "aws_security_group_rule" "ansible_egress" {
  description       = "Allow communicate with the internet"
  type              = "egress"
  security_group_id = aws_security_group.pivpn.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = var.public_cidr_blocks
}

