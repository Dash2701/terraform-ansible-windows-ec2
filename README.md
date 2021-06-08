# terraform-ansible-windows-ec2

This is an example regarding spinning up with terraform and managing it with Ansible.

Follow the below steps for this to work.

Requirement:
1. An AWS account
2. Terraform CLI
3. Ansible CLI

AWS Steps: 

1. Go to AWS and navigate to Secrets Manager. And Go to the selected region you want.

2. Create an new Secret and select "Other type of secret" 

3. In Key field type in "password" and with value you can put whatever password you want to keep.

4. Name the secret as : "admin_pwd"

5. Configure the default profile or else you can change in the 

Now for Terraform:

1. Clone the Repo

`git clone https://github.com/Dash2701/terraform-ansible-windows-ec2.git`

2. Navigate to the folder

`cd terraform-ansible-windows-ec2`


3. Replace your account Number and region in terraform.tfvars and then Initialize the terraform 

`terraform init`

4. Run Terraform Apply and after plan check input yes

`terraform apply`

or for auto approve

`terraform apply --auto-approve`

5. Now in you use ansible basic authentication with username as Administrator and password with the one you have set in secrets manager