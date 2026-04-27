# SAVANI IT - AUTOMATED POS CLEANUP SYSTEM (V9.x)

Hệ thống dọn dẹp và tối ưu hóa máy tính POS tự động cho 100+ chi nhánh Savani. 
Giải pháp "Zero-Agent" giúp quản lý tập trung và tự động hóa bảo trì mà không tốn tài nguyên hệ thống.

## 🚀 Tính năng nổi bật

* **Dọn dẹp thông minh (Smart Cleanup):** Tự động xử lý rác Zalo (Media, Cache), Windows Temp, User Temp và Downloads.
* **Cơ chế "Nhường đường" (App-Aware):** Tự động phát hiện và tránh xung đột khi nhân viên đang sử dụng phần mềm bán hàng (KiotViet, Nhanh, Excel...).
* **Chế độ Cấp cứu (Aggressive Mode):** Tự động chuyển sang ngưỡng xóa mạnh hơn khi ổ C: báo động đỏ.
* **Bảo mật & Báo cáo (Secure Reporting):** Gửi báo cáo qua Telegram sau mỗi lần dọn. Token được mã hóa chuẩn AES-256 nội bộ.
* **Tự động cập nhật (Zero-Agent Auto Update):** Nhận diện phiên bản mới trên GitHub, tự động tải về và nâng cấp ngầm không cần UltraViewer.
* **Tối ưu máy POS cũ:** Tự động giãn cách thời gian xóa (delay) để không gây nghẽn CPU/Disk I/O.

## 📂 Cấu trúc thư mục (C:\IT_Scripts)

| File | Chức năng |
| :--- | :--- |
| `Savani_AutoCleanup.ps1` | Kịch bản dọn dẹp chính (Chạy bởi Task Scheduler). |
| `cleanup_config.json` | File cấu hình (Thông số dọn dẹp). |
| `Cleanup_Log.txt` | Nhật ký hoạt động tại ổ cứng (Local Log). |
| `.tg_token.enc` | Token Telegram đã mã hóa. |

## ⚙️ Giải nghĩa Cấu hình (cleanup_config.json)

File cấu hình là "bộ não" của kịch bản, cho phép điều chỉnh linh hoạt theo từng máy mà không cần can thiệp vào code:

* **`Options` (Tùy chọn hoạt động):**
  * `DryRun`: Đặt `true` để chạy chế độ MÔ PHỎNG (Chỉ ghi log, không xóa file thật). Đặt `false` để chạy THỰC CHIẾN.
* **`Threshold` (Ngưỡng kích hoạt thông minh):**
  * `MinFreeGBToRun` (VD: 50): Nếu ổ C: trống nhiều hơn mức này (50GB), script tự động dừng để tiết kiệm tài nguyên.
  * `AggressiveFreeGB` (VD: 10): Nếu ổ C: trống dưới mức này (10GB), kích hoạt chế độ **Aggressive Mode**. Tự động giảm thời gian giữ file xuống 1/3 để giải phóng dung lượng khẩn cấp.
* **`Days` (Tuổi thọ file tối đa):**
  * `Temp`: File tạm (Temp hệ thống/User) sinh ra trước số ngày này sẽ bị xóa.
  * `Downloads`: File tải xuống nằm trong mục Downloads quá số ngày này sẽ bị xóa.
* **`ExcludeUsers` (Vùng cấm địa):**
  * Danh sách các User Profile trên Windows tuyệt đối không quét (VD: `Administrator`, `Public`).
* **`Paths` & `JunkFolders` (Bản đồ săn rác Zalo):**
  * Khai báo chính xác các thư mục chứa rác nặng của Zalo PC (như `picture`, `video`, `ZaloDownloads`). Tuyệt đối an toàn cho CSDL tin nhắn.
* **`SafeExtensions` (Lệnh bài miễn tử):**
  * Khi quét thư mục Downloads, các file có đuôi thuộc danh sách này (VD: `.pdf`, `.xls`, `.docx`) sẽ **được giữ lại**, tránh xóa nhầm dữ liệu làm việc của thu ngân.
* **`Telegram` (Cấu hình Báo cáo):**
  * `Enabled`: Bật/Tắt gửi tin nhắn báo cáo về điện thoại.
  * `ChatID`: Địa chỉ ID nhóm hoặc cá nhân trên Telegram để nhận bot report.

## 🛠 Hướng dẫn cài đặt (Dành cho IT Support)

1. Tải gói cài đặt gồm file `.bat` và các file cấu hình.
2. Chuột phải vào file `.bat` cài đặt -> **Run as Administrator**.
3. Nhập Bot Token Telegram khi CMD yêu cầu.
4. Đảm bảo Task Scheduler đã được tạo Task `SavaniITCleanup` (OnLogon - Delay 2 phút).

## 🔄 Quy trình cập nhật Code (Dành cho Quản trị viên)

Mỗi khi muốn nâng cấp tính năng cho hệ thống 100+ máy:
1. Sửa code trong file script trên repository GitHub này.
2. Tăng số biến `$CurrentVersion` (ví dụ từ `9.1` lên `9.2`).
3. Bấm **Commit changes**. Máy POS sẽ tự động cập nhật trong lần chạy tiếp theo.

## 📝 Nhật ký phiên bản (Changelog)

* **V10:** Tích hợp hiển thị Version động trên Telegram. Sửa lỗi đường dẫn Auto-Update.
* **V9.1:** Thêm module Auto-Update, mã hóa Base64 URL và cơ chế Bypass Cache GitHub.
* **V9.0:** Triển khai Mutex chống trùng lặp, Telegram Report mã hóa AES, Aggressive Mode.
