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
    source = "/Users/Shingate/Documents/Albertson/BitBucket/Workspace/platform-automata/modules/cloudera-hue"
  }

  # Include all settings from the root terraform.tfvars file
  include = {
    path = "${find_in_parent_folders()}"
  }
}

################################################################################
#                          Terraform Module Variables                          #
################################################################################

shrd_srv_hue_vm_adm = "itdsdopswusadmin"

shrd_srv_hue_ghub_url = "https://github.com/absitds/platform-hue.git"

shrd_srv_hue_nsg_ibnd_rl = [
  "22",
  "8888"
]

shrd_srv_hue_nsg_ibnd_rl_src_pfx = [
  "*",
  "*"
]

shrd_srv_hue_nsg_ibnd_rl_dst_pfx = [
  "*",
  "*"
]

shrd_srv_hue_nsg_obnd_rl = [
]

shrd_srv_hue_nsg_obnd_rl_src_pfx = [
]

shrd_srv_hue_nsg_obnd_rl_dst_pfx = [
]

shrd_srv_hue_lb_fnt_prt = [
  "22",
  "8888"
]

shrd_srv_hue_lb_prb_prt = [
  "22",
  "8888"
]

shrd_srv_hue_lb_bck_prt = [
  "22",
  "8888"
]

shrd_srv_hue_vm_ip = [
  "172.21.32.36"
]

shrd_srv_hue_vm = {
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