# Установка LAPS
Install-WindowsFeature -Name RSAT-AD-PowerShell

# Импорт модуля LAPS
Import-Module AdmPwd.PS

# Расширение схемы AD для LAPS
Update-AdmPwdADSchema

# Создание политики прав на пароли LAPS
$LapsOU = "OU=Laps,DC=sevenkingdoms,DC=local"
Set-AdmPwdComputerSelfPermission -OrgUnit $LapsOU

# Назначение прав для управления паролями
$Admins = @("Domain Admins")
foreach ($Admin in $Admins) {
    Set-AdmPwdReadPasswordPermission -OrgUnit $LapsOU -AllowedPrincipals $Admin
    Set-AdmPwdResetPasswordPermission -OrgUnit $LapsOU -AllowedPrincipals $Admin
}

Write-Output "LAPS успешно настроен в $LapsOU"

