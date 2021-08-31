#==========================================================================================================================================================================================================
# .NAME
#  AzureStackAdminPowerShell.ps1
#
# .DESCRIPTION
#  This script adds the Admin Portal environment to the console.
#  (Make sure you have installed Microsoft Azure PowerShell module SDK ).
#
# .NOTES
#  Current Version : 0.1
#  Creation Date   : 31 August 2021
# -------------------------------------------------------------------------
# | VERSION |    AUTHOR        |   
#--------------------------------------------------------------------------
# |   0.1   | Vijay Borkar                                    
#                                
#
#==========================================================================================================================================================================================================


#This script adds the Admin Portal environment to the console
Add-AzEnvironment -Name "AzureStackAdmin" -ArmEndpoint "https://adminmanagementportal.cloudboy.com" 
$AuthEndpoint = (Get-AzEnvironment -Name "AzureStackAdmin").ActiveDirectoryAuthority.TrimEnd('/')
$AADTenantName = "cloudboy.onmicrosoft.com"
$TenantId = (invoke-restmethod "$($AuthEndpoint)/$($AADTenantName)/.well-known/openid-configuration").issuer.TrimEnd('/').Split('/')[-1]
 
# After signing in to your environment, Azure Stack Hub cmdlets
# can be easily targeted at your Azure Stack Hub instance.
Connect-AzAccount -EnvironmentName "AzureStackAdmin" -TenantId $TenantId

