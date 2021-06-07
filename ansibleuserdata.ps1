<powershell>
Import-Module AWSPowerShell
$SecretAD = "windows_admin_pwd"
$SecretObj = (Get-SECSecretValue -SecretId $SecretAD)
$Secret = ($SecretObj.SecretString  | ConvertFrom-Json)
$password   = $Secret.Password | ConvertTo-SecureString -asPlainText -Force

$UserAccount = Get-LocalUser -Name "administrator"
$UserAccount | Set-LocalUser -Password $Password

$userdetails = "automation_user"
$SecretObj2 = (Get-SECSecretValue -SecretId $userdetails)
$Secret2 = ($SecretObj2.SecretString  | ConvertFrom-Json)
$password2   = $Secret2.automation_user_pwd | ConvertTo-SecureString -asPlainText -Force


New-LocalUser -Name "casauto" -Description "Account for Automation Purpose" -Password  $password2 -AccountNeverExpires -UserMayNotChangePassword -PasswordNeverExpires

Add-LocalGroupMember -Group "Administrators" -Member "casauto"


Invoke-Expression ((New-Object System.Net.Webclient).DownloadString('https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1'))
</powershell>


