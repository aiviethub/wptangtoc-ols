#!/bin/bash
# Script để đẩy GitHub link lên làm link chính

echo "🔄 Đang cập nhật thứ tự ưu tiên link download..."

# Thay đổi pattern: GitHub làm link chính, wptangtoc.com làm link dự phòng
# Pattern 1: wget wptangtoc.com -> wget GitHub
# Pattern 2: if [[ ! -f wptangtoc-ols.zip ]]; then wget wptangtoc.com -> if [[ ! -f wptangtoc-ols.zip ]]; then wget GitHub

# Tìm tất cả file .sh và thay đổi
find /root/aiviethub -name "*.sh" -type f | while read file; do
    echo "📝 Xử lý: $file"
    
    # Thay đổi wptangtoc-ols.zip
    sed -i 's|wget.*wptangtoc\.com/share/wptangtoc-ols\.zip|wget https://github.com/aiviethub/wptangtoc-ols/raw/refs/heads/main/wptangtoc-ols.zip|g' "$file"
    sed -i 's|wget https://github.com/aiviethub/wptangtoc-ols/raw/refs/heads/main/wptangtoc-ols.zip|g' "$file"
    
    # Thay đổi wptangtoc-ols-user.zip
    sed -i 's|wget.*wptangtoc\.com/share/wptangtoc-ols-user\.zip|wget https://github.com/aiviethub/wptangtoc-ols/raw/refs/heads/main/wptangtoc-ols-user.zip|g' "$file"
    sed -i 's|wget https://github.com/aiviethub/wptangtoc-ols/raw/refs/heads/main/wptangtoc-ols-user.zip|g' "$file"
    
    # Thay đổi wptangtoc-ols-beta.zip
    sed -i 's|wget.*wptangtoc\.com/share/wptangtoc-ols-beta\.zip|wget https://github.com/aiviethub/wptangtoc-ols/raw/refs/heads/main/wptangtoc-ols-beta.zip|g' "$file"
    sed -i 's|wget https://github.com/aiviethub/wptangtoc-ols/raw/refs/heads/main/wptangtoc-ols-beta.zip|g' "$file"
    
    # Thay đổi quan-ly-files.zip
    sed -i 's|wget.*wptangtoc\.com/share/quan-ly-files\.zip|wget https://github.com/aiviethub/wptangtoc-ols/raw/refs/heads/main/quan-ly-files.zip|g' "$file"
    sed -i 's|wget https://github.com/aiviethub/wptangtoc-ols/raw/refs/heads/main/quan-ly-files.zip|g' "$file"
done

echo "✅ Hoàn thành cập nhật thứ tự ưu tiên link download!"
echo "📋 GitHub giờ đây là link chính, wptangtoc.com là link dự phòng"
