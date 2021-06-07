variable "aws_account_id" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "aws_role_region" {
  type = string
}

variable "company_name" {
  type    = string
  default = "pb"
}


variable "aws_profile" {
  type    = string
  default = "default"
}

variable "env" {
  type = string
}



variable "tags_all" {
  type = map
  default = {
    "BUSINESS_UNIT"   = "Tier3",
    "TERRAFORM"       = "True"
    "TERRAFORM_STATE" = "APPLICATIONS"
  }
}