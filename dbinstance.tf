

locals {
  csv_data_db = file("servers/${terraform.workspace}/db.csv")
  db_server   = csvdecode(local.csv_data_db)

  db_server_details = flatten([
    for db in local.db_server : {
      AMI                    = db.AMI
      Private_IP_Address     = db.Private_IP_Address
      Host_Name              = db.Host_Name
      Instance_Type          = db.Instance_Type
      Zone                   = db.Zone
      EBS_optimized          = lower(db.EBS_optimized)
      Root_volume_size       = db.Root_volume_size
      Root_Volume_type       = db.Root_Volume_type
      Root_Volumes_iops      = db.Root_Volumes_iops
      Root_Volume_Encryption = lower(db.Root_Volume_Encryption)
      Instance_control_id    = db.Instance_control_id
      Instance_Country       = db.Instance_Country
    }
  ])
}

resource "aws_instance" "dbinstance" {
  count                       = length(local.db_server_details)
  ami                         = local.db_server_details[count.index].AMI
  availability_zone           = local.availability_zone_names[local.db_server_details[count.index].Zone]
  ebs_optimized               = local.db_server_details[count.index].EBS_optimized
  instance_type               = local.db_server_details[count.index].Instance_Type
  key_name                    = aws_key_pair.dbkey.id
  subnet_id                   = local.db_subnets[local.db_server_details[count.index].Zone]
  vpc_security_group_ids      = local.db_security_group
  associate_public_ip_address = false
  private_ip                  = local.db_server_details[count.index].Private_IP_Address
  iam_instance_profile        = local.instanceprofileid
  user_data                   = file("ansibleuserdata.ps1")

  root_block_device {
    delete_on_termination = false
    encrypted             = local.db_server_details[count.index].Root_Volume_Encryption
    iops                  = local.db_server_details[count.index].Root_Volumes_iops
    volume_type           = local.db_server_details[count.index].Root_Volume_type
    volume_size           = local.db_server_details[count.index].Root_volume_size
    kms_key_id            = aws_kms_key.dbkmskey.arn

    tags = merge({
      Name                = "${var.app_name}-Root-db-${local.db_server_details[count.index].Host_Name}"
      BMC_Name            = "${var.app_name}-Root-${local.db_server_details[count.index].Host_Name}"
      Volume_Type         = "Root"
      ENVIRONMENT         = "${terraform.workspace}"
      Instance_control_id = "${local.db_server_details[count.index].Instance_control_id}"
      BMC_ServerRole      = "database"
    }, var.tags_all)
  }

  tags = merge({
    Name                = "${local.db_server_details[count.index].Host_Name}"
    BMC_Name            = "${local.db_server_details[count.index].Host_Name}"
    ENVIRONMENT         = "${terraform.workspace}"
    BMC_ServerRole      = "database"
    Instance_control_id = "${local.db_server_details[count.index].Instance_control_id}"
    Server_Country      = "${local.db_server_details[count.index].Instance_control_id}"
  }, var.tags_all)

}
