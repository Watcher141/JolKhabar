# PowerShell script to check for outdated dependencies
Write-Host "Checking for outdated dependencies and security issues..."

# Check for any npm packages if they exist
if (Test-Path "package.json") {
    Write-Host "Checking npm dependencies..."
    npm audit
    npm outdated
}

# Check external libraries that are included directly
# List of common JavaScript libraries to check
$libraries = @(
    @{Name="jQuery"; Path="**/jquery*.js"; URL="https://jquery.com/download/"},
    @{Name="Bootstrap"; Path="**/bootstrap*.js"; URL="https://getbootstrap.com/"},
    @{Name="FontAwesome"; Path="**/fontawesome*.js"; URL="https://fontawesome.com/"}
)

Write-Host "`nChecking for external libraries..."
foreach ($lib in $libraries) {
    $found = Get-ChildItem -Path "." -Recurse -Filter $lib.Path -ErrorAction SilentlyContinue
    if ($found) {
        Write-Host "Found $($lib.Name): $($found.FullName)"
        Write-Host "Check for updates at: $($lib.URL)"
    }
}

Write-Host "`nSecurity check complete!"
Write-Host "Remember to regularly update all dependencies to maintain security."