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

Write-Host "Adding social share buttons to all product detail pages..."

# Get all product detail HTML files
$productDetailPages = Get-ChildItem -Path "c:\GitHub\JolKhabar\Products\product-details\*.html" -File

foreach ($page in $productDetailPages) {
    Write-Host "Processing $($page.Name)..."
    
    # Read the file content
    $content = Get-Content -Path $page.FullName -Raw
    
    # Get product name for sharing
    $productName = $page.BaseName.ToUpper()
    $productName = $productName -replace "-", " "
    
    # Check if the file already has the share button
    if ($content -match '<div class="menu">') {
        Write-Host "Social share button already exists in $($page.Name), skipping..."
        continue
    }
    
    # Step 1: Add the necessary stylesheet and script links to the head section if not present
    if (-not ($content -match '<link rel="stylesheet" href="../../Styles/share.css">')) {
        $headPattern = '(<link rel="stylesheet" href="../../Styles/style5.css">)'
        $headReplacement = '$1
  <link rel="stylesheet" href="../../Styles/share.css">
  <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
  <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
  <script src="../../js/Share.js" defer></script>'
        
        $content = $content -replace $headPattern, $headReplacement
    }
    
    # Step 2: Find where to add the button container if it doesn't exist
    if (-not ($content -match '<div class="button-container">')) {
        # Add button container before the highlights section
        $descPattern = '(<p class="description">.*?</p>)\s*<div class="highlights">'
        $buttonContainer = '$1
        <div class="button-container">
          <a href="../Places.html" class="availability-btn">Check Availability</a>
        </div>
        
        <div class="highlights">'
        
        $content = $content -replace $descPattern, $buttonContainer
    }
    
    # Step 3: Add the share button to the button container
    $buttonPattern = '(<div class="button-container">.*?<a href="../Places\.html" class="availability-btn">Check Availability</a>)'
    $shareButton = '$1
          
          <!-- Social Share Menu -->
          <div class="menu">
            <div class="toggle">
              <ion-icon name="share-social"></ion-icon>
            </div>
            
            <li style="--i:0;--clr:#1877f2">
              <a href="javascript:void(0);" onclick="shareOnFacebook()"><ion-icon name="logo-facebook"></ion-icon></a>
            </li>
            <li style="--i:1;--clr:#25d366">
              <a href="javascript:void(0);" onclick="shareOnWhatsapp()"><ion-icon name="logo-whatsapp"></ion-icon></a>
            </li>
            <li style="--i:2;--clr:#1da1f2">
              <a href="javascript:void(0);" onclick="shareOnTwitter()"><ion-icon name="logo-twitter"></ion-icon></a>
            </li>
            <li style="--i:3;--clr:#FF5733">
              <a href="mailto:?subject=Check out this amazing product from JolKhabar!&body=I found this great product on JolKhabar: ' + $productName + '. Check it out here: " + window.location.href><ion-icon name="mail"></ion-icon></a>
            </li>
            <li style="--i:4;--clr:#0a66c2">
              <a href="javascript:void(0);" onclick="shareOnLinkedIn()"><ion-icon name="logo-linkedin"></ion-icon></a>
            </li>
          </div>'
    
    $content = $content -replace $buttonPattern, $shareButton
    
    # Step 4: Add sharing functions before the closing body tag if they don't exist
    if (-not ($content -match 'function shareOnFacebook')) {
        $bodyEndPattern = '</body>'
        $sharingFunctions = '
  <script>
    // Social sharing functions
    function shareOnFacebook() {
      const url = encodeURIComponent(window.location.href);
      const title = encodeURIComponent("Check out this amazing JolKhabar product - ' + $productName + '");
      window.open(`https://www.facebook.com/sharer/sharer.php?u=${url}&quote=${title}`, "_blank");
    }

    function shareOnWhatsapp() {
      const url = encodeURIComponent(window.location.href);
      const text = encodeURIComponent("Check out this amazing JolKhabar product - ' + $productName + ': ");
      window.open(`https://wa.me/?text=${text}${url}`, "_blank");
    }

    function shareOnTwitter() {
      const url = encodeURIComponent(window.location.href);
      const text = encodeURIComponent("Check out this amazing JolKhabar product - ' + $productName + '");
      window.open(`https://twitter.com/intent/tweet?url=${url}&text=${text}`, "_blank");
    }

    function shareOnLinkedIn() {
      const url = encodeURIComponent(window.location.href);
      const title = encodeURIComponent("Check out this amazing JolKhabar product - ' + $productName + '");
      window.open(`https://www.linkedin.com/sharing/share-offsite/?url=${url}`, "_blank");
    }
  </script>
</body>'
        
        $content = $content -replace $bodyEndPattern, $sharingFunctions
    }
    
    # Save the modified content back to the file
    Set-Content -Path $page.FullName -Value $content -NoNewline
    Write-Host "Added social share button to $($page.Name)"
}

Write-Host "Finished adding social share buttons to all product detail pages!"