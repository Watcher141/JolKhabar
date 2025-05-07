# PowerShell script to update all product detail pages with a consistent footer
Write-Host "Updating all product detail pages with proper footer content..."

# The consistent footer HTML we want to apply to all pages
$consistentFooter = @'
  <footer>
    <div class="footer-content">
      <div>
        <div class="footer-logos">
          <a href="https://www.facebook.com/amaderjolkhabar" target="_blank" rel="noopener noreferrer">
            <img src="../../facebook-icon.png" alt="Facebook">
          </a>
          <a href="https://www.instagram.com/bangalirjolkhabar?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw%3D%3D" target="_blank" rel="noopener noreferrer">
            <img src="../../instagram-icon.png" alt="Instagram">
          </a>
          <a href="https://www.youtube.com/@Bangalirjolkhabar" target="_blank" rel="noopener noreferrer">
            <img src="../../YoutubeLogo.png" alt="YouTube">
          </a>
        </div>
        <div class="brand-footer">
          <img src="../../images/Contact_logos/Siblings_logo.png" alt="JolKhabar Logo" width="120">
        </div>
      </div>
      <div class="help">
        <strong>Help & Support</strong><br>
        <span>
          <img src="../../images/Contact_logos/Gmap Logo.png" class="contact-icon" alt="Location">
          Kolkata, West Bengal
        </span><br>
        <a href="tel:+919674627460">
          <img src="../../images/Contact_logos/Phone_logo.png" class="contact-icon" alt="Call">
          +91 96746 27460
        </a><br>
        <a href="https://wa.me/919674627460" target="_blank" rel="noopener noreferrer">
          <img src="../../images/Contact_logos/Whatsapp_logo.png" class="contact-icon" alt="WhatsApp">
          +91 96746 27460
        </a><br>
        <a href="mailto:bk24sd@gmail.com">
          <img src="../../images/Contact_logos/Email_logo.png" class="contact-icon" alt="Email">
          bk24sd@gmail.com
        </a><br>
        &copy; 2025 Siblings Exims Pvt. Ltd. All rights reserved.
      </div>
    </div>
  </footer>
'@

# Get all product detail HTML files
$productDetailFiles = Get-ChildItem -Path ".\Products\product-details\*.html" -Recurse

$updateCount = 0
$errorCount = 0

foreach ($file in $productDetailFiles) {
    try {
        $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
        
        # Find where the footer starts and ends
        if ($content -match "(?s)<footer.*?</footer>") {
            $updatedContent = $content -replace "(?s)<footer.*?</footer>", $consistentFooter
            
            # Save the updated content
            $updatedContent | Set-Content -Path $file.FullName -Encoding UTF8 -NoNewline
            Write-Host "Updated footer in $($file.Name)" -ForegroundColor Green
            $updateCount++
        } else {
            # If no footer found, insert it before the closing </body> tag
            $updatedContent = $content -replace "</body>", "$consistentFooter`r`n</body>"
            $updatedContent | Set-Content -Path $file.FullName -Encoding UTF8 -NoNewline
            Write-Host "Added footer to $($file.Name)" -ForegroundColor Yellow
            $updateCount++
        }
    } catch {
        Write-Host "Error updating $($file.Name): $_" -ForegroundColor Red
        $errorCount++
    }
}

Write-Host "`nSummary:"
Write-Host "- Total files processed: $($productDetailFiles.Count)"
Write-Host "- Successfully updated: $updateCount"
Write-Host "- Errors encountered: $errorCount"
Write-Host "Done!"