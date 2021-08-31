#==========================================================================================================================================================================================================
# .NAME
#  Check-ResourceGroup.ps1
#
# .DESCRIPTION
#  These Powershell commands help to Check the Resource Group Availability.
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

#---------- DECLARE VARIABLES -----------------#
$ResGrpName             = "02demo"       # Enter resource group name in which you have to deploy the resources
$Loc                    = "Loc01"        # Enter the region or location details 


#----------- DEFINE FUNCTIONS ------------#

function Check-ResourceGroup {

  $AllRGs = Get-AzResourceGroup

  if (($AllRGs).ResourceGroupName -eq $ResGrpName) {

          Write-Output "The Resource group exist and the deployment of template will proceed further"

      } else {

          Write-Output "The Resource group does not exist the script will create a resource group in location $Loc" 
          New-AzResourceGroup -Name $ResGrpName -Location $Loc
          Write-Output "The Resource group is created successfully and now the deployment of template will proceed further"    
      }
  
}
