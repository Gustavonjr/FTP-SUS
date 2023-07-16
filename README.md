# Descrição
Este repositório contém scripts em PowerShell para fazer o download de arquivos de diferentes diretórios FTP e salvá-los em pastas de destino locais. Os diretórios FTP e as palavras-chave para filtrar os arquivos podem ser configurados nos scripts individuais.

## Requisitos
- PowerShell 5.1 ou superior

## Como usar
1. Clone este repositório em sua máquina local.
2. Configure os diretórios FTP e as pastas de destino nos scripts individuais, se necessário.
3. Execute os scripts individualmente ou utilize o script em lote fornecido.

### Scripts Individuais
- `APAC.ps1`: Faz o download de arquivos do diretório FTP APAC.
- `BDSIA.ps1`: Faz o download de arquivos do diretório FTP BDSIA.
- `BPA.ps1`: Faz o download de arquivos do diretório FTP BPA.
- `SISAIH.ps1`: Faz o download de arquivos do diretório FTP SISAIH.

### Script em Lote
- `download_files.bat`: Executa os scripts individuais em sequência. Certifique-se de ter o PowerShell instalado e habilitado para execução de scripts. Execute o arquivo batch para iniciar o processo de download.

## Observações
- Os arquivos baixados serão salvos nas pastas de destino especificadas nos scripts.
- O registro de log dos arquivos baixados será salvo no arquivo `download_log.txt` localizado em `\\LocalOndeSeráSalvo\SUS\`.
