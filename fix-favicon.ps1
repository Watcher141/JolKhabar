Write-Host "Testing favicon paths..."

# Test favicon files
$faviconFiles = @(
    "favicon.ico",
    "favicon-16x16.png",
    "favicon-32x32.png",
    "apple-touch-icon.png",
    "android-chrome-192x192.png",
    "android-chrome-512x512.png",
    "site.webmanifest"
)

$faviconDir = "c:\GitHub\JolKhabar\favicon"

foreach ($file in $faviconFiles) {
    $fullPath = Join-Path $faviconDir $file
    if (Test-Path $fullPath) {
        Write-Host "✅ Found: $file"
    } else {
        Write-Host "❌ Missing: $file"
    }
}

# Update HTML files with correct favicon links
Write-Host "`nUpdating favicon links in HTML files..."

$htmlFiles = Get-ChildItem -Path "c:\GitHub\JolKhabar" -Filter "*.html" -Recurse

foreach ($file in $htmlFiles) {
    $content = Get-Content -Path $file.FullName -Raw
    $relativePath = $file.Directory.FullName.Replace("c:\GitHub\JolKhabar", "").Replace("\", "/")
    if ($relativePath) {
        $faviconPath = "../" * ($relativePath.Split("/").Length - 1) + "favicon"
    } else {
        $faviconPath = "./favicon"
    }
    
    # Remove existing favicon links
    $content = $content -replace '<link rel="(icon|apple-touch-icon|manifest|mask-icon)".*?>\s*', ''
    
    # Add new favicon links with correct paths
    $faviconLinks = @"
    <!-- Favicon -->
    <link rel="apple-touch-icon" sizes="180x180" href="$faviconPath/apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" href="$faviconPath/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="$faviconPath/favicon-16x16.png">
    <link rel="manifest" href="$faviconPath/site.webmanifest">
    <link rel="icon" href="$faviconPath/favicon.ico">
    <meta name="msapplication-TileColor" content="#f05a28">
    <meta name="theme-color" content="#ffffff">
    
"@
    
    # Insert favicon links after the canonical link
    if ($content -match '<link rel="canonical".*?>') {
        $content = $content -replace '(<link rel="canonical".*?>)\s*', "`$1`n`n$faviconLinks"
    } else {
        $content = $content -replace '<head>', "<head>`n$faviconLinks"
    }
    
    Set-Content -Path $file.FullName -Value $content -NoNewline
    Write-Host "Updated favicon links in: $($file.Name)"
}

Write-Host "`nFavicon update complete!"
