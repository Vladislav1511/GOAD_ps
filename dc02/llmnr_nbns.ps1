#  NBT-NS

$RegKey = "HKLM:\SYSTEM\CurrentControlSet\services\NetBT\Parameters\Interfaces"

# check all interfaces
Get-ChildItem $RegKey | ForEach-Object {
    $Path = "$RegKey\$($_.PSChildName)"
    Set-ItemProperty -Path $Path -Name "NetbiosOptions" -Value 0 -Verbose
}

Write-Host "NBT-NS protocol enabled on all network interfaces." -ForegroundColor Green



#  LLMNR

$RegPath = "HKLM:\Software\policies\Microsoft\Windows NT\DNSClient"
$RegName = "EnableMulticast"
$RegValue = 1

# check registery
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# change value
Set-ItemProperty -Path $RegPath -Name $RegName -Value $RegValue -Type DWord -Force

Write-Host "LLMNR protocol enabled." -ForegroundColor Green
