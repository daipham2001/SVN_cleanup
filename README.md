# SAVANI IT - Script Dọn Rác Tự Động

Công cụ dọn rác ngầm cho các máy POS tại chi nhánh. Chạy rất nhẹ, tự động cập nhật và báo cáo qua Telegram.

## 🚀 Chức năng chính

* **Dọn rác:** Tự động xóa file rác Zalo (ảnh/video/cache cũ), thư mục Temp và thư mục Downloads.
* **Tránh treo máy:** Tự động bỏ qua nếu nhân viên đang mở app bán hàng (KiotViet, Nhanh) hoặc Excel.
* **Cứu hộ ổ C:** Tự động dọn mạnh tay hơn (xóa nhiều file hơn) nếu phát hiện ổ C sắp đầy.
* **Báo cáo Telegram:** Dọn xong tự động bắn tin nhắn báo cáo về group IT.
* **Tự động cập nhật:** Có code mới trên mạng là máy POS tự tải về, anh em IT không cần UltraViewer xuống từng máy.

## 📂 Thư mục chứa File (`C:\IT_Scripts`)

| File | Tác dụng |
| :--- | :--- |
| `Savani_AutoCleanup.ps1` | Kịch bản chạy chính. |
| `cleanup_config.json` | File cấu hình (chỉnh ngày, dung lượng...). |
| `Cleanup_Log.txt` | File log ghi lại lịch sử dọn rác. |
| `.tg_token.enc` | File chứa mã Token Telegram đã được bảo mật. |

## ⚙️ Hướng dẫn file Config (`cleanup_config.json`)

Chỉ cần sửa số ở file này để thay đổi cách dọn rác, không cần sửa code:

* **`DryRun`**: Để `true` là chạy thử (chỉ quét, không xóa), để `false` là chạy xóa thật.
* **`MinFreeGBToRun`** (VD: 50): Ổ C trống trên 50GB thì máy đang ngon, bỏ qua không dọn nữa.
* **`AggressiveFreeGB`** (VD: 10): Ổ C trống dưới 10GB thì kích hoạt chế độ "Cấp cứu" (Giảm số ngày giữ file xuống để cứu ổ cứng ngay lập tức).
* **`Days`**: Số ngày giữ lại file cũ trong mục Temp và Downloads. Quá ngày là bị xóa.
* **`ExcludeUsers`**: Các tài khoản Windows tuyệt đối không quét rác (VD: Administrator).
* **`JunkFolders`**: Chỗ khai báo rác Zalo. Lưu ý: Tool chỉ xóa cache, media cũ, tuyệt đối không làm mất tin nhắn.
* **`SafeExtensions`**: File tải về có các đuôi này (như `.pdf`, `.xls`, `.docx`...) sẽ ĐƯỢC GIỮ LẠI, không bị xóa.
* **`Telegram`**: Bật/tắt gửi tin nhắn và điền ID nhóm chat.

## 🛠 Cách cài đặt lần đầu (Dành cho Helpdesk)

1. Copy gói cài đặt vào máy POS chi nhánh.
2. Chuột phải vào file cài đặt `.bat` -> Chọn **Run as Administrator**.
3. Dán mã Token Telegram vào màn hình đen khi được hỏi.
4. Xong! Tool sẽ tự tạo Task Scheduler chạy ngầm 2 phút sau khi thu ngân mở máy.

## 🔄 Cách Update bản mới (Dành cho Admin)

Khi cần sửa code hoặc thêm tính năng cho 100+ máy:
1. Mở file `SavaniCleanup_v9.ps1` trên GitHub này để sửa code.
2. Sửa tăng con số ở dòng `$CurrentVersion` (VD: từ `9.1` lên `9.2`).
3. Lưu lại (Commit changes).
4. Các máy POS sẽ tự động tải bản mới về chạy ở lần tiếp theo.

## 📝 Lịch sử cập nhật

* **V10:** Tự động hiển thị Version trên Telegram, sửa lỗi tải file update.
* **V9.1:** Thêm tính năng tự động tải code từ GitHub.
* **V9.0:** Thêm báo cáo Telegram, chống chạy trùng script, thêm tính năng dọn mạnh tay (Aggressive Mode).
