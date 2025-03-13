function Set-ADPerm([string]$ObjFor, [string]$ObjTo, [string]$Permission, [string]$Inheritance) {
    Import-Module ActiveDirectory

    $ObjForAccount = New-Object System.Security.Principal.NTAccount($ObjFor)
    
    $ObjToDN = $ObjTo
    
    $acl = Get-Acl -Path "AD:$ObjToDN"
    
    $ace = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
        $ObjForAccount,
        [System.DirectoryServices.ActiveDirectoryRights]::$Permission,
        [System.Security.AccessControl.AccessControlType]::Allow,
        [System.DirectoryServices.ActiveDirectorySecurityInheritance]::$Inheritance
    )
    
    try {  
        $acl.AddAccessRule($ace)
        Set-Acl -Path "AD:$ObjToDN" -AclObject $acl
        Write-Host "Permission $Permission was given to $ObjFor on $ObjTo." -ForegroundColor Green
    } catch {
        Write-Host "Error changing ACL: $_" -ForegroundColor Red
    }
}

#  ANONYMOUS LOGON
Set-ADPerm -ObjFor "NT AUTHORITY\ANONYMOUS LOGON" -ObjTo "DC=north,DC=sevenkingdoms,DC=local" -Permission "ReadProperty" -Inheritance "All"
Set-ADPerm -ObjFor "NT AUTHORITY\ANONYMOUS LOGON" -ObjTo "DC=north,DC=sevenkingdoms,DC=local" -Permission "GenericExecute" -Inheritance "All"

[CmdletBinding()]
param ()

Import-Module ActiveDirectory

$identity = "DC=north,DC=sevenkingdoms,DC=local"
$adObj = [ADSI]("LDAP://" + $identity)
$acl = $adObj.psbase.ObjectSecurity

$forSID = New-Object System.Security.Principal.NTAccount "NT AUTHORITY\ANONYMOUS LOGON"
$type = [System.Security.AccessControl.AccessControlType] "Allow"
$inheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance]"All"

$rights = @("ListObject", "ListChildren", "GenericRead")

foreach ($right in $rights) {
    $adRight = [System.DirectoryServices.ActiveDirectoryRights]$right
    $ace = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($forSID, $adRight, $type, [Guid]::Empty, $inheritanceType)
    $acl.AddAccessRule($ace)
}

$adObj.psbase.CommitChanges()

Write-Output "Anonymous permissions successfully set on $identity."
