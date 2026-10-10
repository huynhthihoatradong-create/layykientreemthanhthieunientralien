# HƯỚNG DẪN CÀI ĐẶT & TRIỂN KHAI WEBSITE "ĐIỀU EM MUỐN NÓI"
### Ứng dụng lấy ý kiến trẻ em, thanh thiếu nhi xã Trà Liên do Đoàn Thanh niên xã Trà Liên quản trị

---

## 🌟 TỔNG QUAN
Website **“ĐIỀU EM MUỐN NÓI”** là cầu nối trực tuyến thân thiện, bảo mật giúp các em học sinh, thanh thiếu nhi trên địa bàn xã Trà Liên bày tỏ tâm tư, nguyện vọng, ý kiến và các khó khăn đến Ban Thường vụ Đoàn xã.

---

## BƯỚC 1: KHỞI TẠO CƠ SỞ DỮ LIỆU SUPABASE (MIỄN PHÍ)

Supabase là hệ thống cơ sở dữ liệu đám mây bảo mật được sử dụng để lưu trữ ý kiến và quản lý tài khoản cán bộ Đoàn.

1. **Đăng ký tài khoản:** Truy cập [https://supabase.com](https://supabase.com) và bấm **Start your project** (Đăng nhập bằng tài khoản GitHub hoặc Google).
2. **Tạo dự án mới:**
   - Bấm **New project**.
   - **Name**: Nhập `dieu-em-muon-noi-tra-lien`
   - **Database Password**: Nhập mật khẩu cơ sở dữ liệu (tự chọn và lưu lại).
   - **Region**: Chọn `Singapore` (để tốc độ tải tại Việt Nam nhanh nhất).
   - Bấm **Create new project** và đợi khoảng 1-2 phút để hệ thống khởi tạo.
3. **Cài đặt bảng dữ liệu & phân quyền bảo mật:**
   - Ở thanh menu bên trái Supabase, bấm vào **SQL Editor**.
   - Bấm **New query**.
   - Mở file `supabase_schema.sql` trong mã nguồn website, sao chép toàn bộ nội dung và dán vào ô SQL Editor.
   - Bấm nút **Run** (màu xanh lá). Hệ thống sẽ tự động tạo bảng `opinions` và thiết lập chính sách bảo mật **Row Level Security (RLS)**:
     - Cho phép mọi người gửi ý kiến (`INSERT`).
     - **Chỉ cán bộ Đoàn đã đăng nhập mới được xem, cập nhật trạng thái và xuất dữ liệu** (`SELECT`, `UPDATE`, `DELETE`). Dữ liệu hoàn toàn bí mật, không bị lộ ra ngoài.
4. **Tạo tài khoản Cán bộ Đoàn xã:**
   - Ở thanh menu bên trái Supabase, chọn mục **Authentication** &rarr; **Users**.
   - Bấm nút **Add user** &rarr; **Create user**.
   - Nhập **Email** (ví dụ: `doantn.tralien@gmail.com`).
   - Nhập **Password** (mật khẩu an toàn dành riêng cho cán bộ Đoàn).
   - Đảm bảo mục **Auto Confirm User?** được BẬT (Checked).
   - Bấm **Create user**.
5. **Lấy khóa kết nối (API Keys):**
   - Vào menu bánh răng **Project Settings** (ở dưới cùng bên trái) &rarr; chọn **API**.
   - Sao chép 2 thông số:
     - **Project URL** (dạng `https://xyz...supabase.co`)
     - **Project API Keys** mục `anon` `public` (chuỗi ký tự dài bắt đầu bằng `eyJ...`)

---

## BƯỚC 2: CẤU HÌNH VÀ KIỂM TRA TRÊN MÁY TÍNH

1. Mở file `.env` trong thư mục dự án và dán thông số vừa lấy:
   ```env
   VITE_SUPABASE_URL=https://mã-dự-án-của-bạn.supabase.co
   VITE_SUPABASE_ANON_KEY=chuỗi-anon-key-của-bạn
   ```
2. Mở cửa sổ dòng lệnh (Terminal/PowerShell) tại thư mục dự án và chạy:
   ```bash
   npm run dev
   ```
3. Truy cập vào địa chỉ hiển thị trên màn hình (thường là `http://localhost:5173`):
   - **Thử nghiệm gửi ý kiến:** Điền thử một ý kiến (ẩn danh hoặc có tên) &rarr; Bấm **GỬI Ý KIẾN**.
   - **Thử nghiệm quản trị:** Bấm vào nút **Cán bộ Đoàn** ở góc trên bên phải &rarr; Đăng nhập bằng Email và Mật khẩu vừa tạo ở Bước 1 &rarr; Xem danh sách ý kiến, đổi trạng thái xử lý, thêm ghi chú nội bộ, và bấm **Xuất file CSV**.

---

## BƯỚC 3: TRIỂN KHAI LÊN VERCEL ĐỂ CÓ LINK CHIA SẺ CÔNG KHAI

Để có đường link website trực tuyến miễn phí (ví dụ: `dieuemmuonnoi-tralien.vercel.app`) gửi cho các trường học, thôn bản và các em thiếu nhi:

### Cách 1: Triển khai trực tiếp qua Vercel CLI (Nhanh nhất)
1. Cài đặt Vercel CLI nếu chưa có:
   ```bash
   npm install -g vercel
   ```
2. Chạy lệnh:
   ```bash
   vercel
   ```
3. Đăng nhập theo hướng dẫn trên trình duyệt, sau đó trả lời các câu hỏi:
   - *Set up and deploy?* Nhấn **y** (Enter)
   - *Which scope?* Chọn tài khoản của bạn (Enter)
   - *Link to existing project?* Nhấn **n** (Enter)
   - *What's your project's name?* Nhập `dieu-em-muon-noi-tra-lien` (Enter)
   - *In which directory is your code located?* Nhấn **Enter** (thư mục hiện tại `./`)
   - *Want to modify settings?* Nhấn **n** (Enter)
4. Thêm biến môi trường lên Vercel:
   ```bash
   vercel env add VITE_SUPABASE_URL
   vercel env add VITE_SUPABASE_ANON_KEY
   ```
   (Nhập giá trị tương ứng cho môi trường Production).
5. Đẩy bản chính thức:
   ```bash
   vercel --prod
   ```

### Cách 2: Triển khai qua giao diện Web Vercel (Dễ làm)
1. Đẩy mã nguồn dự án lên một kho lưu trữ **GitHub** cá nhân hoặc của Đoàn xã.
2. Truy cập [https://vercel.com](https://vercel.com) &rarr; Đăng nhập bằng GitHub.
3. Bấm **Add New...** &rarr; **Project**.
4. Chọn repository chứa dự án vừa đẩy lên.
5. Ở phần **Environment Variables**, bấm thêm 2 biến:
   - Key: `VITE_SUPABASE_URL` | Value: `(URL Supabase của bạn)`
   - Key: `VITE_SUPABASE_ANON_KEY` | Value: `(Anon Key của bạn)`
6. Bấm **Deploy**.
7. Sau khoảng 1 phút, Vercel sẽ cấp cho bạn một đường link chính thức (dạng `.vercel.app`). Bạn có thể tạo mã QR từ link này để in dán tại các trường học, nhà văn hóa thôn hoặc chia sẻ trên Fanpage Đoàn xã Trà Liên!

---

## BẢO MẬT & VẬN HÀNH
- **Bảo mật tuyệt đối:** Nhờ cơ chế Supabase Row Level Security (RLS), chỉ cán bộ Đoàn có tài khoản được cấp mới đọc được danh sách ý kiến. Không người dùng hay học sinh nào có thể đọc trộm ý kiến của người khác.
- **Xuất báo cáo định kỳ:** Cán bộ Đoàn sử dụng tính năng **Xuất file CSV** (đã được định dạng sẵn UTF-8 có dấu tiếng Việt) để mở trực tiếp trong Excel báo cáo Ban Thường vụ Đảng ủy, HĐND, UBND xã và Hội đồng Đội huyện.
