# Yemek Siparişi Uygulaması (Dumanlı Tarifler)

Bu proje, bir AI Koordinatörlüğü başvurusu için geliştirilmiş tam kapsamlı (Full-Stack) bir yemek siparişi uygulamasıdır.

## Proje Yapısı

- **YemekSiparisi.Api**: C# .NET Core 8.0 Web API ile geliştirilmiş backend projesi. Entity Framework Core ve SQL Server kullanır.
- **yemek_siparisi_app**: Flutter ile geliştirilmiş modern mobil uygulama.

## Kurulum ve Çalıştırma

### 1. Veritabanı Hazırlığı
Backend projesi SQL Server kullanmaktadır. `YemekSiparisi.Api/appsettings.json` dosyasındaki `ConnectionStrings` bölümünü kendi yerel SQL Server ayarlarınıza göre güncelleyin.

Ardından terminalde şu komutu çalıştırarak veritabanını oluşturun:
```bash
cd YemekSiparisi.Api
dotnet ef database update
```

### 2. Backend (API) Başlatma
API'yi çalıştırmak için:
```bash
dotnet run
```
API varsayılan olarak `http://localhost:5000` adresinde çalışacaktır.

### 3. Mobil Uygulama (Flutter) Başlatma
Flutter uygulamasını çalıştırmadan önce bağımlılıkları yükleyin:
```bash
cd yemek_siparisi_app
flutter pub get
```

Ardından uygulamayı başlatın:
```bash
flutter run
```

**Not:** Android Emülatör kullanıyorsanız, uygulama otomatik olarak `10.0.2.2:5000` adresine bağlanacak şekilde ayarlanmıştır. Fiziksel cihaz kullanıyorsanız, bilgisayarınızın yerel IP adresini `lib/services/api_service.dart` dosyasında güncellemeniz veya `adb reverse` kullanmanız gerekebilir.

## Özellikler
- JWT Tabanlı Kimlik Doğrulama (Kayıt Ol / Giriş Yap)
- Restoran ve Menü Listeleme
- Kategoriye Göre Filtreleme ve Arama
- Sepet Sistemi ve Sipariş Oluşturma
- Sipariş Geçmişi Takibi
- Favori Restoranlar
- Admin Paneli (Sipariş Durumu Güncelleme)

## Kullanılan Teknolojiler
- **Backend:** .NET 8.0, Entity Framework Core, SQL Server, JWT
- **Mobil:** Flutter, Provider/State Management, HTTP
