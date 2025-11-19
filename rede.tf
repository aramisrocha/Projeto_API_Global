terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

module "network_devops_01" {
  source = "../Modules/networking"

  name                  = "Projeto_network"
  vpc_cidr              = "10.0.0.0/16"
  enable_dns_hostnames  = true
  subnets = [
    { name = "SubnetA", cidr = "10.0.1.0/24", az = "us-east-2a" },
    { name = "SubnetB", cidr = "10.0.2.0/24", az = "us-east-2b" },
  ]
}


