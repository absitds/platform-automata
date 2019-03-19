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

  # Configure root level variables that all resources can inherit
  terraform {
    extra_arguments "common_vars" {
      commands = ["${get_terraform_commands_that_need_vars()}"]
      optional_var_files = [
          "${get_tfvars_dir()}/${find_in_parent_folders("common.tfvars")}"
      ]
    }
  }
}


################################################################################
#                                     End                                      #
################################################################################