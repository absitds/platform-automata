terraform {
  backend "azurerm" {}
}

provider "github" {
  token = "${var.itds_github_tkn}"
  organization = "${var.itds_github_org}"
  base_url = "https://platformpocvmrgdiag-ghe.centralus.cloudapp.azure.com/api/v3/"
  insecure = "true"
}

resource "github_membership" "itds_github_org_mbrs" {
  username = "${var.itds_github_org_mbrs[count.index]}"
  role     = "member"
  count = "${length(var.itds_github_org_mbrs)}"
}


resource "github_membership" "itds_github_org_adms" {
  username = "${var.itds_github_org_adms[count.index]}"
  role     = "admin"
  count = "${length(var.itds_github_org_adms)}"
}

resource "github_repository" "itds_github_repo" {
  name = "${var.itds_github_repo_nms[count.index]}"
  private = true
  has_issues = true
  has_wiki = true
  has_projects = true
  has_downloads = true
  auto_init = false
  count = "${length(var.itds_github_repo_nms)}"
}

resource "github_team" "itds_github_org_adm_tm" {
  name = "${var.itds_github_adm_team}"
  description = "${var.itds_github_org} Admin Team"
  privacy = "closed"
}

resource "github_team" "itds_github_repo_mbr_tm" {
  name = "${var.itds_github_mbr_team}"
  description = "${var.itds_github_org} Members Team"
  privacy = "closed"
}

resource "github_team_membership" "itds_github_org_adm_mshp" {
  team_id  = "${github_team.itds_github_org_adm_tm.id}"
  username = "${var.itds_github_org_adms[count.index]}"
  role     = "maintainer"
  count = "${length(var.itds_github_org_adms)}"
}

resource "github_team_membership" "itds_github_org_mbr_mshp" {
  team_id  = "${github_team.itds_github_repo_mbr_tm.id}"
  username = "${var.itds_github_org_mbrs[count.index]}"
  role     = "member"
  count = "${length(var.itds_github_org_mbrs)}"
}

resource "github_team_repository" "itds_github_repo_adm_repo" {
  team_id = "${github_team.itds_github_org_adm_tm.id}"
  repository = "${element(github_repository.itds_github_repo.*.name, count.index)}"
  permission = "admin"
  count = "${length(var.itds_github_repo_nms)}"
}

resource "github_team_repository" "itds_github_repo_mbr_repo" {
  team_id = "${github_team.itds_github_repo_mbr_tm.id}"
  repository = "${element(github_repository.itds_github_repo.*.name, count.index)}"
  permission = "push"
  count = "${length(var.itds_github_repo_nms)}"
}

/*
resource "github_repository_deploy_key" "itds_github_repo_dpl_ky" {
  title = "${element(github_repository.itds_github_repo.*.name, count.index)}-dply-ky"
  repository = "${element(github_repository.itds_github_repo.*.name, count.index)}"
  key = "${file("${var.itds_github_repo_keys_fldr}/id_rsa.pub")}"
  read_only = "true"
  count = "${length(var.itds_github_repo_nms)}"
}
*/

resource "github_organization_webhook" "itds_github_org_wb_hk" {
  name = "web"
  configuration {
    url          = "${var.itds_jnkns_wb_hk_url}"
    content_type = "application/json"
    insecure_ssl = false
  }
  active = true
  events = ["pull_request", "push"]
}

/*
resource "github_branch_protection" "itds_github_repo_brnch_prtct" {
  repository = "${element(github_repository.itds_github_repo.*.name, count.index)}"
  branch = "master"
  enforce_admins = true
  required_status_checks {
    strict = false
    contexts = ["ci/jenkins"]
  }
  required_pull_request_reviews {
    dismiss_stale_reviews = true
    dismissal_teams = ["${github_team.itds_github_org_adm_tm.slug}"]
  }
  restrictions {
    teams = ["${github_team.itds_github_org_adm_tm.slug}"]
  }
}
*/






