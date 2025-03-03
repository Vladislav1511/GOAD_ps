# Parameters
$groupName = "AcrossTheNarrowSea"  # Group name in the sevenkingdoms.local domain
$externalUser = "essos.local\daenerys.targaryen"  # User from another domain

# Add the external user to the group
try {
    Add-ADGroupMember -Identity $groupName -Members $externalUser -ErrorAction Stop
    Write-Host "User $externalUser has been successfully added to the group $groupName."
} catch {
    Write-Warning "Failed to add user $externalUser to the group $groupName."
    Write-Warning "Please ensure the following:"
    Write-Warning "1. A trust relationship is established between the sevenkingdoms.local and essos.local domains."
    Write-Warning "2. The user $externalUser exists in the essos.local domain."
    Write-Warning "3. You have sufficient permissions to manage the group in the sevenkingdoms.local domain."
}
