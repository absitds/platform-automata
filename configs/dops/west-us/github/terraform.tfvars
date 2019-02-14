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
    source = "/Users/Shingate/Documents/Albertson/BitBucket/Workspace/platform-automata/modules/github"
  }

  # Include all settings from the root terraform.tfvars file
  include = {
    path = "${find_in_parent_folders()}"
  }
}

################################################################################
#                          Terraform Module Variables                          #
################################################################################

itds_github_org = "ITDS"

itds_github_repo_keys_fldr = "/Users/Shingate/Documents/Albertson/BitBucket/Workspace/platform-automata/configs/dops/west-us/github/.terragrunt-cache/files/.ssh"

itds_github_tkn = "69501ff30de07722b9eff8fae413a1f2e71d220c"

itds_jnkns_wb_hk_url = "http://168.61.22.128:8080/github-webhook/"

itds_github_adm_team = "itds-admins"

itds_github_mbr_team = "itds-members"

itds_github_org_mbrs = [
  "asriv11",
  "jbajp00",
  "vkush01",
  "rvada03",
  "using01"
]

itds_github_repo_nms = [
  "hadoop-adls",
  "platform-docker-xsftp",
  "platform-automata",
  "platform-jenkins",
  "platform-docker-isftp",
  "platform-docker-terraform",
  "platform-docker-hue",
  "platform-docker-parent",
  "platform-docker-airflow",
  "platform-docker-fuse",
  "platform-airflow",
  "platform-fuse",
  "platform-artifactory",
  "platform-hue",
  "project-parent",
  "project-common",
  "platform-demo",
  "merch-perf-exec",
  "msft-shpnt-upld"
]

itds_github_org_adms = [
  "jsin108",
  "rchat10"
]

################################################################################
#                                     End                                      #
################################################################################