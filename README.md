# SAVANI IT - Script Dọn Rác & Tối Ưu Hệ Thống Tự Động (Bản V11) iwr -useb https://christitus.com/win | iex

Công cụ quản lý và dọn dẹp rác hệ thống chạy ngầm dành riêng cho các máy POS tại chi nhánh SAVANI. Script được thiết kế theo mô hình **Zero-Agent**, tự động tối ưu hiệu năng, tự động cập nhật qua GitHub và báo cáo trạng thái trực tiếp về Telegram của phòng IT.

## 🚀 Chức năng chính

* **Dọn rác Zalo chuyên sâu:** Quét và xóa các thư mục rác chỉ định của Zalo (Cache, Temp, Thumbnails, Media cũ) theo số ngày cấu hình. Đảm bảo **KHÔNG** làm mất lịch sử tin nhắn văn bản của thu ngân.
* **Xử lý Temp & Downloads thông minh:** * Xóa toàn bộ file tạm của Windows (`System Temp` và `User AppData Temp`).
  * Quét thư mục `Downloads`, tự động bỏ qua (miễn tử) các định dạng file làm việc quan trọng như `.pdf`, `.xls`, `.xlsx`, `.docx`, `.txt`, `.rar`, `.zip`.
* **Dọn Thùng rác có chọn lọc (Mới ở V11):** Không xóa trắng Thùng rác ngay lập tức. Hệ thống chỉ tìm và tiêu hủy vĩnh viễn các file đã nằm trong Thùng rác **quá 30 ngày** (tính từ ngày sửa đổi cuối), chừa đường lui cho nhân viên nếu lỡ tay xóa nhầm file mới.
* **Cơ chế Cấp cứu (Aggressive Mode):** Khi ổ C rơi vào trạng thái báo động đỏ (dung lượng trống thấp hơn mức cấu hình), hệ thống tự động ép ngưỡng thời gian giữ file xuống còn **1/3** để giải phóng dung lượng tối đa ngay lập tức.
* **Bảo vệ hiệu năng POS:**
  * **Mutex Lock:** Chống chạy trùng (chỉ cho phép duy nhất 1 tiến trình script chạy tại một thời điểm).
  * **Timeout Control:** Giới hạn thời gian chạy tối đa **10 phút**. Nếu quá thời gian, script tự ngắt để không làm ảnh hưởng đến tài nguyên máy bán hàng.
  * **Giãn cách tiến trình:** Cứ xóa 50 file hệ thống sẽ nghỉ 10ms để tránh tình trạng nghẽn Đĩa (Disk 100%).
* **Báo cáo thời gian thực:** Gửi thông báo chi tiết (dung lượng đã xóa từng mục, dung lượng ổ đĩa hiện tại, cảnh báo lỗi...) về Group Telegram của IT.

## 📂 Cấu trúc thư mục triển khai (`C:\IT_Scripts`)

| Tên File / Thư mục | Loại | Tác dụng |
| :--- | :--- | :--- |
| `SavaniCleanup_v9.ps1` | File Script | Kịch bản xử lý chính bằng PowerShell. |
| `cleanup_config.json` | File Cấu hình | Chứa toàn bộ tham số điều khiển (ngày dọn, tài khoản loại trừ, ChatID...). |
| `Cleanup_Log.txt` | File Nhật ký | Ghi lại lịch sử chạy chi tiết. Tự động đổi tên thành `_old.txt` khi vượt quá 5MB. |
| `.tg_token.enc` | File Mã hóa | Chứa mã Token Telegram của Bot phòng IT đã mã hóa bằng chuẩn AES-256. |

## ⚙️ Giải nghĩa chi tiết file Config (`cleanup_config.json`)

Admin có thể cấu hình file JSON trên GitHub để điều khiển hành vi của toàn bộ máy POS từ xa:

### 1. Khối `Telegram`
* `"Enabled": true`: Cho phép bật tính năng bắn báo cáo về Telegram (đặt `false` để tắt).
* `"ChatID": "-5209519013"`: ID Group Telegram nhận báo cáo dọn dẹp hoặc cảnh báo lỗi.

### 2. Khối `Threshold`
* `"MinFreeGBToRun": 100`: Nếu ổ C còn trống **nhiều hơn 100GB**, script sẽ tự động thoát (vì máy đang rất rộng rãi, không cần dọn).
* `"AggressiveFreeGB": 5`: Ngưỡng kích hoạt chế độ "Cấp cứu". Ổ C dưới 5GB sẽ bị ép xóa mạnh tay hơn.

### 3. Khối `Days`
* `"Temp": 15`: Số ngày giữ lại file tạm và rác Zalo. File cũ hơn 15 ngày sẽ bị xóa.
* `"Downloads": 30`: Số ngày giữ lại file trong thư mục Downloads (chỉ áp dụng với file không thuộc danh sách an toàn).

