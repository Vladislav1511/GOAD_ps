# PowerShell script to enable RunAsPPL
[CmdletBinding()]
param()

# Define registry path and value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$regName = "RunAsPPL"
$regValue = 1

# Set the registry value
Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Type DWord -Force

Write-Output "RunAsPPL has been enabled successfully."