terraform {
  required_version = "~> 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "mivancic-terraform"
    key    = "prod/terraform.tfstate"
    region = "us-east-2"
  }
}

provider "aws" {
  alias  = "first_alternative"
  region = "us-east-2"
}

provider "aws" {
  alias  = "acm_provider"
  region = "us-east-1"
}
