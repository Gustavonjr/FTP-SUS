# Define o caminho do FTP e da pasta de destino
$ftpUrl = "ftp://ftp2.datasus.gov.br/public/sistemas/dsweb/SIHD/Programas/"
$destinationFolder = "\\e0211\SUS\SISAIH"

# Verifica se a pasta de destino existe, caso contrário, cria-a
if (-not (Test-Path -Path $destinationFolder -PathType Container)) {
    New-Item -ItemType Directory -Path $destinationFolder | Out-Null
}
# Define o caminho do arquivo de log
$logFilePath = "\\e0211\SUS\download_log.txt"

# Define as palavras-chave para filtrar os arquivos
$keywords = "SISAIH01", "VerQRP"

# Cria o objeto de sessão FTP
$ftpRequest = [System.Net.FtpWebRequest]::Create($ftpUrl)
$ftpRequest.Method = [System.Net.WebRequestMethods+Ftp]::ListDirectoryDetails

# Obtém a lista de arquivos no diretório FTP
$ftpResponse = $ftpRequest.GetResponse()
$ftpStream = $ftpResponse.GetResponseStream()
$ftpReader = New-Object IO.StreamReader($ftpStream)
$ftpFiles = @($ftpReader.ReadToEnd() -split "`r`n")

# Verifica se cada arquivo contém pelo menos uma palavra-chave e se já existe na pasta de destino, e faz o download se necessário
foreach ($file in $ftpFiles) {
    $fileDetails = $file.Trim() -split "\s+"
    $fileName = $fileDetails[-1]

    # Verifica se o nome do arquivo contém pelo menos uma palavra-chave
    $match = $keywords | Where-Object { $fileName -like "*$_*" }
    if ($match) {
        $localFilePath = Join-Path -Path $destinationFolder -ChildPath $fileName

        # Verifica se o arquivo já existe na pasta de destino
        if (-not (Test-Path -Path $localFilePath -PathType Leaf)) {
            # Cria o objeto de solicitação de download do arquivo
            $fileUrl = $ftpUrl + $fileName
            $fileDownloadRequest = [System.Net.WebRequest]::Create($fileUrl)
            $fileDownloadRequest.Method = [System.Net.WebRequestMethods+Ftp]::DownloadFile

            # Faz o download do arquivo e salva na pasta de destino
            $fileDownloadResponse = $fileDownloadRequest.GetResponse()
            $fileStream = $fileDownloadResponse.GetResponseStream()
            $fileStreamReader = New-Object IO.StreamReader($fileStream)
            $fileContent = $fileStreamReader.ReadToEnd()
            [System.IO.File]::WriteAllText($localFilePath, $fileContent)
            $fileStreamReader.Close()
            $fileDownloadResponse.Close()

            # Registra a informação do arquivo baixado no log
            $logEntry = "$((Get-Date).ToString('dd-MM-yyyy HH:mm:ss')) - Arquivo baixado: $fileName"
            $logEntry | Out-File -FilePath $logFilePath -Append

            Write-Host "Download concluído: $fileName"
        }
    }
}

Write-Host "Processo de download concluído. O registro de log foi salvo em: $logFilePath"
