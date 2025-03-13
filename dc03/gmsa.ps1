[CmdletBinding()]
param (
    [String]$gMSA_Name = "gmsaDragon",
    [String]$gMSA_FQDN = "gmsaDragon.essos.local",
    [String[]]$gMSA_SPNs = @("HTTP/braavos", "HTTP/braavos.essos.local"),
    [String[]]$gMSA_HostNames = @("braavos")
)

# Import Active Directory module
Import-Module ActiveDirectory

# Ensure the script runs in the Active Directory context
Set-Location AD:

# Create KDS Root Key if it does not exist (needed for gMSA)
if (-not (Get-ADObject -Filter 'ObjectClass -eq "msKds-ProvRootKey"')) {
    Write-Host "Creating KDS Root Key..." -ForegroundColor Yellow
    Add-KdsRootKey -EffectiveTime (Get-Date).AddHours(-10)
    Write-Host "KDS Root Key has been created." -ForegroundColor Green
    Start-Sleep -Seconds 10
}

# Retrieve host computers for gMSA
$gMSA_HostsGroup = $gMSA_HostNames | ForEach-Object { Get-ADComputer -Identity $_  }

# Check if hosts exist
if (-not $gMSA_HostsGroup) {
    Write-Host "Error: One or more specified hosts do not exist in Active Directory!" -ForegroundColor Red
    Exit
}

# Create the gMSA account
Write-Host "Creating gMSA: $gMSA_Name ..." -ForegroundColor Yellow
New-ADServiceAccount -Name $gMSA_Name `
    -DNSHostName $gMSA_FQDN `
    -PrincipalsAllowedToRetrieveManagedPassword $gMSA_HostsGroup `
    -ServicePrincipalNames $gMSA_SPNs

Write-Host "gMSA $gMSA_Name has been created successfully." -ForegroundColor Green
