variable "default_vpc_id" {
  default = ""
}

variable "my_public_ip_address" {
  default = ""
}

variable "create_ssm_endpoints" {
  description = "If set to true, it will create vm"
  type   = bool
  default = true

}