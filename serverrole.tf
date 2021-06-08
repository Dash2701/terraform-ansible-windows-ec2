data "aws_iam_policy_document" "secretpolicydocument" {
  statement {
    actions   = ["secretsmanager:GetSecretValue"]
    resources = ["arn:aws:secretsmanager:${var.aws_region}:${var.aws_account_id}:secret:admin_pwd-*"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "secretpolicy" {
  name        = "intansesecretpolicy"
  description = "Policy for Windows VMs"
  policy      = data.aws_iam_policy_document.secretpolicydocument.json
}


resource "aws_iam_role" "instancerole" {
  name = "InstanceRole"
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
}


resource "aws_iam_instance_profile" "instance_profile" {
  name = "serverinstancerole"
  role = aws_iam_role.instancerole.name
}



resource "aws_iam_policy_attachment" "instance_attach_Secret_manager" {
  name       = "instance-attachment"
  roles      = [aws_iam_role.instancerole.name]
  policy_arn = aws_iam_policy.secretpolicy.arn
}





