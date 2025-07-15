locals {
  apps_config = {
    for filename in fileset("${path.module}/../../applications", "*.yaml") :
    trimsuffix(basename(filename), ".yaml") => try(yamldecode(file("${path.module}/../../applications/${filename}"))["iam"], {})
    }

  service_accounts = flatten([
    for app_name, app in local.apps_config :
    [
      for sa in try(app.service_accounts, []) : merge(sa, { app = app_name })
    ]
  ])

  storage_buckets = flatten([
    for app_name, app in local.apps_config :
    [
      for bucket in try(app.storage_buckets, []) :
      merge(
        bucket,
        {
          app                = try(bucket.member, app_name)
          service_account_id = length(regexall(".*@.*", try(bucket.service_account_id, ""))) > 0 ? try(bucket.service_account_id, "") : "${try(bucket.service_account_id, "")}@${var.project_id}.iam.gserviceaccount.com"
        }
      )
    ]
  ])

}

