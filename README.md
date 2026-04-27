# SVN_cleanup


# SAVANI IT - AUTOMATED POS CLEANUP SYSTEM (V9.x)

Hệ thống dọn dẹp và tối ưu hóa máy tính POS tự động cho 100+ chi nhánh Savani. 
Giải pháp "Zero-Agent" giúp quản lý tập trung và tự động hóa bảo trì mà không tốn tài nguyên hệ thống.

## 🚀 Tính năng nổi bật

* **Dọn dẹp thông minh (Smart Cleanup):** * Tự động xử lý rác Zalo (Media, Cache), Windows Temp, User Temp và Downloads.
    * Cơ chế lọc định dạng file: Giữ lại các tài liệu quan trọng (.pdf, .doc, .xls) và chỉ xóa rác.
* **Cơ chế "Nhường đường" (App-Aware):** Tự động phát hiện và tránh xung đột khi nhân viên đang sử dụng các phần mềm bán hàng (KiotViet, Nhanh, Excel...).
* **Chế độ Cấp cứu (Aggressive Mode):** Tự động chuyển sang ngưỡng xóa mạnh hơn khi ổ C: rơi vào tình trạng báo động đỏ (dưới mức dung lượng quy định).
* **Báo cáo Telegram (Secure Reporting):** * Gửi báo cáo chi tiết (dung lượng đã xóa, tình trạng ổ đĩa) sau mỗi lần chạy.
    * **Bảo mật:** Token Telegram được mã hóa bằng chuẩn AES-256 và DPAPI của Windows, không lưu bản rõ.
* **Tự động cập nhật (Zero-Agent Auto Update):** * Hệ thống tự động nhận diện phiên bản mới trên GitHub và nâng cấp ngầm.
    * Không cần UltraViewer/AnyDesk để cập nhật script thủ công cho 100 máy.
* **Tối ưu máy yếu:** Cơ chế delay 10ms/50 file để bảo vệ CPU/Disk I/O cho các dòng máy POS đời cũ (H61/H81/HDD).

## 📂 Cấu trúc thư mục (C:\IT_Scripts)

| File | Chức năng |
| :--- | :--- |
| `Savani_AutoCleanup.ps1` | Kịch bản dọn dẹp chính (Chạy bởi Task Scheduler). |
| `cleanup_config.json` | File cấu hình (Threshold, đường dẫn, chế độ DryRun). |
| `Cleanup_Log.txt` | Nhật ký hoạt động chi tiết của hệ thống. |
| `.tg_token.enc` | Token Telegram đã được mã hóa an toàn. |

## 🛠 Hướng dẫn cài đặt (Dành cho IT Support)

1.  Tải bộ cài bao gồm file `.bat` và các file kịch bản.
2.  Chuột phải vào file `Setup_Savani_Cleanup.bat` -> **Run as Administrator**.
3.  Nhập Bot Token Telegram khi được yêu cầu (Hệ thống sẽ tự động mã hóa).
4.  Kiểm tra Task Scheduler xem đã tồn tại Task `SavaniITCleanup` chưa (Mặc định chạy OnLogon delay 2 phút).

## 🔄 Quy trình cập nhật (Dành cho Quản trị viên)

Mỗi khi có tính năng mới, Quản trị viên chỉ cần:
1.  Chỉnh sửa code trong file `SavaniCleanup_v9.ps1` trên GitHub này.
2.  Tăng giá trị biến `$CurrentVersion` (ví dụ từ `9.1` lên `9.2`).
3.  Bấm **Commit changes**.
4.  Toàn bộ các máy POS tại chi nhánh sẽ tự động tải bản mới và nâng cấp trong lần chạy kế tiếp.

## 📝 Nhật ký phiên bản (Changelog)

* **V9.1:** Thêm module Auto-Update, mã hóa Base64 URL và cơ chế phá cache GitHub.
* **V9.0:** Triển khai cơ chế Mutex, Telegram Report và Aggressive Mode.

---
**Savani Operations 
