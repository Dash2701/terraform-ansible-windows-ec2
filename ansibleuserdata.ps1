<powershell>
Import-Module AWSPowerShell
$SecretAD = "admin_pwd"
$SecretObj = (Get-SECSecretValue -SecretId $SecretAD)
$Secret = ($SecretObj.SecretString  | ConvertFrom-Json)
$password   = $Secret.Password | ConvertTo-SecureString -asPlainText -Force

$UserAccount = Get-LocalUser -Name "administrator"
$UserAccount | Set-LocalUser -Password $Password

Invoke-Expression ((New-Object System.Net.Webclient).DownloadString('https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1'))
</powershell>


