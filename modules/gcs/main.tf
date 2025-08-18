terraform {
  backend "gcs" {
    prefix       = "gcs"
    use_lockfile = true
  }
}

provider "google" {
  default_labels = {
    project     = "finure"
    provisioned = "terraform"
  }
}

resource "google_storage_bucket" "buckets" {
  for_each = { for bucket in local.buckets : "${bucket.app}:${bucket.name}" => bucket }

  name                        = each.value.name
  location                    = each.value.location
  storage_class               = "STANDARD"
  force_destroy               = true
  uniform_bucket_level_access = each.value.uniform_bucket_level_access
  versioning {
    enabled = each.value.versioning_enabled
  }
  dynamic "lifecycle_rule" {
    for_each = try(each.value.lifecycle_rules, [])
    content {
      dynamic "condition" {
        for_each = try(lifecycle_rule.value.condition, [])
        content {
          age                        = condition.key == "age" ? condition.value : null
          created_before             = condition.key == "created_before" ? condition.value : null
          with_state                 = condition.key == "with_state" ? condition.value : null
          num_newer_versions         = condition.key == "num_newer_versions" ? condition.value : null
          custom_time_before         = condition.key == "custom_time_before" ? condition.value : null
          days_since_custom_time     = condition.key == "days_since_custom_time" ? condition.value : null
          days_since_noncurrent_time = condition.key == "days_since_noncurrent_time" ? condition.value : null
          noncurrent_time_before     = condition.key == "noncurrent_time_before" ? condition.value : null
        }
      }

      dynamic "action" {
        for_each = try(lifecycle_rule.value.action, [])
        content {
          type = action.value
        }
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }
  soft_delete_policy {
    retention_duration_seconds = 0
  }
  project = var.project_id
}
