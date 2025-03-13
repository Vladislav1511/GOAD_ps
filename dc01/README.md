# dc01



first, u need to setup Windows Server 2019 with this parameters

"hostname" : "kingslanding",
 "local_admin_password": "8dCT-DJjgScp",
 "domain" : "sevenkingdoms.local",
"netbios_name": "SEVENKINGDOMS"

next u need to enable RDP on this server via "local server"

![](test.png)


next, run ps scripts in this order
```
UsersCreate.ps1
ACL.ps1
laps.ps1 
```


after this u need to install essos.local (dc03), install the bidirect trust and run this script on dc01
```
sidhistory.ps1
add_trustUser.ps1

```

