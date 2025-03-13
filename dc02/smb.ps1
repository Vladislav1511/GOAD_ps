# PowerShell script to create SMB share safely

$shares = @{
    "setup" = @{
        "path" = "C:\setup"
        "full_access" = "Administrators"
        "rw_access" = ""
        "ro_access" = ""
    }
}

foreach ($share in $shares.GetEnumerator()) {
    $shareName = $share.Key
    $path = $share.Value.path
    $full_access = $share.Value.full_access
    $rw_access = $share.Value.rw_access
    $ro_access = $share.Value.ro_access

    # Create directory if not exists
    if (-not (Test-Path $path)) {
        New-Item -Path $path -ItemType Directory -Force | Out-Null
        Write-Host "Directory created: $path" -ForegroundColor Green
    } else {
        Write-Host "Directory already exists: $path" -ForegroundColor Yellow
    }

    # Prepare parameters
    $smbArgs = @{
        Name = $shareName
        Path = $path
        Description = "Share $shareName"
    }

    if ($full_access) {
        $smbArgs.FullAccess = $full_access
    }
    if ($rw_access) {
        $smbArgs.ChangeAccess = $rw_access
    }
    if ($ro_access) {
        $smbArgs.ReadAccess = $ro_access
    }

    # Create SMB share
    if (-not (Get-SmbShare -Name $shareName -ErrorAction SilentlyContinue)) {
        New-SmbShare @smbArgs
        Write-Host "SMB Share created: $shareName at $path" -ForegroundColor Green
    } else {
        Write-Host "SMB Share already exists: $shareName" -ForegroundColor Yellow
    }
}
