###############################################################################
#                               Documentation                                 #
###############################################################################
#                                                                             #
# Description                                                                 #
#     :                                                                       #
#                                                                             #
#                                                                             #
###############################################################################
#                           Terragrunt Configuration                          #
###############################################################################

terragrunt = {
  # Terragrunt will copy the Terraform configurations specified by the source
  # parameter, along with any files in the working directory, into a temporary
  # folder, and execute Terraform commands in that folder.
  terraform {
    source = "git@github.com:ATLAS-IS/ITDS-config.git//modules/itds-config-modules/src/main/tf/long-running/prob?ref=master"
  }

  # Include all settings from the root terraform.tfvars file
  include = {
    path = "${find_in_parent_folders()}"
  }
}

################################################################################
#                          Terraform Module Variables                          #
################################################################################

prob_vm_adm = "itdsdopswusadmin"

prob_nsg_ibnd_rl = [
  "22",
  "8081"
]

prob_nsg_ibnd_rl_src_pfx = [
  "*",
  "*"
]

prob_nsg_ibnd_rl_dst_pfx = [
  "*",
  "*"
]

prob_nsg_obnd_rl = [
]

prob_nsg_obnd_rl_src_pfx = [
]

prob_nsg_obnd_rl_dst_pfx = [
]

prob_lb_fnt_prt = [
  "22",
  "8081"
]

prob_lb_prb_prt = [
  "22",
  "8081"
]

prob_lb_bck_prt = [
  "22",
  "8081"
]

prob_vm_ip = [
  "172.21.40.132",
  "172.21.40.133",
  "172.21.40.134"
]

prob_vm = {
  vm_size = "Standard_F2"
  vm_img_publisher = "Canonical"
  vm_img_offer = "UbuntuServer"
  vm_img_sku = "18.04-LTS"
  vm_img_ver = "latest"
  vm_mg_dsk_ty = "Standard_LRS"
  vm_mg_dsk_sz = 1024
}

################################################################################
#                                     End                                      #
################################################################################