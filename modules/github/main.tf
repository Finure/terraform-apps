resource "github_repository" "repos" {
  for_each               = local.repos
  name                   = each.value.name
  description            = trimspace(join(" ", split("\n", each.value.description)))
  visibility             = try(each.value.visibility, "private")
  homepage_url           = try(each.value.homepage_url, null)
  has_issues             = try(each.value.has_issues, false)
  has_projects           = try(each.value.has_projects, false)
  has_wiki               = try(each.value.has_wiki, false)
  has_downloads          = try(each.value.has_downloads, false)
  vulnerability_alerts   = try(each.value.vulnerability_alerts, true)
  delete_branch_on_merge = try(each.value.delete_branch_on_merge, true)
  auto_init              = try(each.value.auto_init, true)
  archived               = try(each.value.archived, false)
  allow_merge_commit     = try(each.value.allow_merge_commit, true)
  allow_rebase_merge     = try(each.value.allow_rebase_merge, true)
  allow_squash_merge     = try(each.value.allow_squash_merge, true)
}

resource "github_branch_default" "default" {
  for_each = {
    for key, value in local.repos : key => value
    if try(value.default_branch, "") != "" && try(value.default_branch, "") != "main"
  }
  repository = local.repos[each.key].name
  branch     = each.value.default_branch
}

// Use this after repo is public
resource "github_branch_protection" "branch_protections" {
  for_each = {
    for protection in local.repo_branch_protections :
    "${protection.repository_name}:${protection.pattern}" => protection
  }
  repository_id  = github_repository.repos[each.value.repository_name].node_id
  pattern        = each.value.pattern
  enforce_admins = each.value.enforce_admins

  dynamic "required_status_checks" {
    for_each = each.value.strict_checks == true || length(each.value.required_checks) > 0 ? [1] : []

    content {
      contexts = each.value.required_checks
      strict   = each.value.strict_checks
    }
  }
}
