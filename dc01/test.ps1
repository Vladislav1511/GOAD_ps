# Удаление группы AcrossTheNarrowSea
$groupName = "AcrossTheNarrowSeaUniversal"
$existingGroup = Get-ADGroup -Identity $groupName -ErrorAction SilentlyContinue

if ($existingGroup) {
    Remove-ADGroup -Identity $groupName -Confirm:$false
    Write-Host "Group $groupName has been deleted." -ForegroundColor Green
} else {
    Write-Host "Group $groupName does not exist." -ForegroundColor Yellow
}

# Создание универсальной группы
$universalGroupName = "AcrossTheNarrowSea"
New-ADGroup -Name $universalGroupName `
            -GroupScope Universal `
            -Path "CN=Users,DC=sevenkingdoms,DC=local" `
            -Description "Universal version of AcrossTheNarrowSea"

Write-Host "Universal group $universalGroupName has been created." -ForegroundColor Green

