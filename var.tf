variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "access_ip" {
  type    = string
  default = "0.0.0.0/0"
} # 모든 ip 허용

variable "main_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "main_vol_size" {
  type    = number
  default = 16
}

variable "main_instance_count" {
  type    = number
  default = 1 # 생성할 인스턴스 개수 
}

variable "key_name" {
  type = string
}

variable "public_key_path" {
  type = string
}
