#!/bin/bash
# Script để xóa tất cả link dự phòng, chỉ giữ GitHub link

echo "🗑️  Đang xóa tất cả link dự phòng, chỉ giữ GitHub link..."

# Tìm tất cả file .sh và xóa link dự phòng
find /root/aiviethub -name "*.sh" -type f | while read file; do
    echo "📝 Xử lý: $file"
    
    sed -i '/wget.*wptangtoc\.com.*wptangtoc-ols.*\.zip/d' "$file"
    sed -i '/wget.*wptangtoc\.com.*wptangtoc-ols-user.*\.zip/d' "$file"
    sed -i '/wget.*wptangtoc\.com.*wptangtoc-ols-beta.*\.zip/d' "$file"
    sed -i '/wget.*wptangtoc\.com.*quan-ly-files.*\.zip/d' "$file"
    
    # Xóa các dòng if [[ ! -f ... ]] chứa link dự phòng
    sed -i '/if.*!.*-f.*wptangtoc-ols.*\.zip.*then/,/fi/d' "$file"
    sed -i '/if.*!.*-f.*wptangtoc-ols-user.*\.zip.*then/,/fi/d' "$file"
    sed -i '/if.*!.*-f.*wptangtoc-ols-beta.*\.zip.*then/,/fi/d' "$file"
    sed -i '/if.*!.*-f.*quan-ly-files.*\.zip.*then/,/fi/d' "$file"
    
    # Xóa các comment về link dự phòng
done

echo "✅ Hoàn thành xóa tất cả link dự phòng!"
echo "📋 Chỉ còn lại GitHub link duy nhất cho mỗi file"
