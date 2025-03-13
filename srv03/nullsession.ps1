[CmdletBinding()]
param()

# create directory
New-Item -ItemType Directory -Path "C:\shares\public" -Force | Out-Null

# create smb share
New-SmbShare -Name "public" `
             -Path "C:\shares\public" `
             -FullAccess "Administrators" `
             -ChangeAccess "Users" `
             -Description "Basic Read share for all domain users" `
             -FolderEnumerationMode AccessBased

# turn on the nullsession
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "RestrictNullSessAccess" -Value 0 -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "NullSessionShares" -Value "public" -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" -Name "AllowInsecureGuestAuth" -Value 1 -Force

# turn on guest account
net user guest /active:yes

#create directory all and smb share
New-Item -ItemType Directory -Path "C:\shares\all" -Force | Out-Null


New-SmbShare -Name "all" -Path "C:\shares\all" -FullAccess "Everyone" -FolderEnumerationMode AccessBased

Write-Output "SMB shares and anonymous access successfully configured."
