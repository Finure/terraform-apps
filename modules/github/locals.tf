locals {

  repos = {
    for f in fileset(path.module, "../../github-repos/*.yaml") :
    trimsuffix(basename(f), ".yaml") => yamldecode(file(f))
  }

  repo_branch_protections = flatten([
    for repo in local.repos : [
      for protection in try(repo.branch_protection, []) : {
        repository_name            = repo.name
        pattern                    = protection.pattern
        allows_deletions           = try(protection.allows_deletions, false)
        required_checks            = try(protection.required_checks, [])
        required_reviews           = try(protection.required_reviews, 0)
        dismiss_stale_reviews      = try(protection.dismiss_stale_reviews, false)
        require_code_owner_reviews = try(protection.require_code_owner_reviews, false)
        enforce_admins             = try(protection.enforce_admins, false)
        strict_checks              = try(protection.strict_checks, false)
      }
    ]
  ])

  repo_collaborators = flatten([
    for repo in local.repos : [
      for collaborator in try(repo.collaborators, []) : {
        user = collaborator.name
        repo = repo.name
        role = collaborator.role
      }
    ]
  ])

}

