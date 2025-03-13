# PowerShell script to add users to local groups using net command
[CmdletBinding()]
param()

# Define local groups and users
$localGroups = @{
    "Администраторы" = @("essos\khal.drogo");
    "Пользователи удаленного рабочего стола" = @("essos\Dothraki")
}

# Add users to local groups
foreach ($group in $localGroups.Keys) {
    foreach ($user in $localGroups[$group]) {
        Write-Host "Adding $user to $group..."
        cmd /c "net localgroup `"$group`" `"$user`" /add"
        Write-Host "$user has been added to $group successfully." -ForegroundColor Green
    }
}

Write-Output "All users have been added to their respective local groups."