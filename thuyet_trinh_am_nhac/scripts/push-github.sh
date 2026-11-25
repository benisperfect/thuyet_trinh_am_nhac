#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# Tự động khởi tạo Git repo & push dự án Slidev lên GitHub (Ubuntu: Bash & Fish)
# ==============================================================================

DEFAULT_REPO_NAME="am-nhac-12-nghe-thuat-truyen-thong"
DEFAULT_VISIBILITY="public"
COMMIT_MESSAGE="feat: create grade 12 music Slidev presentation on Vietnamese traditional arts"

# Chuyển về thư mục gốc của dự án (thư mục cha của scripts/)
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
cd "$PROJECT_ROOT"

echo "============================================================"
echo "  GitHub Push Automation — Dự án Slidev Âm nhạc lớp 12"
echo "============================================================"
echo "Thư mục dự án: $PROJECT_ROOT"
echo ""

# 1. Kiểm tra git
if ! command -v git >/dev/null 2>&1; then
  echo "[LỖI] Chưa cài đặt 'git'. Cài đặt trên Ubuntu bằng:"
  echo "  sudo apt update && sudo apt install -y git"
  exit 1
fi

# 2. Kiểm tra GitHub CLI (gh)
if ! command -v gh >/dev/null 2>&1; then
  echo "[LỖI] Chưa cài đặt GitHub CLI ('gh')."
  echo ""
  echo "Hướng dẫn cài đặt 'gh' trên Ubuntu:"
  echo "  sudo apt update && sudo apt install -y gh"
  echo ""
  echo "Hoặc theo kho chính thức của GitHub CLI:"
  echo "  (type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \\"
  echo "    && sudo mkdir -p -m 755 /etc/apt/keyrings \\"
  echo "    && out=\$(mktemp) && wget -nv -O\$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \\"
  echo "    && cat \$out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null \\"
  echo "    && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \\"
  echo "    && echo \"deb [arch=\$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main\" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null \\"
  echo "    && sudo apt update && sudo apt install -y gh"
  exit 1
fi

# 3. Kiểm tra trạng thái đăng nhập gh
echo "[1/5] Kiểm tra đăng nhập GitHub CLI..."
if ! gh auth status >/dev/null 2>&1; then
  echo "[LỖI] Bạn chưa đăng nhập GitHub CLI."
  echo "Vui lòng chạy lệnh sau trước khi tiếp tục:"
  echo "  gh auth login"
  exit 1
fi
echo "      ✓ Đã đăng nhập GitHub CLI."

# 4. Đảm bảo tồn tại .gitignore chuẩn Slidev
echo "[2/5] Kiểm tra tệp .gitignore..."
if [[ ! -f ".gitignore" ]]; then
  cat <<'EOF' > .gitignore
node_modules/
dist/
.slidev/
*.pdf
.env
.env.*
.DS_Store
EOF
  echo "      ✓ Đã tạo tệp .gitignore mặc định cho Slidev."
else
  for entry in "node_modules/" "dist/" ".slidev/" "*.pdf" ".env"; do
    if ! grep -Fxq "$entry" .gitignore; then
      printf '\n%s\n' "$entry" >> .gitignore
    fi
  done
  echo "      ✓ Tệp .gitignore hợp lệ."
fi

# 5. Khởi tạo git repo & commit nếu có thay đổi
echo "[3/5] Khởi tạo Git repository và commit..."
if [[ ! -d ".git" ]]; then
  git init -b main
  echo "      ✓ Đã khởi tạo Git repository trên nhánh 'main'."
else
  # Đảm bảo đang ở nhánh main nếu chưa có commit nào
  if ! git rev-parse --verify HEAD >/dev/null 2>&1; then
    git checkout -B main
  fi
fi

if [[ -n "$(git status --porcelain)" ]]; then
  git add .
  git commit -m "$COMMIT_MESSAGE"
  echo "      ✓ Đã commit toàn bộ thay đổi."
elif ! git rev-parse --verify HEAD >/dev/null 2>&1; then
  echo "[LỖI] Không có tệp nào để commit."
  exit 1
else
  echo "      ✓ Working tree sạch, đã có commit sẵn sàng để push."
fi

# 6. Hỏi tương tác thông tin repo nếu chưa có remote origin
echo "[4/5] Cấu hình remote GitHub..."
if git remote get-url origin >/dev/null 2>&1; then
  EXISTING_REMOTE="$(git remote get-url origin)"
  echo "      ℹ Đã tồn tại remote 'origin': $EXISTING_REMOTE"
  echo "[5/5] Đang đẩy nhánh 'main' lên origin..."
  git push -u origin main
else
  read -r -p "Tên repository GitHub [${DEFAULT_REPO_NAME}]: " REPO_NAME
  REPO_NAME="${REPO_NAME:-$DEFAULT_REPO_NAME}"

  while true; do
    read -r -p "Quyền riêng tư (public/private) [${DEFAULT_VISIBILITY}]: " VISIBILITY
    VISIBILITY="${VISIBILITY:-$DEFAULT_VISIBILITY}"
    VISIBILITY="$(printf '%s' "$VISIBILITY" | tr '[:upper:]' '[:lower:]')"
    if [[ "$VISIBILITY" == "public" || "$VISIBILITY" == "private" ]]; then
      break
    fi
    echo "      ! Giá trị không hợp lệ. Vui lòng nhập 'public' hoặc 'private'."
  done

  echo "[5/5] Tạo repository '${REPO_NAME}' (${VISIBILITY}) và push lên GitHub..."
  gh repo create "$REPO_NAME" "--${VISIBILITY}" --source=. --remote=origin --push
fi

# 7. In URL repository sau khi hoàn tất
REPO_URL="$(gh repo view --json url -q .url 2>/dev/null || git remote get-url origin)"
echo ""
echo "============================================================"
echo "  HOÀN TẤT! Repository GitHub của bạn:"
echo "  $REPO_URL"
echo "============================================================"
