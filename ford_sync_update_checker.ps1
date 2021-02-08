Write-Output 'Checking for car updates...';
$url = 'https://www.serviceseucache.ford.com/api/Sync/v2/getInstallPackages';

$headers = @{
	'Upgrade-Insecure-Requests' = 1
};

$params = @{
	locale = 'en_GB';
	vinCode = 'TEST'; # Add own VIN for Ford vehicle here, will error if not valid VIN
	appType = 'map';
};

# Make HTTP GET request to check if Ford Maps is up to date
try {
	$mapRequest = Invoke-RestMethod $url -Method Get -Body $params;
} catch {
	Write-Output $_.Exception;
	exit;
}

# Make HTTP GET request to check if Ford SYNC is up to date
$params.'appType' = 'sync';
try {
    $syncRequest = Invoke-RestMethod $url -Headers $headers -Method Get -Body $params;

} catch {
	Write-Output $_.Exception;
	exit;
}


if ($null -eq $syncRequest.data.message) {
    Write-Output 'Ford SYNC status: Update available';
}
if ($null -eq $mapRequest.data.message) {
    Write-Output 'Ford Maps status: Update available';
}

Read-Host 'Press any key to continue ...';