
variable "region" {
  description = "The region to deploy to"
  type = string
  default = "asia-southeast1"
}

variable "zone" {
  description = "The zone to deploy to"
  type = string
  default = "asia-southeast1-a"
}

variable "subnet_id" {
  description = "Subnet ID that the manager used"
  type = string
}

variable "instance_name" {
  description = "VM Insance name"
  type = string
}

variable "machine_type" {
  description = "Machine type GCE ex:e2-medium"
  type = string
}

variable "disk_size" {
  description = "Boot disk size in GB"
  type = number
}