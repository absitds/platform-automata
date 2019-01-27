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
    #source = "git@github.com:ATLAS-IS/ITDS-config.git//modules/itds-config-modules/src/main/tf/long-running/shared-services/logx?ref=master"
    source = "/Users/Shingate/Documents/Albertson/Github/ITDS-config/modules/itds-config-modules/src/main/tf/long-running/shared-services/logx"
  }

  # Include all settings from the root terraform.tfvars file
  include = {
    path = "${find_in_parent_folders()}"
  }
}

################################################################################
#                          Terraform Module Variables                          #
################################################################################

shrd_srv_lgx_rtn_dys = "100"

shrd_srv_lgx_sku = "Standalone"

################################################################################
#                                     End                                      #
################################################################################