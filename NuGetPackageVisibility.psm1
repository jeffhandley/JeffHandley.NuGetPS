function Set-NuGetPackageVisibility {
	<#
	.SYNOPSIS
	Sets a package's visibility within the NuGet gallery
	.DESCRIPTION
	Hide (unlist) a package from the gallery or show (list) a package on the gallery.
	.EXAMPLE
	Set-PackageVisibility -action hide -packageId MyAwesomePackage -packageVersion 2.0.0.0 -apiKey 00000000-0000-0000-0000-000000000000 -galleryUrl https://nuget.org
	.EXAMPLE
	Set-PackageVisibility -action show -packageId MyAwesomePackage -packageVersion 2.0.0.0 -apiKey 00000000-0000-0000-0000-000000000000 -galleryUrl https://preview.nuget.org
	.PARAMETER action
	The action to take: hide or show
	.PARAMETER packageId
	The Id of the package to hide/show
	.PARAMETER packageVersion
	The Version of the package to hide/show
	.PARAMETER galleryUrl
	The NuGet gallery Url to connect to.  By default, https://nuget.org
	#>

	param(
		$action,
		$packageId,
		$packageVersion,
		$apiKey,
		$galleryUrl = "https://nuget.org"
  )

  if ($action -eq $null) { throw "Parameter 'action' was not specified" }
  if ($packageId -eq $null) { throw "Parameter 'packageId' was not specified" }
  if ($packageVersion -eq $null) { throw "Parameter 'packageVersion' was not specified" }
  if ($apiKey -eq $null) { throw "Parameter 'apiKey' was not specified" }
  if ($galleryUrl -eq $null) { throw "Parameter 'galleryUrl' was not specified" }

  If ($action -match "hide") {
  	$method = "DELETE"
  	$message = "hidden (unlisted)"
  }
  ElseIf ($action -match "show") {
  	$method = "POST"
  	$message = "shown (listed)"
  }
  Else {
  	throw "Invalid 'action' parameter value.  Valid values are 'hide' and 'show'."
  }

  $url = "$galleryUrl/api/v2/Package/$packageId/$packageVersion`?apiKey=$apiKey"
  $web = [System.Net.WebRequest]::Create($url)

  $web.Method = $method
  $web.ContentLength = 0

  Write-Host ""
  Write-Host "Submitting the $method request to $url..." -foregroundColor Cyan
  Write-Host ""

  $response = $web.GetResponse()

  If ($response.StatusCode -match "OK") {
  	Write-Host "Package '$packageId' Version '$packageVersion' has been $message." -foregroundColor Green -backgroundColor Black
    Write-Host ""
  }
  Else {
  	Write-Host $response.StatusCode
  }
}

function Hide-NuGetPackage {
  <#
  .SYNOPSIS
  Hides a package from the NuGet gallery
  .DESCRIPTION
  Marks the specified NuGet package as unlisted, hiding it from the gallery.
  .EXAMPLE
  Hide-NuGetPackage -packageId MyAwesomePackage -packageVersion 2.0.0.0 -apiKey 00000000-0000-0000-0000-000000000000 -galleryUrl https://preview.nuget.org
  .PARAMETER packageId
  The Id of the package to hide
  .PARAMETER packageVersion
  The Version of the package to hide
  .PARAMETER galleryUrl
  The NuGet gallery Url to connect to.  By default, https://nuget.org
  #>

  param(
    $packageId,
    $packageVersion,
    $apiKey,
    $galleryUrl = "https://nuget.org"
  )

  Set-NuGetPackageVisibility -action hide -packageId $packageId -packageVersion $packageVersion -apiKey $apiKey -galleryUrl $galleryUrl
}

function Show-NuGetPackage {
  <#
  .SYNOPSIS
  Shows a package on the NuGet gallery, listing an already-published but unlisted package.
  .DESCRIPTION
  Marks the specified NuGet package as listed, showing it on the gallery.
  .EXAMPLE
  Show-NuGetPackage -packageId MyAwesomePackage -packageVersion 2.0.0.0 -apiKey 00000000-0000-0000-0000-000000000000 -galleryUrl https://preview.nuget.org
  .PARAMETER packageId
  The Id of the package to show
  .PARAMETER packageVersion
  The Version of the package to show
  .PARAMETER galleryUrl
  The NuGet gallery Url to connect to.  By default, https://nuget.org
  #>

  param(
    $packageId,
    $packageVersion,
    $apiKey,
    $galleryUrl = "https://nuget.org"
  )

  Set-NuGetPackageVisibility -action show -packageId $packageId -packageVersion $packageVersion -apiKey $apiKey -galleryUrl $galleryUrl
}