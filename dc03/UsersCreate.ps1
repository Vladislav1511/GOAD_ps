# Создание глобальных групп
$globalGroups = @(
    @{Name="Targaryen"; Path="CN=Users,DC=essos,DC=local"},
    @{Name="Dothraki"; Path="CN=Users,DC=essos,DC=local"},
    @{Name="Dragons"; Path="CN=Users,DC=essos,DC=local"},
    @{Name="QueenProtector"; Path="CN=Users,DC=essos,DC=local"}
)

foreach ($group in $globalGroups) {
    New-ADGroup -Name $group.Name -GroupScope Global -Path $group.Path 
}

# Создание локальных доменных групп
$domainLocalGroups = @(
    @{Name="DragonsFriends"; Path="CN=Users,DC=essos,DC=local"},
    @{Name="Spys"; Path="CN=Users,DC=essos,DC=local"}
)

foreach ($group in $domainLocalGroups) {
    New-ADGroup -Name $group.Name -GroupScope DomainLocal -Path $group.Path 
}

# Создание пользователей
$users = @(
    @{Username="daenerys.targaryen"; Firstname="Daenerys"; Surname="Targaryen"; Password="BurnThemAll!"; Path="CN=Users,DC=essos,DC=local"; Groups=@("Targaryen", "Domain Admins")},
    @{Username="viserys.targaryen"; Firstname="Viserys"; Surname="Targaryen"; Password="GoldCrown"; Path="CN=Users,DC=essos,DC=local"; Groups=@("Targaryen")},
    @{Username="khal.drogo"; Firstname="Khal"; Surname="Drogo"; Password="horse"; Path="CN=Users,DC=essos,DC=local"; Groups=@("Dothraki")},
    @{Username="jorah.mormont"; Firstname="Jorah"; Surname="Mormont"; Password="H0nnor!"; Path="CN=Users,DC=essos,DC=local"; Groups=@("Targaryen")},
    @{Username="missandei"; Firstname="Missandei"; Surname=""; Password="fr3edom"; Path="CN=Users,DC=essos,DC=local"; Groups=@()},
    @{Username="drogon"; Firstname="Drogon"; Surname=""; Password="Dracarys"; Path="CN=Users,DC=essos,DC=local"; Groups=@("Dragons")},
    @{Username="sql_svc"; Firstname="SQL"; Surname="Service"; Password="YouWillNotKerboroast1ngMeeeeee"; Path="CN=Users,DC=essos,DC=local"; Groups=@(); SPNs=@("MSSQLSvc/braavos.essos.local:1433","MSSQLSvc/braavos.essos.local")}
)

foreach ($user in $users) {
    New-ADUser -Name "$($user.Firstname) $($user.Surname)" `
               -GivenName $user.Firstname `
               -Surname $user.Surname `
               -UserPrincipalName "$($user.Username)@essos.local" `
               -SamAccountName $user.Username `
               -Path $user.Path `
               -AccountPassword (ConvertTo-SecureString $user.Password -AsPlainText -Force) `
               -Enabled $true `
               -ChangePasswordAtLogon $false 
    
    foreach ($group in $user.Groups) {
        Add-ADGroupMember -Identity $group -Members $user.Username 
    }

    if ($user.PSObject.Properties["SPNs"] -and $user.SPNs.Count -gt 0) {
        foreach ($spn in $user.SPNs) {
            Set-ADUser -Identity $user.Username -ServicePrincipalNames @{Add=$spn} 
        }
    }
}

Write-Host "Users were created successfully." -ForegroundColor Green

# Добавление пользователей в локальные группы
$localGroups = @{
    "Administrators" = @("essos\daenerys.targaryen")
    "Remote Desktop Users" = @("essos\Targaryen")
}

foreach ($localGroup in $localGroups.Keys) {
    foreach ($member in $localGroups[$localGroup]) {
        Write-Host "Adding $member to local group $localGroup..."
        cmd /c "net localgroup `"$localGroup`" `"$member`" /add"
    }
}

Write-Host "Users were added to local groups successfully." -ForegroundColor Green
