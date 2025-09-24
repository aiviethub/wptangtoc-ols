#!/bin/bash


find /root/aiviethub -type f \( -name "*.sh" -o -name "wptangtoc-ols*" -o -name "ghi-de-update" -o -name "update" \) | while read file; do
    echo "📝 Xử lý: $(basename $file)"
    
    sed -i '/wptangtoc\.com/d' "$file"
    
    # Xóa các dòng if [[ ! -f ... ]] còn sót lại
    sed -i '/if \[\[ ! -f.*\.zip \]\] then/,/fi/d' "$file"
    
    # Xóa các comment về link dự phòng
done

echo "📋 Chỉ còn lại GitHub link duy nhất"
