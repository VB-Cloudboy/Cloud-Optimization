#=========================================================================================================================================================================================================
# .NAME
#  GetReports-VMagentExtension.ps1
#
# .DESCRIPTION
#  Get The Installed extensions Log Analytics agent on Azure virtual machines, and enrolled in virtual machines into an existing Log Analytics workspace.
#  (Make sure you have installed Microsoft Azure PowerShell module SDK and logged on Azure using Login-AzAccount).
#
# .NOTES
#  Current Version : 0.1
#  Creation Date   : 06 September 2021
#  Purpose/Change  : Fetch reports of the Log Analytics agent of virtual machine extension on existing virtual machine.
# --------------------------------------------------------------------------
# | VERSION |    AUTHOR        |   
#--------------------------------------------------------------------------
# |   0.1   | Vijay Borkar                                    
#                                
#========================================================================================================================================================================================================

$subscriptionName = "Test-Subscription"

# Select the subscription as default
Select-AzSubscription -SubscriptionName $subscriptionName
Write-Host 'The selected Subscription is' $subscriptionName -ForegroundColor Green 
Start-Sleep -Seconds 5

# Create a directory to capture the Information
$Day            = Get-Date -Format " ddMMMyyyy"
$FileNametype   = (Get-Date).tostring("dd-MM-yyyy-hhmmss") 
$DirLocation    = 'C:\'
$DirName        = "$Day-$subscriptionName"
$FolderPath     = "$DirLocation$DirName"

    if (Test-Path -Path $FolderPath ) {
        Write-Host 'The Folder Exist in' $DirLocation -ForegroundColor Green } 
        else {
            Write-Host 'Creating New Folder named' $DirName 'in' $DirLocation -ForegroundColor Yellow
            New-Item -Path $DirLocation -Name $DirName -ItemType "directory"
            Write-Host 'Created Folder' $DirName 'in' $DirLocation 'sSuccessfully' -ForegroundColor Green
        }
    Start-Sleep -Seconds 5

# Fetch Resource Group details 
$ResourceGroups = Get-AzResourceGroup 

#Choice to proceed with Monitoring Agent Installation on Virtual Machines
$title    = 'Microsoft Monitoring Agent'
$question01 = 'Do you wnat to perform Scan for Log Analytics agent virtual machine extensions in '+$subscriptionName+' Subscription'

$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

$decision01 = $Host.UI.PromptForChoice($title, $question01, $choices, 1)

if ($decision01 -eq 0) {
    
#Perform Scan for Log Analytics agent virtual machine extension
    foreach ($ResourceGroup in $ResourceGroups){

        $vms = Get-AzVM -ResourceGroupName $($ResourceGroup.ResourceGroupName)
        

        foreach ($vm in $vms){

            # Export VM extension details in CSV format
            $vmextn = Get-AzVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName | Select-Object Name, ResourceGroupName, @{Name=’OsType’;Expression={[string]::join(“,”, ($_.StorageProfile.OsDisk.OsType))}}, `
            @{label='Extensions';Expression={[string]::join(",",($_.Extensions.VirtualMachineExtensionType))}} `
            | Export-Csv "$FolderPath\VMextensionList-$FileNametype.csv" -NoTypeInformation -Append
            Write-Host "Exported VM extension details in CSV format at location $FolderPath " -ForegroundColor Green
            Start-Sleep -Seconds 03
                
            
        }

    }

} else {
    
    Write-Host "Existing Agent scan process... " -ForegroundColor DarkBlue
}
