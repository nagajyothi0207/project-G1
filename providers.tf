terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.9.0"
    }
  }
}

data "aws_region" "current" {}

provider "aws" {
  region = "ap-southeast-1"

  default_tags {
    tags = {
      Environment  = "Test"
      Project_name = "Project-Govtech"
    }
  }
}
