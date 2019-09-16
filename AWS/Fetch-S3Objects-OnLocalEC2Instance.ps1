#===================================================================================
# Created by       : Vijay Borkar [VB-Cloudboy --> https://github.com/VB-Cloudboy]
# Version          : 0.1 | Setting up Active Directory Domain Services 
#===================================================================================



# 1.Defining Variables 
$bucketName = "vbcloudboy"
$bucketContainerName = "cloudboy-container01"
$localdirectoryname = "C:\temporary"


# 2.Defining Functions
function Check-S3Availability {

if ( $bucketName -eq "vijay") {
    Write-Host "The bucket named" $bucketName "can be successfully connected and ready to download files locally...!" -ForegroundColor Green
 }else {
    Write-Host "The bucket named" $bucketName "cannot be found please check the availability...!" -ForegroundColor Red
   }
}

function Copy-S3objectlocally {
    if (-not (Test-Path -LiteralPath $localdirectoryname)) {
    
    try {
        New-Item -Path $localdirectoryname -ItemType Directory -ErrorAction Stop | Out-Null #-Force
    }
    catch {
        Write-Error -Message "Unable to create directory '$localdirectoryname'. Error was: $_" -ErrorAction Stop
    }
    "Successfully created directory '$localdirectoryname'."

}
else {
    "Directory already existed"
}
    Read-S3Object -BucketName $bucketName -KeyPrefix $bucketContainerName -Folder $localDirectoryPath
}


# 3. Main Logic 
Get-S3Bucket -BucketName $bucketName  
Check-S3Availability
Copy-S3objectlocally

