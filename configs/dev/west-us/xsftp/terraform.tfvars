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
    source = "/Users/Shingate/Documents/Albertson/BitBucket/Workspace/platform-automata/modules/xsftp"
  }

  # Include all settings from the root terraform.tfvars file
  include = {
    path = "${find_in_parent_folders()}"
  }
}

################################################################################
#                          Terraform Module Variables                          #
################################################################################

shrd_srv_xsftp_vm_adm = "itdsdevwusadmin"

shrd_srv_xsftp_nsg_ibnd_rl = [
  "22",
  "2222",
]

shrd_srv_xsftp_nsg_ibnd_rl_src_pfx = [
  "*",
  "*"
]

shrd_srv_xsftp_nsg_ibnd_rl_dst_pfx = [
  "*",
  "*"
]

shrd_srv_xsftp_nsg_obnd_rl = [
]

shrd_srv_xsftp_nsg_obnd_rl_src_pfx = [
]

shrd_srv_xsftp_nsg_obnd_rl_dst_pfx = [
]

shrd_srv_xsftp_lb_fnt_prt = [
  "22",
  "2222"
]

shrd_srv_xsftp_lb_prb_prt = [
  "22",
  "2222"
]

shrd_srv_xsftp_lb_bck_prt = [
  "22",
  "2222"
]

shrd_srv_xsftp_vm_ip = [
  "172.21.32.52"
]

shrd_srv_xsftp_vm_nm = [
  "zduwitdsxftp001"
]

shrd_srv_xsftp_vm_hst_nm = [
  "dgv0109ca"
]

itds_shrd_srv_acr_admn = "absitdsdopswusacr001"

itds_shrd_srv_acr_admn_pswd = "FuYVABYJe/4Sl4CVp6RWszwoKlDbQysw"

itds_shrd_srv_acr_srvr = "absitdsdopswusacr001.azurecr.io"

itds_shrd_srv_acr_repo = "com.albertsons.itds/docker-xsftp"

itds_shrd_srv_acr_repo_tg = "1.0.0-SNAPSHOT"

shrd_srv_xsftp_vm = {
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