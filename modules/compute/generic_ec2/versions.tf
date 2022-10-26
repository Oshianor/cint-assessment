terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.63"
    }
    null = {
      source = "hashicorp/null"
    }
    random = {
      source = "hashicorp/random"
    }
    template = {
      source = "hashicorp/template"
    }
  }
}
