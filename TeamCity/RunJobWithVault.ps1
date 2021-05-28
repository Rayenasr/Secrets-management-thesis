#
# Thanks you for Jan Delamper on guiding me on the usage of the script 
# Credits -- Jan Delamper -- Wolters Kluwer
param(
	[Parameter(Mandatory = $true)][string] $TeamCityAccount,
	[Parameter(Mandatory = $true)][string] $TeamCityAccountEncryptedPassword
)

Set-StrictMode -Version latest
$ErrorActionPreference = "Continue"
$pollInterval = 30
$buildState = "unknown"
$buildConfigurationId = "DevelopmentSupport_Playground_SecretManagement_TestJob"
$teamcityHost = "https://teamcity.wkfs-frc.local"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12


function getAuthHeader($user, $pass) {
	$pair = "$($user):$($pass)"
	$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
	$basicAuthValue = "Basic $encodedCreds"

	return $basicAuthValue
}

function startTCJob ($teamcityHost, $user, $pass, $buildConfigurationId, $waitForBuild) {


	Write-Host "Launching TeamCity job with ID $buildConfigurationId"
	$request = "<build><buildType id=""$buildConfigurationId""/></build>"

	Write-Output $request
	# Send POST to TeamCity to trigger the build, store the returned status URL
	[xml]$response = Invoke-WebRequest -UseBasicParsing -Method Post -Uri $($teamcityHost + "/httpAuth/app/rest/buildQueue") -Body $request -Headers @{ Authorization = $(getAuthHeader $user $pass) } -ContentType "application/xml"
	
	# Failed to queue build
	if ($response.build.state -ne "queued") {
		Write-Host "Failed to queue build"
		return;
	}
	else {
		Write-Host $("Build started with ID " + $response.build.id + " // URL: " + $teamcityHost + "/viewLog.html?buildId=" + $response.build.id)
	}

	if ($waitForBuild -eq "true") {

		# Poll the status URL until a success or failure 
		while ($buildState -ne "finished") {

			start-sleep -seconds $pollInterval

			# GET the status
			[xml]$build = Invoke-WebRequest -UseBasicParsing -Method Get -Uri $($teamcityHost + $response.build.href) -Headers @{ Authorization = $(getAuthHeader $user $pass) } -ContentType "application/xml"
			
			$buildState = $build.build.state
			Write-Host $("Build ID " + $response.build.id + " state: " + $buildState)
		}


		write-host $("Build finished with status: " + $build.build.status)

	}


}


startTCJob $teamcityHost $TeamCityAccount $TeamCityAccountEncryptedPassword $buildConfigurationId "true"
