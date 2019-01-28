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
    source = "git@github.com:ATLAS-IS/ITDS-config.git//modules/itds-config-modules/src/main/tf/long-running/hdinsight/kafka?ref=master"
  }

  # Include all settings from the root terraform.tfvars file
  include = {
    path = "${find_in_parent_folders()}"
  }
}

################################################################################
#                          Terraform Module Variables                          #
################################################################################


hdi_clus_tir = "standard"

hdi_kfka_edg_nd_sz = "Standard_D2"

hdi_kfka_hd_nd_sz = "Standard_D4"

hdi_kfka_htp_usr = "itdsdevwusadminw"

hdi_kfka_wk_nd_cnt = "3"

hdi_kfka_ssh_pub_ky = ""

hdi_kfka_ssh_user = "itdsdevwusadmin"

hdi_version = "3.6"

hdi_kfka_wrk_nd_dsk_sz = "1024"

hdi_kfka_wrk_nd_dsks_cnt = "1"

hdi_kfka_wrk_nd_sz = "Standard_D4"

hdi_kfka_zk_nd_sz = "Standard_D2"

################################################################################
#                                     End                                      #
################################################################################