# SAVANI IT - Script Dọn Rác & Tối Ưu Hệ Thống Tự Động (Bản V11) iwr -useb https://christitus.com/win | iex

# 🚀 SAVANI IT CLEANUP - ZERO-AGENT POS MANAGER

Hệ thống dọn rác tự động, quản lý tập trung và báo cáo từ xa dành cho hệ thống máy POS thu ngân tại hơn 100 chi nhánh bán hàng của Savani. Kiến trúc **Zero-Agent** hoạt động hoàn toàn dựa trên PowerShell thuần của Windows, siêu nhẹ và không gây ảnh hưởng đến hiệu năng máy tính.

**Phiên bản hiện tại:** V16 Final (Production Ready)  
**Tác giả:** Phạm Hồng Đại (Savani IT Operations)

---

## 🌟 TÍNH NĂNG NỔI BẬT

* **Kiến trúc Zero-Agent:** Không cần cài đặt phần mềm bên thứ 3. Hoạt động ngầm thông qua Windows Task Scheduler.
* **Auto-Update Toàn diện:** 
  * Luôn tự động kéo cấu hình `cleanup_config.json` mới nhất từ GitHub mỗi khi chạy.
  * Tự động so sánh phiên bản (Version Control) và cập nhật kịch bản lệnh `.ps1` khi có bản mới trên Server.
* **Offline Ready:** Hoạt động hoàn hảo ngay cả khi mất mạng internet (Sử dụng cấu hình local cache).
* **Smart Cleanup (Dọn rác thông minh):**
  * Xóa rác hệ thống (System Temp, User Temp).
  * Làm sạch sâu Zalo Cache, ZaloDownloads, Thumbnails (Không làm mất tin nhắn hoặc Database Zalo).
  * Dọn dẹp thư mục Downloads (Trừ các file công việc như `.pdf`, `.xlsx`, `.docx`,...).
  * Tự động dọn Thùng rác (Recycle Bin) cho các file cũ hơn 30 ngày.
* **Aggressive Mode (Chế độ cấp cứu):** Tự động chuyển đổi sang ngưỡng xóa khắt khe hơn khi phân vùng ổ C: bị đầy.
* **Báo cáo Telegram Real-time:** Gửi báo cáo chi tiết về mức dung lượng đã dọn, tình trạng ổ cứng và các lỗi phát sinh trực tiếp về nhóm Telegram của phòng IT.
* **Bảo mật Token:** Telegram Bot Token được mã hóa AES-256 nội bộ trên từng máy, không lưu bản rõ (plaintext).

---

## ⚙️ YÊU CẦU HỆ THỐNG

* **OS:** Windows 10 / Windows 11 (Có hỗ trợ PowerShell 5.1 trở lên).
* **Môi trường:** Đã cấu hình PowerShell Execution Policy ở mức `Bypass` hoặc `RemoteSigned`.
* **Kết nối:** Cho phép truy cập ra ngoài internet (Truy cập `raw.githubusercontent.com` và `api.telegram.org`).

---

## 📂 CẤU TRÚC THƯ MỤC TRIỂN KHAI

