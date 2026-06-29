param(
    [string]$ConfigPath = "C:\IT_Scripts\cleanup_config.json",
    [string]$LogFile    = "C:\IT_Scripts\Cleanup_Log.txt"
)

$CurrentVersion = 99

# ===========================================================
#  SAVANI IT CLEANUP V99 - KILL SWITCH (PHE VO CONG)
#  - Phien ban nay duoc day xuong de vo hieu hoa script.
#  - Chi giu lai duy nhat chuc nang bao cao lan cuoi.
# ===========================================================

try {
    # Ép dùng TLS 1.2 để gửi được Telegram
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    # 1. Đọc ChatID từ Config
    $chatID = "-5209519013" # Fallback cứng nhóm của sếp lỡ file config lỗi
    if (Test-Path $ConfigPath -ErrorAction SilentlyContinue) {
        $config = Get-Content $ConfigPath -Raw | ConvertFrom-Json
        if ($null -ne $config.Telegram.ChatID) { $chatID = $config.Telegram.ChatID }
    }

    # 2. Giải mã Token từ ổ C:
    $botToken = $null
    $encFile = "C:\IT_Scripts\.tg_token.enc"
    if (Test-Path $encFile) {
        $aesKey = [byte[]](1..32)
        $encryptedData = Get-Content $encFile -Raw
        $secureString = ConvertTo-SecureString $encryptedData -Key $aesKey
        $botToken = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureString))
    }

    # 3. Gửi tin nhắn "Trăng trối" lần cuối
    if (-not [string]::IsNullOrEmpty($botToken)) {
        $msg = "🔴 <b>KILL-SWITCH KÍCH HOẠT</b>`n" +
               "Máy POS: <b>$($env:COMPUTERNAME)</b>`n" +
               "Trạng thái: Đã hoàn thành (V99).`n" +
               "Từ giờ máy này đã bị ngắt Auto-Update và dọn rác vĩnh viễn.`n" +
               "Thời gian: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

        $url  = "https://api.telegram.org/bot$botToken/sendMessage"
        $body = @{ chat_id = $chatID; text = $msg; parse_mode = "HTML" }
        
        # Bắn tin nhắn (Timeout nhanh 10s để đỡ treo máy)
        Invoke-RestMethod -Uri $url -Method Post -Body $body -TimeoutSec 10 -ErrorAction SilentlyContinue | Out-Null
    }
} catch { 
    # Có lỗi mạng hay gì cũng im lặng tự sát
}

# Tắt điện
exit
