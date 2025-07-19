Write-Host "Fixing favicon paths in all HTML files..."

$rootPath = "c:\GitHub\JolKhabar"
$htmlFiles = Get-ChildItem -Path $rootPath -Filter "*.html" -Recurse

foreach ($file in $htmlFiles) {
    Write-Host "Processing: $($file.Name)"
    
    # Calculate relative path to root based on file location
    $relativePath = $file.DirectoryName.Replace($rootPath, "").Trim("\")
    $upLevels = if ($relativePath) { ($relativePath.Split("\").Length) } else { 0 }
    $pathToRoot = "../" * $upLevels
    
    $content = Get-Content -Path $file.FullName -Raw
    
    # Remove existing favicon links and add new ones with correct path
    $newFaviconLinks = @"
    <!-- Favicon -->
    <link rel="apple-touch-icon" sizes="180x180" href="$($pathToRoot)favicon/apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" href="$($pathToRoot)favicon/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="$($pathToRoot)favicon/favicon-16x16.png">
    <link rel="manifest" href="$($pathToRoot)favicon/site.webmanifest">
    <link rel="icon" href="$($pathToRoot)favicon/favicon.ico">
    <meta name="msapplication-TileColor" content="#f05a28">
    <meta name="theme-color" content="#ffffff">
"@

    # Replace existing favicon section or add new one after <head>
    if ($content -match '<!-- Favicon -->[\s\S]*?<meta name="theme-color"[^>]*>') {
        $content = $content -replace '<!-- Favicon -->[\s\S]*?<meta name="theme-color"[^>]*>', $newFaviconLinks.Trim()
    } else {
        $content = $content -replace '<head>', "<head>`n$newFaviconLinks"
    }
    
    Set-Content -Path $file.FullName -Value $content -NoNewline -Encoding UTF8
    Write-Host "Updated favicon links in: $($file.Name)"
}

Write-Host "`nFavicon paths update complete! Please clear your browser cache and refresh to see the changes."
