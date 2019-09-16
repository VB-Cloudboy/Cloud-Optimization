#===================================================================================
# Created by       : Vijay Borkar [VB-Cloudboy --> https://github.com/VB-Cloudboy]
# Version          : 0.1 | Setting up Active Directory Domain Services 
#===================================================================================


# 1.Defining Variables
$databasepath = "C:\Windows\NTDS"
$doaminmode = "win2016"
$domainname = "mydomain.com"
$domainnetbiosname = "VB-CLOUDBOY"
$forestmode = "Win2016"
$logpath = "C:\Windows\NTDS"
$sysvolpath = "C:\Windows\SYSVOL"


# 2.Install windows feature in windows
Install-windowsfeature AD-domain-services

# 3.Install AD module
Import-Module ADDSDeployment

# 4.Define AD Forest 
Install-ADDSForest -CreateDnsDelegation:$false `
-DatabasePath $databasepath `
-DomainMode $doaminmode `
-DomainName $domainname `
-DomainNetbiosName $domainnetbiosname `
-ForestMode $forestmode `
-InstallDns:$true `
-LogPath $logpath `
-NoRebootOnCompletion:$false `
-SysvolPath $sysvolpath `
-Force:$true