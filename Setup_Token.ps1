param([string]$Token)

# Tao mot khoa AES 256-bit dung chung cho toan bo may POS
$aesKey = [byte[]](1..32) 

$secureString = ConvertTo-SecureString $Token -AsPlainText -Force
$encryptedData = ConvertFrom-SecureString -SecureString $secureString -Key $aesKey

$encryptedData | Out-File "C:\IT_Scripts\.tg_token.enc" -Force
Write-Host "[OK] Da luu va ma hoa Token bang AES 256-bit cho he thong."