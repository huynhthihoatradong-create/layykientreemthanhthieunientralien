-- ==============================================================================
-- CƠ SỞ DỮ LIỆU "ĐIỀU EM MUỐN NÓI" - ĐOÀN THANH NIÊN XÃ TRÀ LIÊN
-- ==============================================================================
-- Cách thực hiện:
-- 1. Đăng nhập Supabase (https://supabase.com) -> Vào dự án của bạn
-- 2. Chọn tab "SQL Editor" ở menu bên trái
-- 3. Dán toàn bộ nội dung file này vào và bấm "Run"
-- ==============================================================================

-- 1. Tạo bảng lưu ý kiến trẻ em, thanh thiếu nhi
CREATE TABLE IF NOT EXISTS public.opinions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    
    -- Thông tin người gửi
    full_name TEXT,
    is_anonymous BOOLEAN NOT NULL DEFAULT false,
    age_group TEXT NOT NULL,
    location TEXT NOT NULL,
    contact_info TEXT, -- Số điện thoại hoặc Zalo (tùy chọn)
    
    -- Nội dung chia sẻ
    topic TEXT NOT NULL,
    content TEXT NOT NULL,
    
    -- Xử lý của Đoàn Thanh niên
    status TEXT NOT NULL DEFAULT 'new', -- 'new': Mới, 'processing': Đang xử lý, 'resolved': Đã xử lý/Ghi nhận
    admin_notes TEXT -- Ghi chú nội bộ của cán bộ Đoàn
);

-- 2. Đánh index để tìm kiếm và lọc nhanh chóng
CREATE INDEX IF NOT EXISTS idx_opinions_created_at ON public.opinions(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_opinions_status ON public.opinions(status);
CREATE INDEX IF NOT EXISTS idx_opinions_topic ON public.opinions(topic);

-- 3. KÍCH HOẠT BẢO MẬT ROW LEVEL SECURITY (RLS)
-- Cực kỳ quan trọng: Ngăn chặn tuyệt đối việc người ngoài xem được tâm tư của các em!
ALTER TABLE public.opinions ENABLE ROW LEVEL SECURITY;

-- Xóa các policy cũ nếu có trước đó
DROP POLICY IF EXISTS "Cho phép bất kỳ ai gửi ý kiến" ON public.opinions;
DROP POLICY IF EXISTS "Chỉ Quản trị viên xem được ý kiến" ON public.opinions;
DROP POLICY IF EXISTS "Chỉ Quản trị viên cập nhật ý kiến" ON public.opinions;
DROP POLICY IF EXISTS "Chỉ Quản trị viên xóa ý kiến" ON public.opinions;

-- POLICY 1: Cho phép mọi người (kể cả chưa đăng nhập) GỬI Ý KIẾN (INSERT)
CREATE POLICY "Cho phép bất kỳ ai gửi ý kiến" 
ON public.opinions 
FOR INSERT 
TO anon, authenticated 
WITH CHECK (true);

-- POLICY 2: CHỈ CÁN BỘ ĐOÀN ĐÃ ĐĂNG NHẬP MỚI ĐƯỢC XEM (SELECT)
CREATE POLICY "Chỉ Quản trị viên xem được ý kiến" 
ON public.opinions 
FOR SELECT 
TO authenticated 
USING (true);

-- POLICY 3: CHỈ CÁN BỘ ĐOÀN ĐÃ ĐĂNG NHẬP MỚI ĐƯỢC CẬP NHẬT TRẠNG THÁI & GHI CHÚ (UPDATE)
CREATE POLICY "Chỉ Quản trị viên cập nhật ý kiến" 
ON public.opinions 
FOR UPDATE 
TO authenticated 
USING (true)
WITH CHECK (true);

-- POLICY 4: CHỈ CÁN BỘ ĐOÀN ĐÃ ĐĂNG NHẬP MỚI ĐƯỢC XÓA Ý KIẾN (DELETE)
CREATE POLICY "Chỉ Quản trị viên xóa ý kiến" 
ON public.opinions 
FOR DELETE 
TO authenticated 
USING (true);

-- ==============================================================================
-- HƯỚNG DẪN TẠO TÀI KHOẢN CÁN BỘ ĐOÀN THANH NIÊN:
-- Trong Supabase Dashboard:
-- 1. Vào menu "Authentication" -> "Users"
-- 2. Nhấn nút "Add user" -> "Create user"
-- 3. Nhập Email (Ví dụ: doantn.tralien@gmail.com) và Mật khẩu an toàn
-- 4. Bật chọn "Auto Confirm User?" -> Nhấn "Create user"
-- 5. Dùng Email và Mật khẩu vừa tạo để đăng nhập vào trang Quản trị của website.
-- ==============================================================================
