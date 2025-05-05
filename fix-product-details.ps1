# PowerShell script to fix paths in all product detail pages
$productDetailsDir = ".\Products\product-details"
$files = Get-ChildItem -Path $productDetailsDir -Filter "*.html"

foreach ($file in $files) {
    Write-Host "Processing $($file.Name)..."
    
    # Read the content of the file
    $content = Get-Content -Path $file.FullName -Raw
    
    # Fix CSS paths (convert absolute paths to relative)
    $content = $content -replace '<link rel="stylesheet" href="/Styles/style.css">', '<link rel="stylesheet" href="../../Styles/style.css">'
    $content = $content -replace '<link rel="stylesheet" href="/Styles/style4.css">', '<link rel="stylesheet" href="../../Styles/style4.css">'
    
    # Add style5.css reference if it doesn't exist
    if (-not ($content -match '<link rel="stylesheet" href="../../Styles/style5.css">')) {
        $content = $content -replace '(</head>)', '<link rel="stylesheet" href="../../Styles/style5.css">${1}'
    }
    
    # Add backToTop.js script if it doesn't exist
    if (-not ($content -match '<script src="../../js/backToTop.js"')) {
        $content = $content -replace '(</head>)', '<script src="../../js/backToTop.js" defer></script>${1}'
    }
    
    # Fix image paths for the Siblings logo
    $content = $content -replace 'src="/images/Contact_logos/Siblings_logo.png"', 'src="../../images/Contact_logos/Siblings_logo.png"'
    
    # Fix other absolute paths that might exist
    $content = $content -replace 'src="/images/', 'src="../../images/'
    $content = $content -replace 'href="/Styles/', 'href="../../Styles/'
    $content = $content -replace 'href="/js/', 'href="../../js/'
    $content = $content -replace 'href="/Assets/', 'href="../../Assets/'
    
    # Add the middle section with Places to find us button if missing
    if (-not ($content -match '<div class="footer-middle"')) {
        $footerMiddleSection = @"
      </div>

      <div class="footer-middle" style="text-align: center; align-self: center;">
        <a href="../Places.html" class="availability-btn" style="display: inline-block; margin-top: 10px;">Places to find us</a>
      </div>

      <div class="help">
"@
        $content = $content -replace '(<div class="brand-footer">.*?</div>\s*</div>)\s*<div class="help">', "${1}${footerMiddleSection}"
    }
    
    # Save the updated content back to the file
    $content | Set-Content -Path $file.FullName -NoNewline
    
    Write-Host "$($file.Name) updated successfully"
}

Write-Host "All product detail pages updated successfully!"