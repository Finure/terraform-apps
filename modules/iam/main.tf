provider "google" {
  default_labels = {
    project     = "finure"
    provisioned = "terraform"
  }
}

resource "google_service_account" "service-account1" {
  for_each = { for service_account in local.service_accounts : "${service_account.app}:${service_account.account_id}" => service_account }

  account_id   = each.value.account_id
  display_name = each.value.display_name
  project      = var.project_id
}
