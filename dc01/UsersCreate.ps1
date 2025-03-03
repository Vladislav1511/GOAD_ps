# Создание организационных единиц (OU)
$OUs = @(
    "Vale", "IronIslands", "Riverlands", "Crownlands", "Stormlands", "Westerlands", "Reach", "Dorne"
)

foreach ($OU in $OUs) {
    New-ADOrganizationalUnit -Name $OU -Path "DC=sevenkingdoms,DC=local" -ProtectedFromAccidentalDeletion $false -ErrorAction SilentlyContinue
}

# Создание групп
$groups = @(
    @{Name="Lannister"; Path="OU=Westerlands,DC=sevenkingdoms,DC=local"; ManagedBy="tywin.lannister"},
    @{Name="Baratheon"; Path="OU=Stormlands,DC=sevenkingdoms,DC=local"; ManagedBy="robert.baratheon"},
    @{Name="Small Council"; Path="OU=Crownlands,DC=sevenkingdoms,DC=local"},
    @{Name="DragonStone"; Path="OU=Crownlands,DC=sevenkingdoms,DC=local"},
    @{Name="KingsGuard"; Path="OU=Crownlands,DC=sevenkingdoms,DC=local"},
    @{Name="DragonRider"; Path="OU=Crownlands,DC=sevenkingdoms,DC=local"},
    @{Name="AcrossTheNarrowSea"; Path="CN=Users,DC=sevenkingdoms,DC=local"}
)

foreach ($group in $groups) {
    New-ADGroup -Name $group.Name -GroupScope Global -Path $group.Path -ErrorAction SilentlyContinue
    if ($group.ManagedBy) {
        Set-ADGroup -Identity $group.Name -ManagedBy $group.ManagedBy
    }
}

# Создание пользователей
$users = @(
    @{Username="tywin.lannister"; Firstname="Tywin"; Surname="Lannister"; Password="powerkingftw135"; Path="OU=Crownlands,DC=sevenkingdoms,DC=local"; Groups=@("Lannister")},
    @{Username="jaime.lannister"; Firstname="Jaime"; Surname="Lannister"; Password="cersei"; Path="OU=Crownlands,DC=sevenkingdoms,DC=local"; Groups=@("Lannister")},
    @{Username="cersei.lannister"; Firstname="Cersei"; Surname="Lannister"; Password="il0vejaime"; Path="OU=Crownlands,DC=sevenkingdoms,DC=local"; Groups=@("Lannister", "Baratheon", "Domain Admins", "Small Council")},
    @{Username="tyron.lannister"; Firstname="Tyron"; Surname="Lannister"; Password="Alc00L&S3x"; Path="OU=Westerlands,DC=sevenkingdoms,DC=local"; Groups=@("Lannister")},
    @{Username="robert.baratheon"; Firstname="Robert"; Surname="Baratheon"; Password="iamthekingoftheworld"; Path="OU=Crownlands,DC=sevenkingdoms,DC=local"; Groups=@("Baratheon", "Domain Admins", "Small Council", "Protected Users")},
    @{Username="joffrey.baratheon"; Firstname="Joffrey"; Surname="Baratheon"; Password="1killerlion"; Path="OU=Crownlands,DC=sevenkingdoms,DC=local"; Groups=@("Baratheon", "Lannister")}
)

foreach ($user in $users) {
    New-ADUser -Name "$($user.Firstname) $($user.Surname)" `
               -GivenName $user.Firstname `
               -Surname $user.Surname `
               -UserPrincipalName "$($user.Username)@sevenkingdoms.local" `
               -SamAccountName $user.Username `
               -Path $user.Path `
               -AccountPassword (ConvertTo-SecureString $user.Password -AsPlainText -Force) `
               -Enabled $true `
               -ChangePasswordAtLogon $false -ErrorAction SilentlyContinue
    
    foreach ($group in $user.Groups) {
        Add-ADGroupMember -Identity $group -Members $user.Username -ErrorAction SilentlyContinue
    }
}

# Добавление пользователей и групп в локальные группы
$localGroups = @{
    "Administrators" = @(
        "sevenkingdoms\\robert.baratheon",
        "sevenkingdoms\\cersei.lannister",
        "sevenkingdoms\\DragonRider"
    )
    "Remote Desktop Users" = @(
        "sevenkingdoms\\Small Council",
        "sevenkingdoms\\Baratheon"
    )
}

foreach ($localGroup in $localGroups.Keys) {
    foreach ($member in $localGroups[$localGroup]) {
        Add-LocalGroupMember -Group $localGroup -Member $member -ErrorAction SilentlyContinue
    }
}
