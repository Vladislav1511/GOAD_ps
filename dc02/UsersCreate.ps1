# global groups
$groups = @(
    @{Name="Stark"; Path="CN=Users,DC=north,DC=sevenkingdoms,DC=local"; Manager="eddard.stark"},
    @{Name="Night Watch"; Path="CN=Users,DC=north,DC=sevenkingdoms,DC=local"; Manager="jeor.mormont"},
    @{Name="Mormont"; Path="CN=Users,DC=north,DC=sevenkingdoms,DC=local"; Manager="jeor.mormont"}
)

foreach ($group in $groups) {
    New-ADGroup -Name $group.Name -GroupScope Global -Path $group.Path 
}

# localgroup
$domainLocalGroups = @(
    @{Name="AcrossTheSea"; Path="CN=Users,DC=north,DC=sevenkingdoms,DC=local"}
)

foreach ($group in $domainLocalGroups) {
    New-ADGroup -Name $group.Name -GroupScope DomainLocal -Path $group.Path
}

# users
$users = @(
    @{Username="arya.stark"; Firstname="Arya"; Surname="Stark"; Password="Needle"; Path="CN=Users,DC=north,DC=sevenkingdoms,DC=local"; Groups=@("Stark")},
    @{Username="eddard.stark"; Firstname="Eddard"; Surname="Stark"; Password="FightP3aceAndHonor!"; Path="CN=Users,DC=north,DC=sevenkingdoms,DC=local"; Groups=@("Stark", "Domain Admins")},
    @{Username="catelyn.stark"; Firstname="Catelyn"; Surname="Stark"; Password="robbsansabradonaryarickon"; Path="CN=Users,DC=north,DC=sevenkingdoms,DC=local"; Groups=@("Stark")},
    @{Username="robb.stark"; Firstname="Robb"; Surname="Stark"; Password="sexywolfy"; Path="CN=Users,DC=north,DC=sevenkingdoms,DC=local"; Groups=@("Stark")},
    @{Username="sansa.stark"; Firstname="Sansa"; Surname="Stark"; Password="345ertdfg"; Path="CN=Users,DC=north,DC=sevenkingdoms,DC=local"; Groups=@("Stark")},
    @{Username="brandon.stark"; Firstname="Brandon"; Surname="Stark"; Password="iseedeadpeople"; Path="CN=Users,DC=north,DC=sevenkingdoms,DC=local"; Groups=@("Stark")},
    @{Username="rickon.stark"; Firstname="Rickon"; Surname="Stark"; Password="Winter2022"; Path="CN=Users,DC=north,DC=sevenkingdoms,DC=local"; Groups=@("Stark")},
    @{Username="hodor"; Firstname="Hodor"; Surname="Hodor"; Password="hodor"; Path="CN=Users,DC=north,DC=sevenkingdoms,DC=local"; Groups=@("Stark")},
    @{Username="jon.snow"; Firstname="Jon"; Surname="Snow"; Password="iknownothing"; Path="CN=Users,DC=north,DC=sevenkingdoms,DC=local"; Groups=@("Stark", "Night Watch")},
    @{Username="samwell.tarly"; Firstname="Samwell"; Surname="Tarly"; Password="Heartsbane"; Path="CN=Users,DC=north,DC=sevenkingdoms,DC=local"; Groups=@("Night Watch")},
    @{Username="jeor.mormont"; Firstname="Jeor"; Surname="Mormont"; Password="_L0ngCl@w_"; Path="CN=Users,DC=north,DC=sevenkingdoms,DC=local"; Groups=@("Night Watch", "Mormont")}
)

foreach ($user in $users) {
    New-ADUser -Name "$($user.Firstname) $($user.Surname)" `
               -GivenName $user.Firstname `
               -Surname $user.Surname `
               -UserPrincipalName "$($user.Username)@north.sevenkingdoms.local" `
               -SamAccountName $user.Username `
               -Path $user.Path `
               -AccountPassword (ConvertTo-SecureString $user.Password -AsPlainText -Force) `
               -Enabled $true `
               -ChangePasswordAtLogon $false
    
    foreach ($group in $user.Groups) {
        Add-ADGroupMember -Identity $group -Members $user.Username 
    }
}

# managers
foreach ($group in $groups) {
    Set-ADGroup -Identity $group.Name -ManagedBy $group.Manager
}

# add local groups
$localGroups = @{
    "Administrators" = @("north\eddard.stark", "north\catelyn.stark", "north\robb.stark");
    "Remote Desktop Users" = @("north\Stark");
}


foreach ($group in $localGroups.Keys) {
    foreach ($user in $localGroups[$group]) {
        cmd /c "net localgroup `"$group`" `"$user`" /add"
        Write-Host "Added $user to $group" -ForegroundColor Green
    }
}
