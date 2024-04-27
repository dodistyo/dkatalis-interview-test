variable "region" {
  description = "The region to deploy to"
  type = string
  default = "asia-southeast1"
}

variable "vpc_name" {
  description = "VPC name"
  type = string
  default = "dkatalis-subnet"
}

variable "subnet_name" {
  description = "VPC name"
  type = string
  default = "dkatalis-subnet"
}

variable "cidr_range" {
  description = "cidr range"
  type = string
  default = "10.0.1.0/24"
}

variable "network_environment" {
  description = "The network environment"
  type = string
}