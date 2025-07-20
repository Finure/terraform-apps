terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.6.0"
    }
  }
  backend "gcs" {
    prefix       = "github"
    use_lockfile = true
    bucket       = "finure-tfstate"
  }
}

provider "github" {
  owner = "Finure"
}