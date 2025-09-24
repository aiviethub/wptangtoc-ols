# WPTangToc OLS - Laravel Module

## Tổng quan
Module Laravel được tích hợp vào WPTangToc OLS để hỗ trợ cài đặt và quản lý Laravel applications một cách dễ dàng.

## Tính năng chính

### 1. Cài đặt Laravel
- Tự động cài đặt Laravel mới nhất
- Cấu hình virtual host cho Laravel
- Tạo database và user riêng
- Cấu hình .env file
- Tối ưu hóa permissions

### 2. Laravel Breeze
- Cài đặt Laravel Breeze (Authentication)
- Hỗ trợ nhiều stack: Blade, React, Vue, API
- Tự động cài đặt dependencies

### 3. Quản lý Laravel Projects
- Xem thông tin project
- Sao lưu và khôi phục
- Xóa project an toàn
- Kiểm tra trạng thái

### 4. Laravel Artisan
- Chạy Artisan commands
- Interactive mode
- Hỗ trợ tất cả Laravel commands

### 5. Laravel Cache Management
- Quản lý cache (config, route, view, application)
- Tối ưu hóa cache
- Xem trạng thái cache

### 6. Laravel Optimization
- Tối ưu hóa performance
- Cấu hình PHP cho Laravel
- Tối ưu hóa database
- Quản lý storage

## Cách sử dụng

### Menu chính
```bash
wptangtoc
# Chọn "Quản lý Laravel" (option 35)
```

### Lệnh CLI
```bash
# Cài đặt Laravel mới
wptt laravel install

# Chạy Artisan command
wptt laravel artisan domain.com make:controller UserController

# Quản lý cache
wptt laravel cache domain.com clear

# Danh sách Laravel projects
wptt laravel list
```

### Cài đặt Laravel Breeze
```bash
wptt laravel install
# Chọn domain và cài đặt Laravel trước
# Sau đó vào menu Laravel và chọn "Cài đặt Laravel Breeze"
```

## Cấu trúc file

```
/etc/wptt/laravel/
├── wptt-install-laravel              # Cài đặt Laravel mới
├── wptt-install-laravel-breeze      # Cài đặt Laravel Breeze
├── wptt-install-laravel-jetstream   # Cài đặt Laravel Jetstream (coming soon)
├── wptt-install-laravel-nova        # Cài đặt Laravel Nova (coming soon)
├── wptt-manage-laravel-projects     # Quản lý Laravel projects
├── wptt-configure-laravel-env       # Cấu hình environment
├── wptt-optimize-laravel            # Tối ưu hóa Laravel
├── wptt-backup-laravel              # Sao lưu Laravel
├── wptt-deploy-laravel              # Deploy Laravel
├── wptt-manage-laravel-queue        # Quản lý Laravel Queue
├── wptt-manage-laravel-schedule     # Quản lý Laravel Schedule
├── wptt-laravel-logs                # Quản lý Laravel logs
├── wptt-laravel-artisan             # Laravel Artisan commands
├── wptt-laravel-migration           # Database migrations
├── wptt-laravel-cache               # Cache management
├── wptt-laravel-packages            # Package management
├── wptt-laravel-security            # Security hardening
├── wptt-laravel-monitoring          # Monitoring
├── wptt-laravel-api-docs            # API documentation
└── wptt-laravel-testing             # Testing
```

## Yêu cầu hệ thống

- PHP 7.4+ (khuyến nghị PHP 8.1+)
- Composer
- MariaDB/MySQL
- OpenLiteSpeed
- Đủ quyền root

## Lưu ý quan trọng

1. **Backup trước khi cài đặt**: Luôn backup dữ liệu trước khi cài đặt Laravel
2. **Domain đã tồn tại**: Laravel sẽ được cài đặt trong thư mục con của domain hiện có
3. **Virtual Host**: Script sẽ tự động cấu hình virtual host cho Laravel
4. **Database**: Sẽ tạo database và user riêng cho Laravel project
5. **Permissions**: Tự động cấu hình quyền truy cập phù hợp

## Troubleshooting

### Lỗi Composer
```bash
# Cài đặt Composer thủ công
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer
```

### Lỗi permissions
```bash
# Sửa quyền Laravel
chmod -R 775 storage bootstrap/cache
chown -R user:user storage bootstrap/cache
```

### Lỗi virtual host
```bash
# Restart LiteSpeed
/usr/local/lsws/bin/lswsctrl restart
```

## Hỗ trợ

- Website: https://wptangtoc.com
- Email: giatuan@wptangtoc.com
- GitHub: https://github.com/wptangtoc/wptangtoc-ols

## Changelog

### v1.0.0 (2025-01-XX)
- Tích hợp Laravel module vào WPTangToc OLS
- Hỗ trợ cài đặt Laravel mới
- Hỗ trợ Laravel Breeze
- Quản lý Laravel projects
- Laravel Artisan integration
- Cache management
- Performance optimization
