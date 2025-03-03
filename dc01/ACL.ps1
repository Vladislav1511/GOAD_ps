# Настройка ACL
function Set-ADPermission {
    param (
        [string]$Object,
        [string]$Principal,
        [string]$Rights,
        [string]$Inheritance
    )
    
    $ADObject = Get-ADObject -Filter {Name -eq $Object} -ErrorAction SilentlyContinue
    if ($ADObject) {
        $IdentityRef = (Get-ADUser -Filter {SamAccountName -eq $Principal} -ErrorAction SilentlyContinue) 
        if (-not $IdentityRef) {
            $IdentityRef = Get-ADGroup -Filter {Name -eq $Principal} -ErrorAction SilentlyContinue
        }
        
        if ($IdentityRef) {
            $ACL = Get-Acl "AD:$($ADObject.DistinguishedName)"
            $ACE = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($IdentityRef.SID, $Rights, "Allow", [guid]::Empty, $Inheritance)
            $ACL.AddAccessRule($ACE)
            Set-Acl -Path "AD:$($ADObject.DistinguishedName)" -AclObject $ACL
            Write-Output "Permission $Rights granted to $Principal on $Object"
        } else {
            Write-Output "User/Group $Principal not found."
        }
    } else {
        Write-Output "Object $Object not found."
    }
}

# Применение ACL
Set-ADPermission -Object "jaime.lannister" -Principal "tywin.lannister" -Rights "ExtendedRight" -Inheritance "None"
Set-ADPermission -Object "joffrey.baratheon" -Principal "jaime.lannister" -Rights "GenericWrite" -Inheritance "None"
Set-ADPermission -Object "tyron.lannister" -Principal "joffrey.baratheon" -Rights "WriteDACL" -Inheritance "None"
Set-ADPermission -Object "Small Council" -Principal "tyron.lannister" -Rights "Self" -Inheritance "None"
Set-ADPermission -Object "DragonStone" -Principal "Small Council" -Rights "Write" -Inheritance "All"
Set-ADPermission -Object "KingsGuard" -Principal "DragonStone" -Rights "WriteOwner" -Inheritance "None"
Set-ADPermission -Object "stannis.baratheon" -Principal "KingsGuard" -Rights "GenericAll" -Inheritance "None"
Set-ADPermission -Object "kingslanding$" -Principal "stannis.baratheon" -Rights "GenericAll" -Inheritance "None"
Set-ADPermission -Object "kingslanding$" -Principal "AcrossTheNarrowSea" -Rights "GenericAll" -Inheritance "None"
Set-ADPermission -Object "Domain Admins" -Principal "lord.varys" -Rights "GenericAll" -Inheritance "None"
Set-ADPermission -Object "CN=AdminSDHolder,CN=System,DC=sevenkingdoms,DC=local" -Principal "lord.varys" -Rights "GenericAll" -Inheritance "None"
Set-ADPermission -Object "OU=Crownlands,DC=sevenkingdoms,DC=local" -Principal "renly.baratheon" -Rights "WriteDACL" -Inheritance "None"
