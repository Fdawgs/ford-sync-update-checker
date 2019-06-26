$url = 'https://www.serviceseucache.ford.com/api/Sync/v1/getInstallPackages';
$passMessage = 'Already latest version has been installed for this VIN';

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
	Write-Host $_.Exception;
	exit;
}

# Make HTTP GET request to check if Ford SYNC is up to date
$params.'appType' = 'sync';
try {
	$syncRequest = Invoke-RestMethod $url -Headers $headers -Method Get -Body $params;
} catch {
	Write-Host $_.Exception;
	exit;
}

if ($($syncRequest.data.message) -ne $passMessage -or $($mapRequest.data.message) -ne $passMessage) {
	Write-Output 'Ford SYNC status: $($syncRequest.data.message)';
	Write-Output 'Ford Maps status: $($mapRequest.data.message)';
	Read-Host 'Press any key to continue ...';
}
