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

hdi_sprk_clus_nm_unq_pfx="sprk01"
hdi_sprk_clus_nm = "sprk01-itds-dev-wus-hdi"
hdi_sprk_clus_mid = "sprk01-itds-dev-wus-mid"
hdi_sprk_adm_nm = "itdsdevwusadmin"
hdi_sprk_adm_psswd = "ztrdsed_vwE_53_243"
hdi_sprk_clus_tir = "standard"
hdi_sprk_htp_usr = "itdsdevwusadminw"
hdi_sprk_htp_psswd = "ztrdsed_vwE_53_243"
hdi_sprk_ssh_usr = "itdsdevwusadmin"
hdi_sprk_ssh_psswd = "ztrdsed_vwE_53_243"
hdi_sprk_strj_acc = "absitdsdevwussprkhdi001"
hdi_sprk_strj_acc_def_cnt = "sp001-itds-wus-hdi"
hdi_sprk_ver = "2.6"
hdi_sprk_vnet_nm = "Abs-ITDS-Dev"
hdi_sprk_wrk_nd_dd_sz = "1024"
hdi_sprk_wrk_nd_dd_sa_ty = "standard_lrs"
hdi_sprk_wrk_nd_dd_cnt = "2"
hdi_sprk_eg_nd_sz = "Standard_D4s_v3"
hdi_sprk_hd_nd_sz = "Standard_D4s_v3"
hdi_sprk_wrk_nd_sz = "4"
hdi_sprk_zk_nd_sz = "Standard_D4s_v3"
hdi_sprk_snet_addr_pfx = "172.21.32.192/26"

################################################################################
#                                     End                                      #
################################################################################