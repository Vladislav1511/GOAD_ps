# PowerShell script to create a certificate template in ADCS
[CmdletBinding()]
param()

# Import Active Directory module
Import-Module ActiveDirectory

# Define AD paths
$ConfigDN = (Get-ADRootDSE).ConfigurationNamingContext
$TemplateDN = "CN=ESC1,CN=Certificate Templates,CN=Public Key Services,CN=Services,$ConfigDN"

# Check if the template already exists
$existingTemplate = Get-ADObject -LDAPFilter "(cn=ESC1)" -SearchBase "CN=Certificate Templates,CN=Public Key Services,CN=Services,$ConfigDN" -ErrorAction SilentlyContinue

if ($existingTemplate) {
    Write-Host "Template ESC1 already exists in ADCS." -ForegroundColor Yellow
    Exit
}

Write-Host "Creating new certificate template: ESC1..." -ForegroundColor Green

# Create a new object in AD
New-ADObject -Name "ESC1" `
    -Type pKICertificateTemplate `
    -Path "CN=Certificate Templates,CN=Public Key Services,CN=Services,$ConfigDN" `
    -OtherAttributes @{
        displayName = "ESC1"
        objectClass = "pKICertificateTemplate"
        flags = 131616
        revision = 100
        "msPKI-Cert-Template-OID" = "1.3.6.1.4.1.311.21.8.16735922.7437492.10570883.2539024.15756463.185.9025784.11813639"
        "msPKI-Certificate-Application-Policy" = @("1.3.6.1.5.5.7.3.2")
        "msPKI-Certificate-Name-Flag" = 1
        "msPKI-Enrollment-Flag" = 0
        "msPKI-Minimal-Key-Size" = 2048
        "msPKI-Private-Key-Flag" = 16842752
        "msPKI-RA-Signature" = 0
        "msPKI-Template-Minor-Revision" = 4
        "msPKI-Template-Schema-Version" = 2
        "pKICriticalExtensions" = @("2.5.29.15", "2.5.29.7")
        "pKIDefaultCSPs" = @("3,Microsoft Base DSS Cryptographic Provider", "2,Microsoft Base Cryptographic Provider v1.0", "1,Microsoft Enhanced Cryptographic Provider v1.0")
        "pKIDefaultKeySpec" = 2
        "pKIExpirationPeriod" = @(0, 64, 57, 135, 46, 225, 254, 255)
        "pKIExtendedKeyUsage" = @("1.3.6.1.5.5.7.3.2")
        "pKIKeyUsage" = @(128, 0)
        "pKIMaxIssuingDepth" = 0
        "pKIOverlapPeriod" = @(0, 128, 166, 10, 255, 222, 255, 255)
    }

Write-Host "Certificate template ESC1 successfully added to ADCS!" -ForegroundColor Green

