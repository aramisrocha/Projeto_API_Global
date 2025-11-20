variable "primary_region" {
  default = "us-east-1"
}

variable "secondary_region" {
  default = "sa-east-1"
}

provider "aws" {
  region = var.primary_region
  alias  = "primary"
}

provider "aws" {
  region = var.secondary_region
  alias  = "secondary"
}