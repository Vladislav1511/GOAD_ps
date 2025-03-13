# PowerShell script to change folder permissions
[CmdletBinding()]
param()

# Define folder permissions
$permissions = @{
    "IIS_IUSRS_upload" = @{
        "path" = "C:\inetpub\wwwroot\Default.aspx"
        "user" = "IIS_IUSRS"
        "rights" = "FullControl"
    }
}

foreach ($perm in $permissions.GetEnumerator()) {
    $folderPath = $perm.Value.path
    $user = $perm.Value.user
    $rights = $perm.Value.rights

    Write-Host "Setting permissions for $user on $folderPath..."
    
    $acl = Get-Acl -Path $folderPath
    $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($user, $rights, "ContainerInherit, ObjectInherit", "None", "Allow")
    
    $acl.SetAccessRule($accessRule)
    Set-Acl -Path $folderPath -AclObject $acl
    
    Write-Host "Permissions set successfully for $user on $folderPath." -ForegroundColor Green
}

Write-Output "Folder permissions updated successfully."
