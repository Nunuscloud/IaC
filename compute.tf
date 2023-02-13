data "aws_ami" "server_ami" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "random_id" "nunu_node_id" {
  byte_length = 2
  count       = var.main_instance_count
}

resource "aws_key_pair" "nunu_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}


resource "aws_instance" "nunu_main" {
  count                  = var.main_instance_count
  instance_type          = var.main_instance_type                        # 인스턴스 유형
  ami                    = data.aws_ami.server_ami.id                    # 머신 이미지 
  key_name               = aws_key_pair.nunu_auth.id                     #  
  vpc_security_group_ids = [aws_security_group.nunu_sg.id]               # 보안그룹 
  subnet_id              = aws_subnet.nunu_public_subnet[count.index].id # 첫번째 퍼블릭 서브넷으로 설정
  user_data              = templatefile("/home/ubuntu/dev/main-userdata.tpl", { new_hostname = "nunu_main-${random_id.nunu_node_id[count.index].dec}" })
  root_block_device {
    volume_size = var.main_vol_size
  }

  tags = {
    Name = "nunu_main-${random_id.nunu_node_id[count.index].dec}"
  }
}

