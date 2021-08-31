#==========================================================================================================================================================================================================
# .NAME
#  AzureStackUserPowerShell.ps1
#
# .DESCRIPTION
#  This script adds the User Portal environment to the console.
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


#This script adds the User Portal environment to the console 
Add-AzEnvironment -Name "AzureStackUser" -ArmEndpoint "https://usermanagementportal.cloudboy.com"

# Set your tenant name
$AuthEndpoint = (Get-AzEnvironment -Name "AzureStackUser").ActiveDirectoryAuthority.TrimEnd('/')
$AADTenantName = "cloudboy.onmicrosoft.com"
$TenantId = (invoke-restmethod "$($AuthEndpoint)/$($AADTenantName)/.well-known/openid-configuration").issuer.TrimEnd('/').Split('/')[-1]
 
# After signing in to your environment, Azure Stack Hub cmdlets
# can be easily targeted at your Azure Stack Hub instance.
Connect-AzAccount -EnvironmentName "AzureStackUser" -TenantId $TenantId

# Select the test subscription as default
Set-AzContext -Subscription 'xxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx'

#Check the active subscription in the list
Get-AzContext
