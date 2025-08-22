# 🎬 TikNow - Flutter Movie App (BLoC Edition)

Ứng dụng đặt vé xem phim được xây dựng bằng **Flutter**, quản lý trạng thái với **BLoC**, tích hợp **Firebase** (Auth, Firestore, Storage) và API từ **TMDB**.  
Hỗ trợ đặt vé, xem trailer, thanh toán giả lập, và quản lý vé trực tiếp trên ứng dụng.

---

## ✨ Tính năng chính

### **Auth**
- Đăng ký (Email/Password – Firebase Auth)
- Đăng nhập
- Đăng nhập Google
- Quên mật khẩu
- Đăng xuất

### **Movie**
- Lấy danh sách phim đang chiếu & sắp chiếu (TMDB API)
- Tìm kiếm phim
- Lọc phim theo thể loại
- Xem chi tiết phim
- Xem trailer từ YouTube (TMDB video API)

### **Booking**
- Chọn rạp (từ Firestore)
- Chọn suất chiếu
- Chọn ghế (UI sơ đồ ghế)
- Tính giá vé
- Xác nhận đặt vé (lưu Firestore)

### **Payment**
- Chọn phương thức thanh toán (giả lập)
- Xác nhận thanh toán
- Lưu vé vào Firestore

### **Tickets**
- Xem danh sách vé đã đặt
- Xem chi tiết vé (QR code)
- Hủy vé

### **Profile**
- Xem thông tin cá nhân
- Cập nhật tên, avatar
- Đổi mật khẩu

---

## ✅ Yêu cầu môi trường

| Thành phần              | Phiên bản        |
|-------------------------|------------------|
| Flutter SDK             | 3.29.2           |
| Dart SDK                | 3.7.2            |
| Android Gradle Plugin   | 8.1.0            |
| Gradle Wrapper          | 8.10.2           |
| Android SDK             | API 35           |
| minSdkVersion           | 23               |
| NDK                     | 27.0.12077973    |
| CMake                   | 3.22.1           |

---

## 📦 Package cài đặt

### dependencies:
```yaml
flutter_bloc: ^8.1.5
hydrated_bloc: ^9.1.3
equatable: ^2.0.5

firebase_core: ^2.25.4
firebase_auth: ^4.17.4
cloud_firestore: ^4.15.4
firebase_storage: ^11.6.5
google_sign_in: ^6.2.1

http: ^0.14.0
json_annotation: ^4.8.1
cached_network_image: ^3.3.1
youtube_player_flutter: ^8.1.2
qr_flutter: ^4.1.0
uuid: ^4.3.3
intl: ^0.19.0
```


### dev_dependencies:
```yaml
build_runner: ^2.4.7
json_serializable: ^6.7.1
flutter_lints: ^3.0.1
```

💡 **Chạy**: `flutter pub get` sau khi thêm các package.

---

## 🚀 Cấu trúc Git

- `main`: Bản release ổn định
- `develop`: Nhánh tích hợp chung
- `feature/*`: Tính năng do mỗi người phát triển
- `hotfix/*`: Sửa lỗi khẩn cấp từ `main`

## ⚙️ Quy trình làm việc nhóm

```bash
# 1. Luôn pull develop mới nhất
git checkout develop
git pull origin develop

# 2. Tạo nhánh mới từ develop
git checkout -b feature/tinh-nang-moi

# 3. Cài đặt & chạy thử
flutter pub get
flutter run

# 4. Commit code
git add .
git commit -m "Thêm tính năng mới"

# 5. Push nhánh mới
git push origin feature/tinh-nang-moi

# 6. Tạo Pull Request → merge vào develop

# 7. Sau khi merge: pull develop mới nhất
git checkout develop
git pull origin develop
```

## ⚠️ Lưu ý tránh xung đột
Luôn làm việc trên nhánh riêng

Không commit file cấu hình cục bộ:

.idea/

.vscode/

local.properties

pubspec.lock (khi team dùng nhiều OS)

## 📁 Cấu trúc project Flutter (gợi ý với BLoC + module phim)

**Clean architecture**
```bash
lib/
├── main.dart
├── config/              # Cấu hình app, routes, theme
├── core/                # constants, utils, exceptions
├── data/                # models, repositories, data sources
│   ├── models/
│   ├── repositories/
│   └── sources/
├── presentation/
│   ├── blocs/           # BLoC & Cubit
│   │   ├── auth/
│   │   ├── movie/
│   │   ├── booking/
│   │   ├── payment/
│   │   ├── tickets/
│   │   └── profile/
│   ├── screens/
│   └── widgets/
└── services/            # Firebase, TMDB API, payment mock
```

**Feature-first**
```bash
lib/
├─ core/                        # Thành phần tái sử dụng toàn app
│ ├── constants/                # Hằng số (màu sắc, font, spacing, API key...)
│ ├── theme/                    # Quản lý Light/Dark theme
│ ├── utils/                    # Hàm helper (formatter, validator, extension)
│ ├── widgets/                  # Widget chung (button, input, loader, error, empty state)
│
├─ features/                    # Chia theo module (feature)
│ ├─ auth/                      # Module xác thực (login/register)
│ │ ├─ bloc/                    # (UI Logic Layer)
│ │ │ ├── auth_bloc.dart        # Quản lý toàn bộ state & logic Auth
│ │ │ ├── auth_event.dart       # Định nghĩa các sự kiện (LoginRequested, LogoutRequested...)
│ │ │ └── auth_state.dart       # Định nghĩa trạng thái (Unauthenticated, Authenticated, Loading...)
│ │ │
│ │ ├─ data/                    # (Data Layer - implement repository)
│ │ │ ├── models/               # Định nghĩa model data (UserModel...)
│ │ │ ├── datasources/          # Nguồn dữ liệu (Firebase, API, local storage)
│ │ │ └── auth_repository_impl.dart     # Triển khai AuthRepository dùng datasource
│ │ │
│ │ ├─ domain/                  # (Domain Layer - business logic thuần)
│ │ │ ├── entities/             # Định nghĩa entity (AppUser...) - dữ liệu thuần, không phụ thuộc lib ngoài
│ │ │ ├── repositories/ `       # Abstract AuthRepository - chỉ định nghĩa, không triển khai
│ │ │ └── usecases/             # Business logic cụ thể (LoginUseCase, RegisterUseCase...)
│ │ │
│ │ └─ presentation/            # (UI Layer) - màn hình, widget
│ │
│ ├─ booking/                   # Đặt vé (chọn rạp, suất chiếu, ghế, thanh toán)
│ ├─ movie/                     # Danh sách phim, chi tiết, trailer, tìm kiếm
│ ├─ payment/                   # Thanh toán
│ ├─ profile/                   # Hồ sơ người dùng
│ └─ tickets/                   # Vé của tôi
│
├─ app.dart                     # Cấu hình root app (theme, route, provider...)
└─ main.dart                    # Entry point của ứng dụng
```
---

## 🔄 Data Flow trong Clean Architecture
UI (Presentation) 
    ↓ events
BLoC (Business Logic)
    ↓ calls
Repository Interface (Domain)
    ↓ implements  
Repository Implementation (Data)
    ↓ calls
DataSource (Data)
    ↓ API/Database
External Services

---

## 🔧 Clone và khởi tạo

```bash
git clone https://github.com/HoangNightcore/TikNow.git
cd tik_now
flutter pub get
```

## 📦 Cài package mới
- Mọi người cần thông báo khi thêm package → để cả nhóm `flutter pub get`
- Hoặc cập nhật `pubspec.yaml` và commit rõ ràng