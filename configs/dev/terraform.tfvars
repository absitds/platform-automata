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
  # Configure Terragrunt to automatically store tfstate files in an azure bucket
  remote_state {
    backend = "azurerm"
    config {
      #itds-dops-wus-app
      storage_account_name  = "absitdsdevswustfsa"
      container_name        = "itds-dev-wus-tf-state"
      arm_client_id         = "4b812f96-1165-4b7f-bc5d-91de6c86e79b"
      arm_subscription_id   = "caa8382f-b56d-4198-acd4-e29f5221ae99"
      arm_client_secret     = "e0hTVYRLSGTracvHY++4Q7psa2NYL57viRUwissnBs4="
      arm_tenant_id         = "b7f604a0-00a9-4188-9248-42f3a5aac2e9"
      key                   = "${path_relative_to_include()}/terraform.tfstate"
      resource_group_name   = "itds-dev-wus-tf-rg"
    }
  }

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