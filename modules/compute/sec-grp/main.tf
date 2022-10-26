
resource "aws_security_group" "sg-name" {
  #checkov:skip=CKV_AWS_23:description set through variables
  name        = "SG-${var.sg_name}"
  description = var.description
  vpc_id      = var.vpc_id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    Name = "${var.sg_name}"
  }
}

resource "aws_security_group_rule" "rules" {
  for_each          = var.rules
  description       = each.value["description"]
  cidr_blocks       = each.value["cidr_blocks"]
  from_port         = each.value["from_port"]
  to_port           = each.value["to_port"]
  protocol          = each.value["protocol"]
  security_group_id = aws_security_group.sg-name.id
  type              = "ingress"
}
