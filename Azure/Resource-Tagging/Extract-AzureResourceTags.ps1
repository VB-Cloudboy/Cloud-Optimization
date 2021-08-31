#===================================================================================
# Created by       : Vijay Borkar [VB-Cloudboy --> https://github.com/VB-Cloudboy]
# Version          : 0.1 | Extract Azure Resource Tag with Functional Logic 
#===================================================================================

#---------DECLARE VARIABLES------------------------------------#
$Subscription = Get-AzSubscription
$day = Get-Date -Format " ddMMMyyyy"
$tagPath = "C:\mytempfolder\"+"$day-Tag-Details.csv"
$tagFolderPath = "C:\mytempfolder\"

#---------DEFINE FUNCTION------------------------------------#
function Get-ResourceTag {

    foreach ($subs in $bnsSubscription) {
        Select-AzSubscription -SubscriptionName $subs.Name | Out-Null 
        Write-Host 'The selected Subscription is' ($subs).Name
        New-Item -ItemType file -Path "$tagFolderPath\$($subs.Name).csv" -Force
        $resource_groups = Get-AzResourceGroup
        $resource_groups_details = Get-AzResourceGroup | Sort-Location ResourceGroupName | Format-Table -GroupBy Location ResourceGroupName,ProvisioningState,Tags
        Write-Host 'The selected Resource Group is' ($resource_groups).Name 'and the tag information as follows'
        #$resource_groups_details
        $resource_groups | Select-Object ResourceGroupName,Tags | Export-CSV -Path "$tagFolderPath\$($subs.Name).csv"  -Append


        $OutputFile = @()
        foreach($rg in $resource_groups){
            $azure_resources = Get-AzResource -ResourceGroupName $rg.ResourceGroupName

            $TestTags = $Resource.Tags.GetEnumerator()

            foreach($r in $azure_resources){

                Write-Host 'The selected resource is' ($r).Name 'and the information as follows'
                
                $RGHT = New-Object "System.Collections.Generic.List[System.Object]"
                $RGHT.Add("RGName",$r.ResourceGroupName)
                $RGHT.Add("ResourceName",$r.name)
                $RGHT.Add("Location",$r.Location)
                $RGHT.Add("Id",$r.ResourceId)
                $RGHT.Add("ResourceType",$r.ResourceType)
                $RGHT.Add("ResourceTags",$r.Tags)

                $OutputFile += New-Object psobject -Property $RGHT

                $OutputFile | Export-Csv -Path "C:\mytempfolder\test22.csv" -append -NoClobber -NoTypeInformation -Encoding UTF8 -Force

           
            }
        }
    }

    
}

#---------cALL FUNCTION------------------------------------#


Get-ResourceTag
