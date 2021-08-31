#==========================================================================================================================================================================================================
# .NAME
#  AzureStackHubPowerShellSetup.ps1
#
# .DESCRIPTION
#  These Powershell commands help to configure the PowerShell envoirnment on the Management VM / Jumphost
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

# Step 1: Check PowerShell Version > 5.1
$PSVersionTable.PSVersion
 
# Step 2: Remove Existing Azure Modules
Get-Module -Name Azure* -ListAvailable | Uninstall-Module -Force -Verbose -ErrorAction Continue
Get-Module -Name Azs.* -ListAvailable | Uninstall-Module -Force -Verbose -ErrorAction Continue
Get-Module -Name Az.* -ListAvailable | Uninstall-Module -Force -Verbose -ErrorAction Continue
 
#Step 3:Ensure PowerShellGet version > 2.2.3; If this errors use Get-Module PowerShellGet to confirm version
Install-Module PowerShellGet -MinimumVersion 2.2.3 -Force
 
# Step 4: Install Azure Stack PowerShell modules
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
 
Install-Module -Name Az.BootStrapper -Force -AllowPrerelease
Install-AzProfile -Profile 2019-03-01-hybrid -Force
Install-Module -Name AzureStack -RequiredVersion 2.0.2-preview -AllowPrerelease
 
# Step 5: Download PowerShell Tools. Change to prefered install directory first.
# Download the tools archive.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 
invoke-webrequest `
  https://github.com/Azure/AzureStack-Tools/archive/az.zip `
  -OutFile az.zip
 
# Expand the downloaded files.
expand-archive az.zip `
  -DestinationPath . `
  -Force
 
# Change to the tools directory.
cd AzureStack-Tools-az
