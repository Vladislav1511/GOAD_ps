Add-ADGroupMember -Server "essos.local" -Identity "DragonsFriends" -Members (Get-ADUser -Server "sevenkingdoms.local" -Identity "tyron.lannister" -Properties objectSID).objectSID

Add-ADGroupMember -Server "essos.local" -Identity "Spys" -Members (Get-ADGroup -Server "sevenkingdoms.local" -Identity "Small Council" -Properties objectSID).objectSID

Add-ADGroupMember -Server "essos.local" -Identity "DragonsFriends" -Members (Get-ADUser  -Identity "daenerys.targaryen" -Properties objectSID).objectSID