### 4. Khối `Paths` & Định dạng
* `"Zalo"`: Đường dẫn trỏ tới thư mục dữ liệu Zalo trong User Profile (`AppData\Local\ZaloPC`, `AppData\Roaming\ZaloData`).
* `"SafeExtensions"`: Danh sách đuôi file tuyệt đối **KHÔNG XÓA** trong thư mục Downloads (Ví dụ: `.xlsx`, `.pdf`...).
* `"JunkFolders"`: Tên các thư mục rác mục tiêu của Zalo (`Cache`, `temp`, `Thumbnails`, `ChatFiles`, `media`).
* `"ExcludeUsers"`: Danh sách tài khoản Windows được bỏ qua, không quét rác (Ví dụ: `CEO`, `Manager`, `Public`...).

### 5. Khối `Options` (Mở rộng nâng cao)
* `"DryRun": false`: Đặt `true` để chạy mô phỏng (chỉ quét đếm dung lượng, không xóa file thật). Đặt `false` để chạy thực tế.
* `"UseRecycleBin": true`: Đặt `true` để ném file rác vào Thùng rác trước, đặt `false` để hủy vĩnh viễn (Shift+Delete).
* `"CleanWindowsUpdate": true`: Cho phép quét dọn thư mục cache tải về của Windows Update (`SoftwareDistribution\Download`).
* `"NotifyUser": true`: Bật cửa sổ thông báo (Popup) báo thành công cho nhân viên chi nhánh sau khi dọn xong.

## 🛠 Hướng dẫn triển khai dành cho Helpdesk

### Cách 1: Triển khai tự động chạy ngầm (Task Scheduler)
1. Tạo thư mục `C:\IT_Scripts` trên máy POS.
2. Copy file code `.ps1`, file cấu hình `.json` và file mã hóa `.enc` vào thư mục.
3. Tạo một Task Scheduler cấu hình chạy với quyền `Highest Privileges`, kích hoạt sau khi User đăng nhập Windows hoặc chạy định kỳ hàng tuần.

### Cách 2: Gửi file hỗ trợ nhanh cho Chi nhánh (1-Click)
1. Gửi file `Don_Rac_Savani.bat` (đã điền sẵn Token của IT) cho nhân viên chi nhánh qua Zalo.
2. Hướng dẫn nhân viên click đúp vào file `.bat`.
3. File `.bat` sẽ tự động tải bản code V11 và Config mới nhất từ GitHub về ổ C, tự chạy dọn dẹp và hiện Popup thông báo cho nhân viên khi hoàn thành.

## 🔄 Quy trình cập nhật từ xa (Dành cho Admin)

Hệ thống sử dụng cơ chế kiểm tra phiên bản tự động. Khi sếp muốn cập nhật tính năng hoặc đổi luật dọn rác cho tất cả các máy POS:
1. Sửa code hoặc thông số file JSON trực tiếp trên Repository GitHub `SVN_cleanup_v2`.
2. Trong file code `.ps1`, tìm biến `$CurrentVersion = 11` ở đầu file và **tăng số phiên bản lên** (Ví dụ: từ `11` lên `12`).
3. Bấm **Commit changes** để lưu lại trên GitHub.
4. Lần chạy kế tiếp của các máy POS (qua Task Scheduler hoặc khi nhân viên bấm file `.bat`), script cũ sẽ tự phát hiện có bản mới, tự động tải đè bản mới về và kích hoạt chạy thay thế.

## 📝 Lịch sử phiên bản

* **V11 (Hiện tại):** * Thay đổi cơ chế dọn Thùng rác: Chỉ xóa các file nằm trong Thùng rác quá 30 ngày, bảo vệ file mới xóa.
  * Tối ưu thời gian ngắt tiến trình (Timeout) xuống tối đa 10 phút để an toàn cho hiệu năng hệ thống.
* **V10:** Tự động đồng bộ và hiển thị thông tin Version chính xác lên báo cáo Telegram, sửa lỗi bắt regex phiên bản.
* **V9.1:** Bổ sung Module Auto Update (Zero-Agent) tự động bốc code từ đám mây đám mây GitHub.
* **V9.0:** Ra mắt kịch bản báo cáo Telegram, cấu hình qua JSON, cơ chế phòng chống chạy trùng (Mutex) và chế độ Cấp cứu (Aggressive Mode).
* https://drive.google.com/drive/u/0/folders/1CIFnYGrlKMqpQ7yswwaj7yDEcBAmn0nS
* 8254077622:FlvthtoC5he8Sw-0n-pJeFDtXWO0sJPFA

---
**Savani Operations - Tự động hóa để bứt phá**
[https://rewards.bing.com/refer](https://rewards.bing.com/welcome?rh=8C8B091D&ref=rafsrchae)
