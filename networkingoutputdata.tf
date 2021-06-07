data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket         = "tf-bucket-t3-pb-com"
    key            = "env:/${terraform.workspace}/networks/terraform.tfstate"
    dynamodb_table = "tf-t3-state-locking"
    region         = "us-east-1"
  }
}

locals {
  availability_zone_names = data.terraform_remote_state.networking.outputs.az_details
  db_subnets              = data.terraform_remote_state.networking.outputs.very_private_subnet_db_ids
  db_security_group       = [data.terraform_remote_state.networking.outputs.db_security_group_id, data.terraform_remote_state.networking.outputs.baseline_infra_security_group, data.terraform_remote_state.networking.outputs.baseline_admin_security_group]
}
