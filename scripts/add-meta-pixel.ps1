# Adds Meta Pixel snippet to all .html files under the current directory (recursively).
# Behavior:
# - Skips files that already contain fbq or the pixel id 25363493036620134
# - Creates a backup copy with extension .meta-pixel.bak before modifying
# - Inserts the snippet before the first closing </head> tag (case-insensitive)

$pixel = @'
<!-- Meta Pixel Code -->
<script>
!function(f,b,e,v,n,t,s)
{if(f.fbq)return;n=f.fbq=function(){n.callMethod?
n.callMethod.apply(n,arguments):n.queue.push(arguments)};
if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
n.queue=[];t=b.createElement(e);t.async=!0;
t.src=v;s=b.getElementsByTagName(e)[0];
s.parentNode.insertBefore(t,s)}(window, document,'script',
'https://connect.facebook.net/en_US/fbevents.js');
fbq('init', '25363493036620134');
fbq('track', 'PageView');
</script>
<noscript><img height="1" width="1" style="display:none"
src="https://www.facebook.com/tr?id=25363493036620134&ev=PageView&noscript=1"
/></noscript>
<!-- End Meta Pixel Code -->
'@

$root = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
# If executed from scripts folder, root will be scripts; we want repo root, assume scripts is inside repo root
$repoRoot = Resolve-Path (Join-Path $root "..")
Write-Host "Repo root: $repoRoot"

$files = Get-ChildItem -Path $repoRoot -Include *.html -Recurse -File

if ($files.Count -eq 0) {
    Write-Host "No HTML files found."
    exit 0
}

$pattern = 'fbq\(|25363493036620134'

$modified = @()
$skipped = @()
$noHead = @()

foreach ($f in $files) {
    $path = $f.FullName
    try {
        $content = Get-Content -Raw -LiteralPath $path -ErrorAction Stop
    } catch {
        Write-Warning ("Could not read {0}: {1}" -f $path, $_.Exception.Message)
        continue
    }

    if ($content -match $pattern) {
        $skipped += $path
        continue
    }

    # Find closing </head> (case-insensitive)
    $m = [regex]::Match($content, '(?i)</head>')
    if ($m.Success) {
        # backup
        $bak = "$path.meta-pixel.bak"
        Copy-Item -LiteralPath $path -Destination $bak -Force
        # Insert before first occurrence at match index
        $idx = $m.Index
        $newContent = $content.Substring(0, $idx) + $pixel + $content.Substring($idx)
        Set-Content -LiteralPath $path -Value $newContent -Encoding UTF8
        $modified += $path
        Write-Host "Updated: $path"
    } else {
        $noHead += $path
        Write-Warning ("No </head> found in {0}, skipped" -f $path)
    }
}

Write-Host "--- Summary ---"
Write-Host "Modified files: $($modified.Count)"
if ($modified.Count -gt 0) { $modified | ForEach-Object {Write-Host "  $_"} }
Write-Host "Skipped (already had pixel): $($skipped.Count)"
if ($skipped.Count -gt 0) { $skipped | ForEach-Object {Write-Host "  $_"} }
Write-Host "Files without </head>: $($noHead.Count)"
if ($noHead.Count -gt 0) { $noHead | ForEach-Object {Write-Host "  $_"} }
