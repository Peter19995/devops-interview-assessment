variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  default = "10.0.2.0/24"
}

variable "availability_zone" {
  default = "us-east-1a"
}

variable "db_password" {}
variable "db_username" {
  default = "admin"
}


variable "availability_zone2" {
  description = "Second availability zone for redundancy"
  type        = string
  default     = "us-east-1b"
}

variable "db_instance_class" {
  description = "RDS instance type"
  type        = string
  default     = "db.t3.micro"
}

variable "private_subnet2_cidr" {
  description = "CIDR block for the second private subnet"
  type        = string
  default     = "10.0.3.0/24"
}