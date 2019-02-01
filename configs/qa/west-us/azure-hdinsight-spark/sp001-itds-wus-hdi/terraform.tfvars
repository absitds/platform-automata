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
    source = "/Users/Shingate/Documents/Albertson/BitBucket/Workspace/platform-automata/modules/azure-hdinsight-spark"
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

hdi_sprk_edg_nd_sz = "Standard_D2"

hdi_sprk_hd_nd_sz = "Standard_D4"

hdi_sprk_htp_usr = "itdsdevwusadminw"

hdi_sprk_wk_nd_cnt = "3"

hdi_sprk_ssh_pub_ky = ""

hdi_sprk_ssh_user = "itdsdevwusadmin"

hdi_version = "3.6"

hdi_sprk_wrk_nd_dsk_sz = "1024"

hdi_sprk_wrk_nd_dsks_cnt = "1"

hdi_sprk_wrk_nd_sz = "Standard_D4"

hdi_sprk_zk_nd_sz = "Standard_D2"




################################################################################
#                                     End                                      #
################################################################################