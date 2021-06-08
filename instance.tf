resource "aws_instance" "my_first_resource" {
  ami                  = "ami-034a4d85b5ef5e779"
  instance_type        = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.instancesg.id]
  iam_instance_profile = aws_iam_instance_profile.instance_profile.id
  user_data            = file("ansibleuserdata.ps1")

}