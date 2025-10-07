Get-ChildItem -Recurse -Filter "*.html" | Where-Object { 
    (Get-Content $_.FullName -Raw) -notlike "*whatsapp-float.css*" 
} | ForEach-Object {
    $path = $_.FullName.Replace((Get-Location), "").Replace("\", "/")
    $css = if ($path -eq "/index.html") { 
        "./Styles/whatsapp-float.css" 
    } elseif ($path -like "/Products/product-details/*") { 
        "../../Styles/whatsapp-float.css" 
    } elseif ($path -like "/Products/*") { 
        "../Styles/whatsapp-float.css" 
    } else { 
        $null 
    }
    
    if ($css) {
        $content = Get-Content $_.FullName -Raw
        $content = $content -replace '(<link rel="stylesheet" href="[^"]*search\.css"[^>]*>)', "`$1`n    <link rel=`"stylesheet`" href=`"$css`" />"
        Set-Content $_.FullName $content
        Write-Host "Added CSS to: $($_.Name)"
    }
}