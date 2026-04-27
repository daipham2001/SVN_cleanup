@echo off
chcp 437 >nul
color 0B
title SAVANI IT - Cai dat He thong Don dep V9.0

echo.
echo ================================================
echo   SAVANI IT - CAI DAT DON DEP V9.0 (ONLOGON)
echo ================================================
echo.

:: 1. KIEM TRA QUYEN ADMIN
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Chua co quyen Administrator!
    echo         Chuot phai vao file BAT chon "Run as Administrator"
    echo.
    pause
    exit /b 1
)
echo [OK] Quyen Administrator: Co

:: 2. KIEM TRA FILE NGUON
set "srcDir=%~dp0"
set "ps1File=%srcDir%SavaniCleanup_v9.ps1"
set "cfgFile=%srcDir%cleanup_config.json"
set "tokenFile=%srcDir%Setup_Token.ps1"

if not exist "%ps1File%" (
    echo [ERROR] Khong tim thay: SavaniCleanup_v9.ps1
    echo         Dam bao 4 file cung thu muc voi file BAT nay.
    pause
    exit /b 1
)
if not exist "%cfgFile%" (
    echo [ERROR] Khong tim thay: cleanup_config.json
    pause
    exit /b 1
)
if not exist "%tokenFile%" (
    echo [ERROR] Khong tim thay: Setup_Token.ps1
    pause
    exit /b 1
)
echo [OK] Du 4 file nguon

:: 3. TAO THU MUC DICH
set "targetDir=C:\IT_Scripts"
if not exist "%targetDir%" mkdir "%targetDir%"
echo [OK] Thu muc: %targetDir%

:: 4. SAO CHEP FILE
copy /y "%ps1File%"   "%targetDir%\SavaniCleanup_v9.ps1" >nul
copy /y "%cfgFile%"   "%targetDir%\cleanup_config.json"  >nul
copy /y "%tokenFile%" "%targetDir%\Setup_Token.ps1"      >nul
echo [OK] Sao chep file hoan tat

:: 5. NHAP BOT TOKEN - MA HOA DPAPI (BUILT-IN WINDOWS)
echo.
echo ------------------------------------------------
echo  NHAP BOT TOKEN TELEGRAM
echo  Token se duoc ma hoa bang DPAPI cua Windows
echo  Khong can internet, khong can cai them gi
echo ------------------------------------------------
echo.
set "botToken="
set /p "botToken=  Token: "

if "%botToken%"=="" (
    echo [WARN] Bo qua Token. Telegram se khong hoat dong.
    echo        Chay lai Setup_Token.ps1 sau de nhap.
    goto skip_token
)

echo Dang ma hoa va luu Token...
powershell -ExecutionPolicy Bypass -File "%targetDir%\Setup_Token.ps1" -Token "%botToken%"

:skip_token

:: 6. XOA TASK CU
echo.
echo Dang xoa Task Scheduler cu...
schtasks /delete /tn "AutoCleanupSystem"     /f >nul 2>&1
schtasks /delete /tn "SavaniITCleanup"       /f >nul 2>&1
schtasks /delete /tn "SavaniITCleanup_Daily" /f >nul 2>&1
echo [OK] Xoa Task cu hoan tat

:: 7. TAO TASK ONLOGON - DELAY 2 PHUT (DA FIX DAU NGOAC KEP)
:: Su dung \ truoc dau ngoac kep cua phan -File de Windows khong bi cat ngang cau lenh
set "psCmd=powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -NonInteractive -File \"%targetDir%\SavaniCleanup_v9.ps1\""
schtasks /create /tn "SavaniITCleanup" /tr "%psCmd%" /sc onlogon /delay 0002:00 /ru SYSTEM /rl highest /f >nul

schtasks /query /tn "SavaniITCleanup" >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] Task ONLOGON tao thanh cong - delay 2 phut
) else (
    echo [ERROR] Tao Task ONLOGON that bai!
)

:: 8. XOA FILE NHAY CAM
del /f /q "%targetDir%\Setup_Token.ps1" >nul 2>&1
echo [OK] Da xoa Setup_Token.ps1

:: 9. CHAY THU DRY-RUN
echo.
set "runTest="
set /p "runTest=Chay thu DRY-RUN ngay bay gio? (Y/N): "
if /i "%runTest%"=="Y" (
    echo Dang chay DRY-RUN, vui long cho...
    powershell -ExecutionPolicy Bypass -WindowStyle Hidden -NonInteractive -File "%targetDir%\SavaniCleanup_v9.ps1"
    echo [OK] Chay xong! Kiem tra Telegram va log tai:
    echo      %targetDir%\Cleanup_Log.txt
)

:: 10. TONG KET
echo.
echo ================================================
echo   CAI DAT HOAN TAT!
echo ================================================
echo   Script : %targetDir%\SavaniCleanup_v9.ps1
echo   Config : %targetDir%\cleanup_config.json
echo   Log    : %targetDir%\Cleanup_Log.txt
echo ------------------------------------------------
echo   Task: ONLOGON delay 2p - SavaniITCleanup
echo ------------------------------------------------
echo   Trang thai hien tai: DRY-RUN
echo   Khi ok: Sua DryRun: false trong cleanup_config.json
echo ================================================
echo.
pause