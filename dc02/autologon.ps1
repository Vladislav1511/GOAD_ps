# autologon with credman robb.stark
$username = "north\robb.stark"
$password = "sexywolfy"

Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoAdminLogon" -Value "1" -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultUsername" -Value $username -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultPassword" -Value $password -Force

cmdkey /generic:"north\robb.stark" /user:"north\robb.stark" /pass:"sexywolfy"

Write-Output "Autologon and credentials successfully configured."