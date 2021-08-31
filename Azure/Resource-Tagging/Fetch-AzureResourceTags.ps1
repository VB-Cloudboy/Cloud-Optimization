#===================================================================================
# Created by       : Vijay Borkar [VB-Cloudboy --> https://github.com/VB-Cloudboy]
# Version          : 0.1 | Setting up Active Directory Domain Services 
#===================================================================================

$subscriptionName = "cloudboy-sandbox"

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
    
    # Fetch Resource Group & Resources Tagging details 
    $ResourceGroups = Get-AzResourceGroup   

    $ResGrpResults = @()
    $ResoureResults = @()
    
    foreach ($ResourceGroup in $ResourceGroups) {
        New-Item -ItemType File -Path "$FolderPath\$($ResourceGroup.ResourceGroupName).csv" -Force
        $RGTagsAsString = ""
        $RGTags = $ResourceGroup.Tags

        if ($null -ne $RGTags) {
            $RGTags.GetEnumerator() | ForEach-Object { $RGTagsAsString += $_.Key + ":" + $_.Value + ";" + "`n"}
        } else {
                $RGTagsAsString = "NUll"
            }
        

        $RGdetails = @{
            ResourceGroup = $ResourceGroup.ResourceGroupName
            Tags = $RGTagsAsString
        }

        $ResGrpResults += New-Object PSObject -Property $RGdetails
        $ResGrpResults | Select-Object -Property ResourceGroup, Tags | Export-Csv "$FolderPath\$($ResourceGroup.ResourceGroupName).csv" -NoTypeInformation
        Start-Sleep -Seconds 3
        Clear-Variable RGTagsAsString
        Clear-Variable ResGrpResults

        # Fetch Resource Tagging Details in each resource group

        $Resources = Get-AzResource -ResourceGroupName ($ResourceGroup).ResourceGroupName

        foreach ($Resource in $Resources){

            Write-Host 'Processing ' $Resource.Name -ForegroundColor Green
            New-Item -ItemType File -Path "$FolderPath\$($Resource.Name).csv" -Force
            $ResourceTagsAsString = ""
            $ResourceTags = $Resource.Tags

            if ($null -ne $ResourceTags) {
                $ResourceTags.GetEnumerator() | ForEach-Object { $ResourceTagsAsString += $_.Key + ":" + $_.Value + ";"+ "`n"}
            } else {
                $ResourceTagsAsString = "NUll"
            }

            $ResourceDetails = @{
                ResourceGroup   = $ResourceGroup.ResourceGroupName
                Resource        = $Resource.Name
                Tags            = $ResourceTagsAsString
            }

            $ResoureResults += New-Object PSObject -Property $ResourceDetails
            $ResoureResults | Select-Object -Property ResourceGroup, Resource, Tags | Export-Csv "$FolderPath\$($Resource.Name).csv" -NoTypeInformation
            Start-Sleep -Seconds 3
            Clear-Variable ResourceTagsAsString
            Clear-Variable ResoureResults

        }


        
  
    }
