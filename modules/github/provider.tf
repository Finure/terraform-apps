terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.6.0"
    }
  }
  backend "gcs" {
    prefix = "github"
    bucket = "finure-apps-tfstate"
  }
}

provider "github" {
  owner = "Finure"
}