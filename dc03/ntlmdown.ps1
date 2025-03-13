# PowerShell script to enable LmCompatibilityLevel
[CmdletBinding()]
param()

# Define registry path and value
$regPath = "HKLM:\System\CurrentControlSet\Control\Lsa"
$regName = "LmCompatibilityLevel"
$regValue = 2

# Set the registry value
Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Type DWord -Force

Write-Output "LmCompatibilityLevel has been set to $regValue successfully."
