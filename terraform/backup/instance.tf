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
  instance_type          = var.main_instance_type
  ami                    = data.aws_ami.server_ami.id
  key_name               = aws_key_pair.nunu_auth.id
  vpc_security_group_ids = [aws_security_group.nunu_sg.id]
  subnet_id              = aws_subnet.nunu_public_subnet[count.index].id
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  # user_data = templatefile("./main-userdata.tpl", {new_hostname = "nunu-main-${random_id.nunu_node_id[count.index].dec}"})
  root_block_device {
    volume_size = var.main_vol_size
  }
  tags = {
    Name = "nunu-main-${random_id.nunu_node_id[count.index].dec}"
  }

  provisioner "local-exec" {
    command = "printf '\n${self.public_ip}' >> aws_hosts"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "sed -i '/^[0-9]/d' aws_hosts"
  }
}


output "grafana_access" {
  value = { for i in aws_instance.nunu_main[*] : i.tags.Name => "${i.public_ip}:3000" }
}
