[CmdletBinding()]
param()

# Administrators
net localgroup "Administrators" "north\jeor.mormont" /add

# Remote Desktop Users
net localgroup "Remote Desktop Users" "north\Night Watch" /add
net localgroup "Remote Desktop Users" "north\Mormont" /add
net localgroup "Remote Desktop Users" "north\Stark" /add


Write-Output "Users and groups successfully added to local groups."
