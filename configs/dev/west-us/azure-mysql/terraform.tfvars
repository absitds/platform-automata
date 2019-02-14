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
    source = "/Users/Shingate/Documents/Albertson/BitBucket/Workspace/platform-automata/modules/azure-mysql"
  }

  # Include all settings from the root terraform.tfvars file
  include = {
    path = "${find_in_parent_folders()}"
  }
}

################################################################################
#                          Terraform Module Variables                          #
################################################################################


shsrv_srv_msql_adm_usr = "itdsdevwusadmin"

env_disable_lk = 1

#TODO - Dont forget to follow the instructions
#https://docs.azuredatabricks.net/user-guide/advanced/external-hive-metastore.html

shrd_srv_msql = {
  msql_version = "5.7"
  msql_sku_name = "GP_Gen5_8"
  msql_sku_capacity = "8"
  msql_sku_tier = "GeneralPurpose"
  msql_sku_fam = "Gen5"
  msql_strg_mb = "2048000"
  msql_bkup_ret_dys = "15"
  msql_geo_red_bkup = "Enabled"
}


################################################################################
#                                     End                                      #
################################################################################