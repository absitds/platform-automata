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
    #source = "git@github.com:ATLAS-IS/ITDS-config.git//modules/itds-config-modules/src/main/tf/long-running/shared-services/vault?ref=master"
    source = "/Users/Shingate/Documents/Albertson/BitBucket/Workspace/platform-automata/modules/azure-vault"
  }

  # Include all settings from the root terraform.tfvars file
  include = {
    path = "${find_in_parent_folders()}"
  }
}

################################################################################
#                          Terraform Module Variables                          #
################################################################################

env_disable_lk = 1

shrd_srv_vlt_obj_id = "7f96ab9e-6c60-40da-89de-7cf7b8937638"

shrd_srv_vlt_app_id = "4b812f96-1165-4b7f-bc5d-91de6c86e79b"


################################################################################
#                                     End                                      #
################################################################################