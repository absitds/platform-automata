variable "env_prefix_hypon" {}

variable "env_prefix_underscore" {}

variable "env_location" {}

variable "vnet_name" {}

variable "vnet_rg_name" {}

variable "vnet_address_space" {}

variable "vnet_start_ip" {}

variable "vnet_end_ip" {}

variable "shrd_srv_xdemo_snet_addr_pfx" {}

variable "shrd_srv_xdemo_nsg_ibnd_rl" {
  type = "list"
}

variable "shrd_srv_xdemo_nsg_ibnd_rl_src_pfx" {
  type = "list"
}

variable "shrd_srv_xdemo_nsg_ibnd_rl_dst_pfx" {
  type = "list"
}

variable "shrd_srv_xdemo_nsg_obnd_rl" {
  type = "list"
}

variable "shrd_srv_xdemo_nsg_obnd_rl_src_pfx" {
  type = "list"
}

variable "shrd_srv_xdemo_nsg_obnd_rl_dst_pfx" {
  type = "list"
}

variable "shrd_srv_xdemo_lb_prb_prt" {
  type = "list"
}

variable "shrd_srv_xdemo_lb_bck_prt" {
  type = "list"
}

variable "shrd_srv_xdemo_lb_fnt_prt" {
  type = "list"
}

variable "shrd_srv_xdemo_vm_ip" {
  type = "list"
}

variable "shrd_srv_xdemo_vm_nm" {
  type = "list"
}

variable "shrd_srv_xdemo_vm" {
  type = "map"
}
variable "shrd_srv_xdemo_vm_adm"{}

variable "shrd_srv_xdemo_vm_pswd" {}

variable "env_disable_lk" {}