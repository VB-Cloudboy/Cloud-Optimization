#===================================================================================
# Created by       : Vijay Borkar [VB-Cloudboy --> https://github.com/VB-Cloudboy]
# Version          : 0.1 | Audit Orphan Untagged Azure Resources
#===================================================================================


#---------ENTER THE SUBSCRIPTION NAME------------------------------------#
# Populate Information on the accessible azure subscription
(Get-AzSubscription).name
$subscriptionName = "acc-azs-dev-sub01"


#---------------DEFINE FUNCTIONS ------------------------------#
function Audit-OrphanUntaggedResources {

    # Select the subscription as default
    Select-AzSubscription -SubscriptionName $subscriptionName
    Write-Host 'The selected Subscription is' $subscriptionName -ForegroundColor Green 
    Start-Sleep -Seconds 5

    # Create a directory to capture the Information
    $Day        = Get-Date -Format " ddMMMyyyy"
    $DirLocation  = 'C:\'
    $DirName    = "$Day-$subscriptionName"
    $FolderPath = "$DirLocation$DirName"
    
    if (Test-Path -Path $FolderPath ) {
        Write-Host 'The Folder Exist in' $DirLocation -ForegroundColor Green } 
        else {
            Write-Host 'Creating New Folder named' $DirName 'in' $DirLocation -ForegroundColor Yellow
            New-Item -Path $DirLocation -Name $DirName -ItemType "directory"
            Write-Host 'Created Folder' $DirName 'in' $DirLocation 'sSuccessfully' -ForegroundColor Green
        }
    Start-Sleep -Seconds 5
    
    # Create a Resources details for Individual Resource Groups
    $ResourceGroups = Get-AzResourceGroup

    foreach ($ResourceGroup in $ResourceGroups) {
        
        $ResourceDescriptions = New-Object "System.Collections.Generic.List[System.Object]"
        New-Item -ItemType File -Path "$FolderPath\$($ResourceGroup.ResourceGroupName).csv" -Force

        $Resources = Get-AzResource -ResourceGroupName ($ResourceGroup).ResourceGroupName

        foreach ($Resource in $Resources) {
            
            Write-Host 'Processing ' $Resource.Name -ForegroundColor Green

            $ResourceDescription = New-Object -TypeName psobject
            $ResourceDescription | Add-Member -MemberType NoteProperty -Name 'ResourceGroup' -Value $Resourcegroup.ResourceGroupName
            $ResourceDescription | Add-Member -MemberType NoteProperty -Name 'Id' -Value $Resource.Id
            $ResourceDescription | Add-Member -MemberType NoteProperty -Name 'Name' -Value $Resource.Name        
            $ResourceDescription | Add-Member -MemberType NoteProperty -Name 'Type' -Value $Resource.ResourceType

            $BSPgovernanceTags = New-Object "System.Collections.Generic.Dictionary``2[System.String,System.Object]"         
            $BSPgovernanceTags.Add('Tag_Application Name', '')
            $BSPgovernanceTags.Add('Tag_Environment', '')
            $BSPgovernanceTags.Add('Tag_Business Unit', '')
            $BSPgovernanceTags.Add('Tag_Service Owner', '') 
            $BSPgovernanceTags.Add('Tag_Cost Centre', '') 
            $BSPgovernanceTags.Add('Tag_Business Criticality', '') 
            $BSPgovernanceTags.Add('Tag_Operations Commitment', '')


            #Auditing Tags on the Resources

            if ([string]::IsNullOrEmpty($Resource.Tags)) {
                
            } else {
                foreach ($tag in $Resoruce.Tags.GetEnumerator()) {

                    $key = $tag.Key
                    $value = $tag.Value

                    #Tag Name: Application Name
                    if ($key -eq 'Application Name') {
                        $governanceTags['Tag_Application Name'] = $value   
                    }

                    #Tag Name: Environment 
                    if ($key -eq 'Environment') {
                        $governanceTags['Tag_Environment'] = $value   
                    }
                    
                    #Tag Name: Business Unit 
                    if ($key -eq 'Business Unit') {
                        $governanceTags['Tag_Business Unit'] = $value   
                    }

                    #Tag Name: Service Owner 
                    if ($key -eq 'Service Owner') {
                        $governanceTags['Tag_Service Owner'] = $value   
                    }

                    #Tag Name: Cost Centre 
                    if ($key -eq 'Cost Centre') {
                        $governanceTags['Tag_Cost Centre'] = $value   
                    }

                    #Tag Name: Business Criticality 
                    if ($key -eq 'Business Criticality') {
                        $governanceTags['Tag_Business Criticality'] = $value   
                    }

                    #Tag Name: Operations Commitment 
                    if ($key -eq 'Operations Commitment') {
                        $governanceTags['Tag_Operations Commitment'] = $value   
                    }

                }
                
            }

            #Add fields for <Customer> Governance Tags
            foreach ($governanceTag in $governanceTags.GetEnumerator()) {

                $csvFieldHeader = $BSPgovernanceTag.Key
                $csvFieldValue  = $BSPgovernanceTag.Value

                $ResourceDescription | Add-Member -MemberType NoteProperty -Name $csvFieldHeader -Value $csvFieldValue
                
            }

            #Amend All details in Resource Descripton Attribute
            $ResourceDescriptions.Add($ResourceDescription) 


        }

        $ResourceDescriptions | Export-Csv "$FolderPath\$($ResourceGroup.ResourceGroupName).csv" -NoTypeInformation

        
    }


     


}

#---------------CALL FUNCTIONS ------------------------------#

Audit-OrphanUntaggedResources
