data "aws_iam_policy_document" "secretpolicy" {
  statement {
    actions   = ["secretsmanager:GetSecretValue"]
    resources = ["arn:aws:secretsmanager:${var.aws_role_region}:${var.aws_account_id}:secret:windows_admin_pwd-*", "arn:aws:secretsmanager:${var.aws_role_region}:${var.aws_account_id}:secret:automation_user-*"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "serverrole" {
  name        = "${var.company_name}-t3-ServerRole-${var.env}"
  description = "Role for Tier3 Windows VMs"
  policy      = data.aws_iam_policy_document.secretpolicy.json

  tags = merge({
    Name     = "${var.company_name}-t3-ServerRole-${var.env}"
    BMC_Name = "${var.company_name}-t3-ServerRole-${var.env}"
  }, var.tags_all)
}


data "aws_iam_policy" "SSMFullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

data "aws_iam_policy" "ec2ssm" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

data "aws_iam_policy" "s3accessforinstance" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role" "instancerole" {
  name = "T3InstanceRole"
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )

  tags = merge(
    {
      "Name" = "T3InstanceRole"
  }, var.tags_all)

}


resource "aws_iam_instance_profile" "instance_profile" {
  name = "t3serverinstancerole"
  role = aws_iam_role.instancerole.name
}



resource "aws_iam_policy_attachment" "instance_attach_Secret_manager" {
  name       = "instance-attachment"
  roles      = [aws_iam_role.instancerole.name]
  policy_arn = aws_iam_policy.serverrole.arn
}




resource "aws_iam_policy_attachment" "instance_ssm_attachment" {
  name       = "instance_ssm_attachment"
  roles      = [aws_iam_role.instancerole.name]
  policy_arn = data.aws_iam_policy.SSMFullAccess.arn
}


resource "aws_iam_policy_attachment" "ec2_instance_ssm_attachment" {
  name       = "ec2_instance_ssm_attachment"
  roles      = [aws_iam_role.instancerole.name]
  policy_arn = data.aws_iam_policy.ec2ssm.arn
}


resource "aws_iam_policy_attachment" "ec2_instance_s3_attachement" {
  name       = "ec2_instance_ssm_attachment"
  roles      = [aws_iam_role.instancerole.name]
  policy_arn = data.aws_iam_policy.s3accessforinstance.arn
}



