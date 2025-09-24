#!/bin/bash
# Script để xóa tất cả link dự phòng, chỉ giữ GitHub link

echo "🗑️  Đang xóa tất cả link dự phòng, chỉ giữ GitHub link..."

# Xử lý file wptangtoc-ols-almalinux
echo "📝 Xử lý: wptangtoc-ols-almalinux"
sed -i '/if \[\[ ! -f wptangtoc-ols\.zip \]\] then/,/fi/d' /root/aiviethub/wptangtoc-ols-almalinux
sed -i '/if \[\[ ! -f wptangtoc-ols-user\.zip \]\] then/,/fi/d' /root/aiviethub/wptangtoc-ols-almalinux
sed -i '/#link du phong/d' /root/aiviethub/wptangtoc-ols-almalinux
sed -i '/#dự phòng ssl bị lỗi/d' /root/aiviethub/wptangtoc-ols-almalinux

# Xử lý file wptangtoc-ols-almalinux-9
echo "📝 Xử lý: wptangtoc-ols-almalinux-9"
sed -i '/if \[\[ ! -f wptangtoc-ols\.zip \]\] then/,/fi/d' /root/aiviethub/wptangtoc-ols-almalinux-9
sed -i '/if \[\[ ! -f wptangtoc-ols-user\.zip \]\] then/,/fi/d' /root/aiviethub/wptangtoc-ols-almalinux-9
sed -i '/#link du phong/d' /root/aiviethub/wptangtoc-ols-almalinux-9
sed -i '/#dự phòng ssl bị lỗi/d' /root/aiviethub/wptangtoc-ols-almalinux-9

# Xử lý file wptangtoc-ols-ubuntu
echo "📝 Xử lý: wptangtoc-ols-ubuntu"
sed -i '/if \[\[ ! -f wptangtoc-ols\.zip \]\] then/,/fi/d' /root/aiviethub/wptangtoc-ols-ubuntu
sed -i '/if \[\[ ! -f wptangtoc-ols-user\.zip \]\] then/,/fi/d' /root/aiviethub/wptangtoc-ols-ubuntu
sed -i '/#link du phong/d' /root/aiviethub/wptangtoc-ols-ubuntu
sed -i '/#dự phòng ssl bị lỗi/d' /root/aiviethub/wptangtoc-ols-ubuntu

# Xử lý các file trong tool-wptangtoc-ols
echo "📝 Xử lý: tool-wptangtoc-ols/*"
find /root/aiviethub/tool-wptangtoc-ols -name "*.sh" -type f | while read file; do
    echo "  📄 Xử lý: $(basename $file)"
    sed -i '/if \[\[ ! -f wptangtoc-ols.*\.zip \]\] then/,/fi/d' "$file"
    sed -i '/if \[\[ ! -f wptangtoc-ols-user.*\.zip \]\] then/,/fi/d' "$file"
    sed -i '/if \[\[ ! -f quan-ly-files.*\.zip \]\] then/,/fi/d' "$file"
    sed -i '/#download dự phòng/d' "$file"
    sed -i '/#download dự phòng http/d' "$file"
    sed -i '/wget.*wptangtoc\.com.*wptangtoc-ols.*\.zip/d' "$file"
    sed -i '/wget.*wptangtoc\.com.*wptangtoc-ols-user.*\.zip/d' "$file"
    sed -i '/wget.*wptangtoc\.com.*quan-ly-files.*\.zip/d' "$file"
done

echo "✅ Hoàn thành xóa tất cả link dự phòng!"
echo "📋 Chỉ còn lại GitHub link duy nhất cho mỗi file"
