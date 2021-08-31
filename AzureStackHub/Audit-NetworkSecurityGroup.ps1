#=========================================================================================================================================================================================================
# .NAME
#  Audit-NetworkSecurityGroup.ps1
#
# .DESCRIPTION
#  Export NSG and its rules to csv with below Azure Powershell command. Declare the variable details and in the last Export-Csv Path location where all the captured inforamtion to be collected.
#  (Make sure you have installed Microsoft Azure PowerShell module SDK and logged on Azure using Login-AzAccount).
#
# .NOTES
#  Current Version : 0.1
#  Creation Date   : 31 August 2021
#  Purpose/Change  : List all NSG with rules in Azure Stack Hub Subscriptions
# --------------------------------------------------------------------------
# | VERSION |    AUTHOR        |   
#--------------------------------------------------------------------------
# |   0.1   | Vijay Borkar                                    
#                                
#
#========================================================================================================================================================================================================

#---------DECLARE VARIABLES------------------------------------#
$Subscription = Get-AzSubscription
$day = Get-Date -Format " ddMMMyyyy"
$nsgPath = "C:\mytempfolder\"+"$day-NSG-Details.csv"
$nsgRulePath = "C:\mytempfolder\"

#---------------DEFINE FUNCTIONS------------------------------#


function Audit-NetworkSecurityGroup {

    foreach ($subs in $Subscription){

        Select-AzSubscription -SubscriptionName $subs.Name | Out-Null 
        Write-Host 'The selected Subscription is' ($subs).Name
        Start-Sleep -Seconds 5
        $NetworkSecurityGroups = Get-AzNetworkSecurityGroup
        
        foreach ($nsg in $NetworkSecurityGroups) {
           
            Write-Host 'The selected Virtual Network is' ($nsg).Name 'and the information as follows'
            New-Item -ItemType file -Path "$nsgRulePath\$($nsg.Name).csv" -Force
            $nsgSRules = $nsg.SecurityRules
            $nsgDRules = $nsg.DefaultSecurityRules
            $nsg | Select-Object  `
            @{label='SubscriptionName'; expression={$subs.Name}},`
            ResourceGroupName, `
            Name | Export-CSV -Path $nsgPath -NoTypeInformation -Encoding ASCII  -Append
            
            foreach ($nsgSRule in $nsgSRules) {
                $nsgSRule | Select-Object Name,Description,Priority,@{Name=’SourceAddressPrefix’;Expression={[string]::join(“,”, ($_.SourceAddressPrefix))}},@{Name=’SourcePortRange’;Expression={[string]::join(“,”, ($_.SourcePortRange))}},@{Name=’DestinationAddressPrefix’;Expression={[string]::join(“,”, ($_.DestinationAddressPrefix))}},@{Name=’DestinationPortRange’;Expression={[string]::join(“,”, ($_.DestinationPortRange))}},Protocol,Access,Direction `
                | Export-Csv "$nsgRulePath\$($nsg.Name).csv" -NoTypeInformation -Encoding ASCII -Append
            }
            foreach ($nsgDRule in $nsgDRules) {
                $nsgDRule | Select-Object Name,Description,Priority,@{Name=’SourceAddressPrefix’;Expression={[string]::join(“,”, ($_.SourceAddressPrefix))}},@{Name=’SourcePortRange’;Expression={[string]::join(“,”, ($_.SourcePortRange))}},@{Name=’DestinationAddressPrefix’;Expression={[string]::join(“,”, ($_.DestinationAddressPrefix))}},@{Name=’DestinationPortRange’;Expression={[string]::join(“,”, ($_.DestinationPortRange))}},Protocol,Access,Direction `
                | Export-Csv "$nsgRulePath\$($nsg.Name).csv" -NoTypeInformation -Encoding ASCII -Append
            }
            
        }
          
        
    }
    
}


#-----------------MAIN ACTIONS------------------------------#

#Perform Audit of NetworkSecurityGroup in Azure Stack Subscriptions
Audit-NetworkSecurityGroup

