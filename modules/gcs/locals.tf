locals {
  apps_config = {
    for file in fileset("${path.module}/../../applications", "*.yaml") :
    trimsuffix(basename(file), ".yaml") => try(yamldecode(file("${path.module}/../../applications/${file}"))["buckets"], {})
  }

  buckets = flatten([
    for app_name, buckets in local.apps_config :
    [
      for bucket in try(buckets, []) :
      [merge(bucket, { app = app_name })]
    ]
  ])

}
