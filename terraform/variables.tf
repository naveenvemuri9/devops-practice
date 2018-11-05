variable region {
  default = "us-east-1"
}

variable "cluster_name" {
  type    = "string"
  default = ""
}
variable node_type {
  default = "m4.large"
}

variable "cidr_block" {
  default = "10.0.0.0/16"
}