Hệ thống được thiết kế để nằm gọn trong thư mục gốc `C:\IT_Scripts\`:

```text
C:\IT_Scripts\
├── SavaniCleanup_v9.ps1      # Kịch bản PowerShell thực thi chính
├── cleanup_config.json       # File cấu hình trung tâm (Đồng bộ từ GitHub)
├── .tg_token.enc             # File chứa Telegram Bot Token đã mã hóa AES
├── Cleanup_Log.txt           # File Log cục bộ ghi lại tiến trình
└── Update_DonRac.bat         # File kích hoạt khẩn cấp/Deploy ban đầu
```

---

## 🛠️ HƯỚNG DẪN CẤU HÌNH (cleanup_config.json)

Quản trị viên chỉ cần chỉnh sửa file `cleanup_config.json` trên kho GitHub. Hàng trăm máy POS sẽ tự động áp dụng thông số mới trong lần chạy tiếp theo.

```json
{
  "Telegram": {
    "Enabled": true,             // Bật/tắt tính năng gửi báo cáo Telegram
    "ChatID": "-5209519013"      // ID của nhóm nhận báo cáo
  },
  "Threshold": {
    "MinFreeGBToRun": 50,        // Bỏ qua dọn rác nếu ổ C: trống nhiều hơn 50GB
    "AggressiveFreeGB": 0        // Bật chế độ "Cấp cứu" nếu ổ C: thấp hơn mức này (0 = Tắt)
  },
  "Days": {
    "Temp": 20,                  // Xóa file tạm cũ hơn 20 ngày
    "Downloads": 300             // Xóa file tải về cũ hơn 300 ngày
  },
  "Paths": {
    "Zalo": ["AppData\\Local\\ZaloPC", "AppData\\Roaming\\ZaloData"]
  },
  "SafeExtensions": [".pdf", ".docx", ".xlsx", ".pptx", ".txt", ".rar", ".zip"], // KHÔNG XÓA các file này
  "JunkFolders": ["Cache", "temp", "Thumbnails", "ChatFiles", "media", "ZaloDownloads"], // Các thư mục ngầm của Zalo cần dọn
  "ExcludeUsers": ["Public", "Default", "Default User", "All Users", "CEO", "Manager"], // Bỏ qua quét trên các User này
  "Options": {
    "DryRun": false,             // True = Chỉ mô phỏng đếm file, False = Xóa thật
    "UseRecycleBin": true,       // Chuyển file Downloads vào Thùng rác thay vì xóa vĩnh viễn
    "CleanWindowsUpdate": true,
    "NotifyUser": true
  }
}
```

---

## 🚀 TRIỂN KHAI VÀ HỒI SINH (DEPLOYS)

Để cài đặt mới cho máy POS hoặc cứu hộ khi hệ thống mất luồng Auto-Update, phòng IT chỉ cần gửi file `Update_DonRac.bat` cho chi nhánh. Nhân viên nháy đúp file `.bat` để kích hoạt:

```bat
@echo off
color 0A
title SAVANI IT - TRIEN KHAI DON RAC

echo DANG DONG BO DU LIEU TU GITHUB...
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $Url = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String('aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2RhaXBoYW0yMDAxL1NWTl9jbGVhbnVwL21haW4vU2F2YW5pQ2xlYW51cF92OS5wczE=')); Invoke-WebRequest -Uri $Url -OutFile 'C:\IT_Scripts\SavaniCleanup_v9.ps1' -UseBasicParsing"

if exist "C:\IT_Scripts\SavaniCleanup_v9.ps1" (
    echo KICH HOAT VA CAP NHAT CAU HINH...
    powershell -ExecutionPolicy Bypass -WindowStyle Hidden -NonInteractive -File "C:\IT_Scripts\SavaniCleanup_v9.ps1"
)
```

---

## 📊 CƠ CHẾ LOGGING VÀ GIÁM SÁT

1. **Local Log:** Hệ thống duy trì một file log liên tục tại `C:\IT_Scripts\Cleanup_Log.txt`. Tự động Rotate (cắt file) khi dung lượng vượt quá 5MB.
2. **Crash Alert:** Nếu kịch bản vướng lỗi Exception nghiêm trọng (Exception Fatal), hệ thống sẽ gửi tin nhắn khẩn cấp có mác `[LOI NGHIEM TRONG]` về Telegram.
3. **Timeout Protection:** Kịch bản bị giới hạn tối đa 10 phút chạy (Mutex & Timeout Timer) nhằm tuyệt đối bảo vệ tài nguyên CPU/Disk IO trong giờ cao điểm bán hàng.
* 8254077622:FlvthtoC5he8Sw-0n-pJeFDtXWO0sJPFA

---
**Savani Operations - Tự động hóa để bứt phá**
