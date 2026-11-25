# Bài thuyết trình Âm nhạc lớp 12: Nghệ thuật Truyền thống Việt Nam

Dự án slide tương tác xây dựng bằng **Slidev** (Vue 3) giới thiệu 4 loại hình nghệ thuật truyền thống tiêu biểu của Việt Nam: **Chèo, Tuồng (Hát Bội), Cải lương và Ca trù**, thiết kế theo phong cách **Minimalist + Frosted Glass** trên nền tối.

## Yêu cầu môi trường

- Node.js >= 20
- `pnpm`
- (Tùy chọn push GitHub) `git` và GitHub CLI (`gh`)

## 1. Cài đặt dependencies

```bash
pnpm install
```

## 2. Chạy trình chiếu (Development)

```bash
pnpm dev
```

Mở trình duyệt tại địa chỉ Slidev hiển thị (mặc định `http://localhost:3000`).

## 3. Xuất file PDF dự phòng mang lên lớp

```bash
pnpm export
```

File PDF xuất ra sẽ có tên `am-nhac-12-nghe-thuat-truyen-thong.pdf` (đã được thêm vào `.gitignore`).

> **Lưu ý:** Lần đầu chạy `pnpm export`, Slidev yêu cầu gói `playwright-chromium`. Nếu chưa có, cài đặt bằng:
> ```bash
> pnpm add -D playwright-chromium
> ```

## 4. Hướng dẫn gắn link video / audio thật ở Slide 12

Mở tệp `slides.md`, tìm đến phần **Slide 12 – Góc Nghe & Nhìn (Media Showcase)** và cập nhật thuộc tính `youtube-id` (hoặc thêm `audio-src`) trên từng thẻ `<MediaCard>`:

```html
<!-- Ví dụ với link https://www.youtube.com/watch?v=dQw4w9WgXcQ -->
<MediaCard
  art-form="Chèo"
  region="Bắc Bộ"
  suggested-clip="Trích đoạn: Thị Mầu lên chùa (Quan Âm Thị Kính)"
  youtube-id="dQw4w9WgXcQ"
  accent="red"
/>
```

- Chỉ cần dán phần **ID video YouTube** (đoạn ký tự sau `v=` hoặc sau `youtu.be/`).
- Nếu muốn dùng file âm thanh `.mp3` nội bộ, đặt file vào thư mục `public/audio/` và truyền `audio-src="/audio/ten-file.mp3"`.

## 5. Đẩy dự án lên GitHub Repository mới (Ubuntu — Bash & Fish)

Đảm bảo đã đăng nhập GitHub CLI (`gh auth login`), sau đó chạy:

```bash
./scripts/push-github.sh
```

Script sẽ tự động kiểm tra `git`/`gh`, khởi tạo nhánh `main`, commit theo chuẩn Conventional Commits, hỏi tên repo (mặc định `am-nhac-12-nghe-thuat-truyen-thong`) và quyền riêng tư (`public`/`private`), tạo repo trên GitHub và push toàn bộ dự án.
