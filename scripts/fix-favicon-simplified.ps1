Write-Host "Applying simplified favicon implementation..."

$rootPath = "c:\GitHub\JolKhabar"
$htmlFiles = Get-ChildItem -Path $rootPath -Filter "*.html" -Recurse

foreach ($file in $htmlFiles) {
    Write-Host "Processing: $($file.Name)"
    
    # Calculate relative path to root based on file location
    $relativePath = $file.DirectoryName.Replace($rootPath, "").Trim("\")
    $upLevels = if ($relativePath) { ($relativePath.Split("\").Length) } else { 0 }
    $pathToRoot = "../" * $upLevels
    
    $content = Get-Content -Path $file.FullName -Raw

    # Update Content-Security-Policy to allow favicon
    if ($content -match '<meta http-equiv="Content-Security-Policy"[^>]*>') {
        $content = $content -replace '(<meta http-equiv="Content-Security-Policy" content=")[^"]*(")', '$1default-src ''self''; script-src ''self'' https://www.googletagmanager.com ''unsafe-inline''; style-src ''self'' ''unsafe-inline''; img-src ''self'' data: https:; font-src ''self''; connect-src ''self'' https://www.google-analytics.com;$2'
    }
    
    # Simplified favicon implementation
    $newFaviconLinks = @"
    <!-- Favicon -->
    <link rel="shortcut icon" href="$($pathToRoot)favicon.ico" type="image/x-icon">
    <link rel="icon" href="$($pathToRoot)favicon.ico" type="image/x-icon">
    <link rel="apple-touch-icon" sizes="180x180" href="$($pathToRoot)favicon/apple-touch-icon.png">
    
"@

    # Replace existing favicon section or add new one after charset
    if ($content -match '<!-- Favicon -->[\s\S]*?(<link[^>]*>[\s\S]*?){1,7}') {
        $content = $content -replace '<!-- Favicon -->[\s\S]*?(<link[^>]*>[\s\S]*?){1,7}', $newFaviconLinks.Trim()
    } else {
        $content = $content -replace '<meta charset="UTF-8"[^>]*>', "`$&`n$newFaviconLinks"
    }
    
    Set-Content -Path $file.FullName -Value $content -NoNewline -Encoding UTF8
    Write-Host "Updated favicon links in: $($file.Name)"
}

Write-Host "`nSimplified favicon implementation complete! Please:"
Write-Host "1. Clear your browser cache"
Write-Host "2. Close and reopen your browser"
Write-Host "3. Try loading the page again"
