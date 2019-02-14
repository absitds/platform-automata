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
    source = "/Users/Shingate/Documents/Albertson/BitBucket/Workspace/platform-automata/modules/azure-hdinsight-kafka"
  }

  # Include all settings from the root terraform.tfvars file
  include = {
    path = "${find_in_parent_folders()}"
  }
}

################################################################################
#                          Terraform Module Variables                          #
################################################################################


hdi_kfka_clus_nm_unq_pfx="kfka01"
hdi_kfka_clus_nm = "kfka01-itds-dev-wus-hdi"
hdi_kfka_clus_mid = "kfka01-itds-dev-wus-mid"
hdi_kfka_adm_nm = "itdsdevwusadmin"
hdi_kfka_adm_psswd = "ztrdsed_vwE_53_243"
hdi_kfka_clus_tir = "standard"
hdi_kfka_htp_usr = "itdsdevwusadminhttp"
hdi_kfka_htp_psswd = "ztrdsed_vwE_53_243"
hdi_kfka_ssh_usr = "itdsdevwusadmin"
hdi_kfka_ssh_psswd = "ztrdsed_vwE_53_243"
hdi_kfka_strj_acc = "absitdsdevwuskfkahdi001"
hdi_kfka_strj_acc_def_cnt = "sp001-itds-wus-hdi"
hdi_kfka_ver = "2.6"
hdi_kfka_vnet_nm = "Abs-ITDS-Dev"
hdi_kfka_wrk_nd_dd_sz = "1024"
hdi_kfka_wrk_nd_dd_sa_ty = "standard_lrs"
hdi_kfka_wrk_nd_dd_cnt = "2"
hdi_kfka_eg_nd_sz = "Standard_D4s_v3"
hdi_kfka_hd_nd_sz = "Standard_D4s_v3"
hdi_kfka_wrk_nd_sz = "4"
hdi_kfka_zk_nd_sz = "Standard_D4s_v3"
hdi_kfka_snet_addr_pfx = "172.21.32.96/27"

################################################################################
#                                     End                                      #
################################################################################