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
    source = "git@github.com:ATLAS-IS/ITDS-config.git//modules/itds-config-modules/src/main/tf/long-running/shared-services/redis?ref=master"
  }

  # Include all settings from the root terraform.tfvars file
  include = {
    path = "${find_in_parent_folders()}"
  }
}

################################################################################
#                          Terraform Module Variables                          #
################################################################################

shrd_srv_rdis = {
  rdis_cpcty = 3
  rdis_fmly = "C"
  rdis_sku = "Basic"
  rdis_mem_plcy = "volatile-lru"
}

################################################################################
#                                     End                                      #
################################################################################