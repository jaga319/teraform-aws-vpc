resource "aws_vpc_peering_connection" "peering" {
  count = var.is_peering_required ? 1 : 0
  vpc_id        = aws_vpc.main.id
  peer_vpc_id = var.accepter_vpc_id == "" ? data.aws_vpc.default_vpc.id : var.accepter_vpc_id
  auto_accept = var.accepter_vpc_id == "" ? true : false

  tags = merge(var.common_tags,var.vpc_peering_tags,
  {
    Name="${var.project_name}-${var.environment}"
  }
  )

}

resource "aws_route" "acceptor_route" {
  count = var.is_peering_required && var.accepter_vpc_id == ""  ? 1 : 0
  route_table_id            = data.aws_route_table.default.id
  destination_cidr_block    = var.roboshop_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

resource "aws_route" "public_peering" {
  count = var.is_peering_required && var.accepter_vpc_id == ""  ? 1 : 0
  route_table_id            = aws_route_table.main_route_table_public.id
  destination_cidr_block    = data.aws_vpc.default_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

resource "aws_route" "private_peering" {
  count = var.is_peering_required && var.accepter_vpc_id == ""  ? 1 : 0
  route_table_id            = aws_route_table.main_route_table_private.id
  destination_cidr_block    = data.aws_vpc.default_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

resource "aws_route" "database_peering" {
  count = var.is_peering_required && var.accepter_vpc_id == ""  ? 1 : 0
  route_table_id            = aws_route_table.main_route_table_database.id
  destination_cidr_block    = data.aws_vpc.default_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

