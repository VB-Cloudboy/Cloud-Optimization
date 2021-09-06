#=========================================================================================================================================================================================================
# .NAME
#  Install-VMagentExtension.ps1
#
# .DESCRIPTION
#  The extension installs the Log Analytics agent on Azure virtual machines, and enrolls virtual machines into an existing Log Analytics workspace.
#  (Make sure you have installed Microsoft Azure PowerShell module SDK and logged on Azure using Login-AzAccount).
#
# .NOTES
#  Current Version : 0.1
#  Creation Date   : 06 September 2021
#  Purpose/Change  : Deploy the Log Analytics agent virtual machine extension to an existing virtual machine.
# --------------------------------------------------------------------------
# | VERSION |    AUTHOR        |   
#--------------------------------------------------------------------------
# |   0.1   | Vijay Borkar                                    
#                                
#========================================================================================================================================================================================================

$SubscriptionName = "test-subscription"

# Select the subscription as default
Select-AzSubscription -SubscriptionName $SubscriptionName
Write-Host 'The selected Subscription is' $SubscriptionName -ForegroundColor Green 
Start-Sleep -Seconds 5

#Declare Log Analytics Workspace details 
$PublicSettings = @{"workspaceId" = ""}
$ProtectedSettings = @{"workspaceKey" = ""}

#Fetch Resource Group details 
$ResourceGroups = Get-AzResourceGroup 

#Choice to proceed with Monitoring Agent Installation on Virtual Machines
$title    = 'Microsoft Monitoring Agent'
$question01 = 'Do you wnat to perform Scan for Log Analytics agent virtual machine extensions in '+$SubscriptionName+' Subscription'
$question02 = 'Are you sure you want to proceed with Monitoring Agent Installation on Virtual Machine?'

$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

$decision01 = $Host.UI.PromptForChoice($title, $question01, $choices, 1)
$decision01 = $Host.UI.PromptForChoice($title, $question01, $choices, 1)
if ($decision01 -eq 0) {
    
#Perform Scan for Log Analytics agent virtual machine extension
    foreach ($ResourceGroup in $ResourceGroups){

        $vms = Get-AzVM -ResourceGroupName $($ResourceGroup.ResourceGroupName)

        foreach ($vm in $vms){
            
                #Install Monitoring Agent on Virtual Machines
                $vmExtnCheck = Get-AzVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName | Select-Object -ExpandProperty Extensions
                
                if ($vm.StorageProfile.OsDisk.OsType -eq 'Windows') {

                    Write-Host 'Selected Virtual Machine '$vm.Name' is a Windows Virtual Machine'

                    if ($vmExtnCheck.VirtualMachineExtensionType -cne 'MicrosoftMonitoringAgent') {

                        Write-Host 'Selected Virtual Machine '$vm.Name' does not have monitoring agent installed ' -ForegroundColor Yellow
                        $decision02 = $Host.UI.PromptForChoice($title, $question02, $choices, 1)
                        if ($decision02 -eq 0) {
                            
                            #Check Virtual Machine Status and proceed if it's Running
                            $vmStatsChk = (Get-AzVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -Status).Statuses
                            if ($vmStatsChk[1].DisplayStatus -ceq 'VM running') {

                                Write-Host 'Virtual Machine '$vm.Name' Agent installation in progress... ' -ForegroundColor Yellow

                                Set-AzVMExtension -ExtensionName "MicrosoftMonitoringAgent" `
                                -ResourceGroupName $vm.ResourceGroupName `
                                -VMName $vm.Name `
                                -Publisher "Microsoft.EnterpriseCloud.Monitoring" `
                                -ExtensionType "MicrosoftMonitoringAgent" `
                                -TypeHandlerVersion 1.0 `
                                -Settings $PublicSettings `
                                -ProtectedSettings $ProtectedSettings `
                                -Location "Southeastasia"

                                Write-Host 'Virtual Machine '$vm.Name' Monitoring Agent installation in Completed... ' -ForegroundColor Green
                                
                            }else {
                                Write-Host "Virtual Machine $($vm.Name) is in Stopped State. Please proceed to Manually Start from Azure Portal " -ForegroundColor Red
                            }

                            
                        }else {
                            Write-Host "Monitoring Agent Installation on Windows Virtual Machine Skipped" -ForegroundColor Red
                        }

                        
                    }else {
                        Write-Host 'Selected Virtual Machine '$vm.Name' has monitoring agent installed' -ForegroundColor Green
                    }
                    
                }
                elseif ($vm.StorageProfile.OsDisk.OsType -eq 'Linux') {

                    Write-Host 'Selected Virtual Machine '$vm.Name' is a Linux Virtual Machine'
                    if ($vmExtnCheck.VirtualMachineExtensionType -ne 'MicrosoftMonitoringAgent') {

                        Write-Host 'Selected Virtual Machine '$vm.Name' does not have monitoring agent installed ' -ForegroundColor Yellow
                        $decision02 = $Host.UI.PromptForChoice($title, $question02, $choices, 1)
                        if ($decision02 -eq 0) {

                            #Check Virtual Machine Status and proceed if it's Running
                            $vmStatsChk = (Get-AzVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -Status).Statuses
                            if ($vmStatsChk[1].DisplayStatus -ceq 'VM running') {

                                Write-Host 'Virtual Machine '$vm.Name' Agent installation in progress... ' -ForegroundColor Yellow

                                Set-AzVMExtension -ExtensionName "MicrosoftMonitoringAgent" `
                                -ResourceGroupName $vm.ResourceGroupName `
                                -VMName $vm.Name `
                                -Publisher "Microsoft.EnterpriseCloud.Monitoring" `
                                -ExtensionType "MicrosoftMonitoringAgent" `
                                -TypeHandlerVersion 1.0 `
                                -Settings $PublicSettings `
                                -ProtectedSettings $ProtectedSettings `
                                -Location "Southeastasia"

                                Write-Host 'Virtual Machine '$vm.Name' Monitoring Agent installation in Completed... ' -ForegroundColor Green
                                
                            }else {
                                Write-Host "Virtual Machine $($vm.Name) is in Stopped State. Please proceed to Manually Start from Azure Portal " -ForegroundColor Red
                            }


                            
                        }else {
                            Write-Host "Monitoring Agent Installation on Linux Virtual Machine Skipped" -ForegroundColor Red
                        }
                        
                    }else {
                        Write-Host 'Selected Virtual Machine '$vm.Name' has monitoring agent installed' -ForegroundColor Green
                    }
                    
                }
                else {
                    Write-Host 'Selected Virtual Machine '$vm.Name' has unknown Operating System' -ForegroundColor Red
                }

            


                    
            
        }

    }

} else {
    
    Write-Host "Existing Agent scan process... " -ForegroundColor DarkBlue
}
