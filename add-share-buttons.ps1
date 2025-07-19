Write-Host "Adding social share buttons to all product detail pages..."

# Get all product detail HTML files
$productDetailPages = Get-ChildItem -Path "c:\GitHub\JolKhabar\Products\product-details\*.html" -File

foreach ($page in $productDetailPages) {
    Write-Host "Processing $($page.Name)..."
    $content = Get-Content -Path $page.FullName -Raw
    
    # Get product name for sharing
    $productName = $page.BaseName.ToUpper()
    $productName = $productName -replace "-", " "
    
    # Check if social share elements are already added
    if (-not ($content -match '<script src="../../js/Share.js"')) {
        # Add stylesheet and script links if not already present
        $content = $content -replace '<link rel="stylesheet" href="../../Styles/style5.css">', 
            '<link rel="stylesheet" href="../../Styles/style5.css">' + "`r`n" + 
            '  <link rel="stylesheet" href="../../Styles/share.css">' + "`r`n" +
            '  <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>' + "`r`n" +
            '  <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>' + "`r`n" +
            '  <script src="../../js/Share.js" defer></script>'
        
        # Add social share menu
        if ($content -match '<div class="button-container">([\s\S]*?)<\/div>') {
            $buttonContainer = $Matches[0]
            $newButtonContainer = $buttonContainer -replace '<\/div>$', 
                "`r`n" + '          <!-- Social Share Menu -->' + "`r`n" +
                '          <div class="menu">' + "`r`n" +
                '            <div class="toggle">' + "`r`n" +
                '              <ion-icon name="share-social"></ion-icon>' + "`r`n" +
                '            </div>' + "`r`n" +
                '            ' + "`r`n" +
                '            <li style="--i:0;--clr:#1877f2">' + "`r`n" +
                '              <a href="javascript:void(0);" onclick="shareOnFacebook()"><ion-icon name="logo-facebook"></ion-icon></a>' + "`r`n" +
                '            </li>' + "`r`n" +
                '            <li style="--i:1;--clr:#25d366">' + "`r`n" +
                '              <a href="javascript:void(0);" onclick="shareOnWhatsapp()"><ion-icon name="logo-whatsapp"></ion-icon></a>' + "`r`n" +
                '            </li>' + "`r`n" +
                '            <li style="--i:2;--clr:#1da1f2">' + "`r`n" +
                '              <a href="javascript:void(0);" onclick="shareOnTwitter()"><ion-icon name="logo-twitter"></ion-icon></a>' + "`r`n" +
                '            </li>' + "`r`n" +
                '            <li style="--i:3;--clr:#FF5733">' + "`r`n" +
                '              <a href="mailto:?subject=Check out this amazing product from JolKhabar!&body=I found this great product on JolKhabar: ' + $productName + '. Check it out here: " + window.location.href><ion-icon name="mail"></ion-icon></a>' + "`r`n" +
                '            </li>' + "`r`n" +
                '            <li style="--i:4;--clr:#0a66c2">' + "`r`n" +
                '              <a href="javascript:void(0);" onclick="shareOnLinkedIn()"><ion-icon name="logo-linkedin"></ion-icon></a>' + "`r`n" +
                '            </li>' + "`r`n" +
                '          </div>' + "`r`n" +
                '        </div>'
            
            $content = $content -replace [regex]::Escape($buttonContainer), $newButtonContainer
        }
        
        # Add sharing functions to the end of the body
        $sharingFunctions = "`r`n" +
            '  <script>' + "`r`n" +
            '    // Social sharing functions' + "`r`n" +
            '    function shareOnFacebook() {' + "`r`n" +
            '      const url = encodeURIComponent(window.location.href);' + "`r`n" +
            '      const title = encodeURIComponent("Check out this amazing JolKhabar product - ' + $productName + '");' + "`r`n" +
            '      window.open(`https://www.facebook.com/sharer/sharer.php?u=${url}&quote=${title}`, "_blank");' + "`r`n" +
            '    }' + "`r`n" +
            "`r`n" +
            '    function shareOnWhatsapp() {' + "`r`n" +
            '      const url = encodeURIComponent(window.location.href);' + "`r`n" +
            '      const text = encodeURIComponent("Check out this amazing JolKhabar product - ' + $productName + ': ");' + "`r`n" +
            '      window.open(`https://wa.me/?text=${text}${url}`, "_blank");' + "`r`n" +
            '    }' + "`r`n" +
            "`r`n" +
            '    function shareOnTwitter() {' + "`r`n" +
            '      const url = encodeURIComponent(window.location.href);' + "`r`n" +
            '      const text = encodeURIComponent("Check out this amazing JolKhabar product - ' + $productName + '");' + "`r`n" +
            '      window.open(`https://twitter.com/intent/tweet?url=${url}&text=${text}`, "_blank");' + "`r`n" +
            '    }' + "`r`n" +
            "`r`n" +
            '    function shareOnLinkedIn() {' + "`r`n" +
            '      const url = encodeURIComponent(window.location.href);' + "`r`n" +
            '      const title = encodeURIComponent("Check out this amazing JolKhabar product - ' + $productName + '");' + "`r`n" +
            '      window.open(`https://www.linkedin.com/sharing/share-offsite/?url=${url}`, "_blank");' + "`r`n" +
            '    }' + "`r`n" +
            '  </script>' + "`r`n" +
            '</body>'
        
        if ($content -match '</body>') {
            $content = $content -replace '</body>', $sharingFunctions
        }
        
        # Save the modified content back to the file
        Set-Content -Path $page.FullName -Value $content
        Write-Host "Added social share button to $($page.Name)"
    } else {
        Write-Host "Social share button already exists in $($page.Name), skipping..."
    }
}

Write-Host "Finished adding social share buttons to all product detail pages!"