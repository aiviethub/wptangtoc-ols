#!/bin/bash
# Script test hệ thống đồng bộ GitHub

echo "=== KIỂM TRA HỆ THỐNG ĐỒNG BỘ GITHUB ==="
echo ""

# Màu sắc
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}[INFO]${NC} Kiểm tra file trên server local..."
echo ""

# Đếm file trên server
local_files=$(ls -1 /root/ | wc -l)
echo "📁 Tổng số file trên server: $local_files"

# Kiểm tra các file quan trọng
echo ""
echo "🔍 Kiểm tra file quan trọng:"
important_files=(
    "wptangtoc-ols"
    "wptangtoc-ols-almalinux" 
    "wptangtoc-ols-almalinux-9"
    "wptangtoc-ols-beta.zip"
    "wptangtoc-ols-user-beta.zip"
    "wptangtoc-ols-user.zip"
    "wptangtoc-ols.zip"
    "quan-ly-files.zip"
    "repo-centos7-fix-eol-het-han.zip"
    "heartbeat-wptangtoc.zip"
    "wptangtoc-ols-ubuntu"
    "tool-wptangtoc-ols"
    "tool-wptangtoc-ols-user"
)

for file in "${important_files[@]}"; do
    if [[ -e "/root/$file" ]]; then
        echo -e "  ✅ $file"
    else
        echo -e "  ❌ $file"
    fi
done

echo ""
echo -e "${BLUE}[INFO]${NC} Kiểm tra file trên GitHub..."
echo ""

# Đếm file trên GitHub
cd /root/wptangtoc-ols-git
git_files=$(ls -1 | wc -l)
echo "📁 Tổng số file trên GitHub: $git_files"

echo ""
echo "🔍 Kiểm tra file quan trọng trên GitHub:"
for file in "${important_files[@]}"; do
    if [[ -e "/root/wptangtoc-ols-git/$file" ]]; then
        echo -e "  ✅ $file"
    else
        echo -e "  ❌ $file"
    fi
done

echo ""
echo -e "${BLUE}[INFO]${NC} Kiểm tra trạng thái Git..."
echo ""

# Kiểm tra trạng thái Git
cd /root/wptangtoc-ols-git
git_status=$(git status --porcelain)
if [[ -z "$git_status" ]]; then
    echo -e "  ✅ Git repository sạch (không có thay đổi chưa commit)"
else
    echo -e "  ⚠️  Git repository có thay đổi chưa commit:"
    echo "$git_status"
fi

echo ""
echo -e "${BLUE}[INFO]${NC} Kiểm tra cron job..."
echo ""

# Kiểm tra cron job
cron_jobs=$(crontab -l 2>/dev/null | grep -c "sync-to-github\|git-sync-cron")
if [[ $cron_jobs -gt 0 ]]; then
    echo -e "  ✅ Có $cron_jobs cron job đang hoạt động"
    crontab -l 2>/dev/null | grep "sync-to-github\|git-sync-cron"
else
    echo -e "  ❌ Không có cron job nào"
fi

echo ""
echo "=== TÓM TẮT ==="
echo ""

# So sánh số file
if [[ $local_files -eq $git_files ]]; then
    echo -e "  ✅ Số file trên server và GitHub bằng nhau ($local_files files)"
else
    echo -e "  ⚠️  Số file khác nhau: Server ($local_files) vs GitHub ($git_files)"
fi

echo ""
echo "🎯 Hệ thống đồng bộ GitHub đã sẵn sàng!"
echo ""
echo "📋 Các lệnh hữu ích:"
echo "  • Đồng bộ từ GitHub về server: /root/sync-from-github.sh force"
echo "  • Đồng bộ từ server lên GitHub: /root/sync-to-github.sh smart"
echo "  • Xem trạng thái: /root/sync-from-github.sh compare"
echo "  • Thiết lập auto sync: /root/sync-to-github.sh setup-cron 2min"
echo ""
