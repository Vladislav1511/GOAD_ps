
function Set-ADPerm([string]$ObjTypeFor, [string]$ObjTypeTo, [string]$ObjFor, [string]$ObjTo, [string]$Permission) {
    Import-Module ActiveDirectory

    $ObjForAccount = $null
    $ObjToDN = $null

        switch ($ObjTypeFor) {
        "User" {
            $ObjForAccount = Get-ADUser -Identity $ObjFor -ErrorAction SilentlyContinue
            if ($ObjForAccount) {
                $ObjForAccount = New-Object System.Security.Principal.NTAccount($ObjForAccount.SamAccountName)
            }
        }
        "Group" {
            $ObjForAccount = Get-ADGroup -Identity $ObjFor -ErrorAction SilentlyContinue
            if ($ObjForAccount) {
                $ObjForAccount = New-Object System.Security.Principal.NTAccount($ObjForAccount.SamAccountName)
            }
        }
        "Computer" {
            $ObjForAccount = Get-ADComputer -Identity $ObjFor -ErrorAction SilentlyContinue
            if ($ObjForAccount) {
                $ObjForAccount = New-Object System.Security.Principal.NTAccount($ObjForAccount.SamAccountName)
            }
        }
        "OU" {
            $ObjForAccount = Get-ADOrganizationalUnit -Identity $ObjFor -ErrorAction SilentlyContinue
            if ($ObjForAccount) {
                $ObjForAccount = New-Object System.Security.Principal.NTAccount($ObjForAccount.Name)
            }
        }
        default {
            Write-Host "Unsupported object type: $ObjTypeFor" -ForegroundColor Red
            return
        }
    }

    if (-not $ObjForAccount) {
        Write-Host "Object $ObjFor not found or invalid type." -ForegroundColor Red
        return
    }


    switch ($ObjTypeTo) {
        "User" {
            $ObjToDN = (Get-ADUser -Identity $ObjTo -ErrorAction SilentlyContinue).DistinguishedName
        }
        "Group" {
            $ObjToDN = (Get-ADGroup -Identity $ObjTo -ErrorAction SilentlyContinue).DistinguishedName
        }
        "Computer"{
            $ObjToDN = (Get-ADComputer -Identity $ObjTo -ErrorAction SilentlyContinue).DistinguishedName

        }
        "OU" {
            $ObjToDN = (Get-ADOrganizationalUnit -Identity $ObjTo -ErrorAction SilentlyContinue).DistinguishedName
        }
        "DN"{
            $ObjToDN = $ObjTo
        }
        default {
            Write-Host "Unsupported object type: $ObjTypeTo" -ForegroundColor Red
            return
        }
    }

    if (-not $ObjToDN) {
        Write-Host "Object $ObjTo not found or invalid type." -ForegroundColor Red
        return
    }
    
    $acl = Get-Acl -Path "AD:$ObjToDN"

    $PermissionGuid = $null
    $Right = $null

    switch($Permission){
        "Self-Membership"{
            $PermissionGuid = [guid]"bf9679c0-0de6-11d0-a285-00aa003049e2"
            $Right = [System.DirectoryServices.ActiveDirectoryRights]::Self
        }
        "User-Force-Change-Password"{
            $PermissionGuid = [guid]"00299570-246d-11d0-a768-00aa006e0529"
            $Right = [System.DirectoryServices.ActiveDirectoryRights]::ExtendedRight
        }        
        "Write-Self-Membership"{
            $PermissionGuid = [guid]"bf9679c0-0de6-11d0-a285-00aa003049e2"
            $Right = [System.DirectoryServices.ActiveDirectoryRights]::WriteProperty
        }
        default{
            $PermissionGuid = $null
            $Right = $null
        }
    }
    if (($PermissionGuid -ne $null) -and ($Right -ne $null)) {
        $ace = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
            $ObjForAccount,
            $Right,
            [System.Security.AccessControl.AccessControlType]::Allow,
            $PermissionGuid,
            [System.DirectoryServices.ActiveDirectorySecurityInheritance]::None
        )
    }

    else{
        $ace = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
            $ObjForAccount,
            [System.DirectoryServices.ActiveDirectoryRights]::$Permission,
            [System.Security.AccessControl.AccessControlType]::Allow,
            [System.DirectoryServices.ActiveDirectorySecurityInheritance]::None
        )
    }

    try {  
            $acl.AddAccessRule($ace)
            Set-Acl -Path "AD:$ObjToDN" -AclObject $acl

            Write-Host "Permission $Permission was given to user $ObjFor on object $ObjTo." -ForegroundColor Green
        } catch {
            Write-Host "Error due to change ACL: $_" -ForegroundColor Red
        }
}

# Set-ADPerm -ObjTypeFor "User" -ObjTypeTo "User" -ObjFor "tywin.lannister" -ObjTo "jaime.lannister" -Permission "User-Force-Change-Password"

# Set-ADPerm -ObjTypeFor "User" -ObjTypeTo "DN" -ObjFor "lord.varys" -ObjTo "CN=AdminSDHolder,CN=System,DC=sevenkingdoms,DC=local" -Permission "GenericAll"

# Set-ADPerm -ObjTypeFor "User" -ObjTypeTo "User" -ObjFor "jaime.lannister" -ObjTo "joffrey.baratheon" -Permission "GenericWrite"
# Set-ADPerm -ObjTypeFor "User" -ObjTypeTo "User" -ObjFor "joffrey.baratheon" -ObjTo "tyron.lannister" -Permission "WriteDACL" 


# Set-ADPerm -ObjTypeFor "User" -ObjTypeTo "Group" -ObjFor "tyron.lannister" -ObjTo "Small Council" -Permission "Self-Membership"

# Set-ADPerm -ObjTypeFor "Group" -ObjTypeTo "Group" -ObjFor "Small Council" -ObjTo "DragonStone" -Permission "Write-Self-Membership"

# Set-ADPerm -ObjTypeFor "Group" -ObjTypeTo "Group" -ObjFor "DragonStone" -ObjTo "KingsGuard" -Permission "WriteOwner"
# Set-ADPerm -ObjTypeFor "Group" -ObjTypeTo "User" -ObjFor "DragonStone" -ObjTo "stannis.baratheon" -Permission "GenericAll"
# Set-ADPerm -ObjTypeFor "User" -ObjTypeTo "Computer" -ObjFor "stannis.baratheon" -ObjTo "kingslanding$" -Permission "GenericAll"

Set-ADPerm -ObjTypeFor "Computer" -ObjTypeTo "Group" -ObjFor "kingslanding$" -ObjTo "AcrossTheNarrowSea" -Permission "GenericAll"



# Set-ADPerm -ObjTypeFor "User" -ObjTypeTo "Group" -ObjFor "lord.varys" -ObjTo "Domain Admins" -Permission "GenericAll"
# Set-ADPerm -ObjTypeFor "User" -ObjTypeTo "DN" -ObjFor "lord.varys" -ObjTo "OU=Crownlands,DC=sevenkingdoms,DC=local" -Permission "WriteDACL"


