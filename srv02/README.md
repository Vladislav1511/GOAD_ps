#srv02

first run Users.ps1 to add some users and groups to local groups

then enable RDP

run nullsession.ps1 and check https://web.archive.org/web/20220524195140/http://nikolar.com/2015/03/10/creating-network-share-with-anonymous-access/ , if this command not work (guest account must have fullcontrol over share 'all')

```
nxc smb castelblack -u 'a' -p '' --shares

```


