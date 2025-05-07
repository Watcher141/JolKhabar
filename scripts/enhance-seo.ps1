# SEO Enhancement Script for JolKhabar product-details pages
Write-Host "Starting SEO enhancement for all product detail pages..."

# Get all HTML files in the product-details directory
$productDetailPages = Get-ChildItem -Path "C:\Users\aviru\OneDrive\Documents\GitHub\JolKhabar\Products\product-details\*.html" | Where-Object { $_.Name -ne "coming-soon.html" }

# Base URL for canonical links and Open Graph tags
$baseUrl = "https://jolkhabar.com/Products/product-details/"

foreach ($page in $productDetailPages) {
    Write-Host "Processing $($page.Name)..."
    
    # Read the HTML content
    $content = Get-Content -Path $page.FullName -Raw -Encoding UTF8
    
    # Skip if the page already has enhanced SEO (check for og:title tag)
    if ($content -match '<meta property="og:title"') {
        Write-Host "$($page.Name) already has SEO enhancements. Skipping."
        continue
    }
    
    # Extract the title from the current page
    $titleMatch = [regex]::Match($content, '<title>(.*?)</title>')
    $title = "JolKhabar Product"
    if ($titleMatch.Success) {
        $title = $titleMatch.Groups[1].Value
    }
    
    # Extract product name from h1 or title
    $productNameMatch = [regex]::Match($content, '<h1 class="product-title">(.*?)</h1>')
    $productName = ""
    if ($productNameMatch.Success) {
        $productName = $productNameMatch.Groups[1].Value
    } else {
        $productName = $title.Replace(" - JolKhabar", "")
    }
    
    # Extract description from the page
    $descriptionMatch = [regex]::Match($content, '<p class="description">\s*(.*?)\s*</p>', [System.Text.RegularExpressions.RegexOptions]::Singleline)
    $description = "Authentic Bengali Products by JolKhabar"
    if ($descriptionMatch.Success) {
        $description = $descriptionMatch.Groups[1].Value.Trim()
    }
    
    # Extract image URL if available
    $imageMatch = [regex]::Match($content, '<img id="main-product-image" src="(.*?)"')
    $imageUrl = ""
    if ($imageMatch.Success) {
        $imageUrl = $imageMatch.Groups[1].Value.Replace("../../", "https://jolkhabar.com/")
    }
    
    # Generate keywords based on product name and category
    $categoryMatch = [regex]::Match($content, '<a href="../Product(\d).html">(.*?)</a>')
    $category = "Bengali Products"
    if ($categoryMatch.Success) {
        $category = $categoryMatch.Groups[2].Value
    }
    
    $keywords = "JolKhabar, Bengali, $productName, $category, authentic, traditional, India, Bengal"
    
    # Create SEO meta tags
    $seoTags = @"
  <!-- SEO Enhancements -->
  <meta name="description" content="$description">
  <meta name="keywords" content="$keywords">
  <link rel="canonical" href="$baseUrl$($page.Name)">
  
  <!-- Open Graph Tags for Social Media -->
  <meta property="og:title" content="$title">
  <meta property="og:description" content="$description">
  <meta property="og:type" content="product">
  <meta property="og:url" content="$baseUrl$($page.Name)">
  <meta property="og:site_name" content="JolKhabar">
"@

    # Add image tag if available
    if ($imageUrl) {
        $seoTags += "`n  <meta property=`"og:image`" content=`"$imageUrl`">"
    }
    
    # Create structured data (JSON-LD) for product
    $jsonLd = @"
  
  <!-- Structured Data for Rich Results -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org/",
    "@type": "Product",
    "name": "$productName",
    "description": "$description",
    "brand": {
      "@type": "Brand",
      "name": "JolKhabar"
    },
    "offers": {
      "@type": "Offer",
      "url": "$baseUrl$($page.Name)",
      "priceCurrency": "INR",
      "availability": "https://schema.org/InStock"
    }
  }
  </script>
"@

    # Insert the SEO tags after the title tag
    $updatedContent = $content -replace '(<title>.*?</title>)', "`$1$seoTags"
    
    # Add JSON-LD before the closing head tag
    $updatedContent = $updatedContent -replace '(</head>)', "$jsonLd`n`$1"
    
    # Write the modified content back to the file
    $updatedContent | Set-Content -Path $page.FullName -Encoding UTF8
    
    Write-Host "Enhanced SEO for $($page.Name)"
}

Write-Host "SEO enhancement complete!"