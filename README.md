# Dumanlı Tarifler - Full-Stack Yemek Sipariş Platformu 🥘🚀

Bu proje, modern bir yemek sipariş platformunun tüm katmanlarını (Backend, Mobile, Database) kapsayan, profesyonel standartlarda geliştirilmiş bir **Full-Stack** uygulamadır. Proje; .NET 8 Web API, Flutter (Dart) ve SQL Server teknolojileri üzerine inşa edilmiştir.

## ✨ Öne Çıkan Özellikler

- **Gelişmiş Kimlik Doğrulama:** JWT (JSON Web Token) tabanlı güvenli oturum yönetimi ve Rol Tabanlı Erişim Kontrolü (Admin/Müşteri).
- **Gerçek Zamanlı Bildirimler:** Sipariş durumu değişikliklerinde (Hazırlanıyor, Yolda, Teslim Edildi) kullanıcıya anlık bildirim gönderimi.
- **Dinamik Sepet Yönetimi:** Çoklu restorandan aynı anda ürün ekleme desteği ve otomatik sipariş gruplama.
- **Akıllı Kupon Sistemi:** Tek kullanımlık indirim kodları (Örn: `BEDAVA2344` - %50 İndirim).
- **Admin Dashboard:** Toplam ciro, kullanıcı sayısı ve sipariş istatistiklerinin anlık takibi.
- **Lokasyon Entegrasyonu:** İl, ilçe ve mahalle bazlı dinamik adres yönetim sistemi.
- **Favoriler ve Arama:** Restoranları favorilere ekleme ve ürün bazlı global arama motoru.

---

## 🛠️ Teknolojiler

- **Backend:** .NET 8.0 Web API, Entity Framework Core
- **Database:** Microsoft SQL Server
- **Mobile:** Flutter (Dart)
- **Güvenlik:** JWT Bearer Authentication
- **Mimari:** Katmanlı Mimari (N-Tier) & Repository Pattern prensipleri

---

## 🚀 Kurulum ve Çalıştırma Talimatları

### 1. Backend (API) Kurulumu

1.  **Veritabanı Yapılandırması:** `YemekSiparisi.Api/appsettings.json` dosyasını açın ve `ConnectionStrings` bölümünü kendi SQL Server instance bilgilerinize göre güncelleyin:
    ```json
    "DefaultConnection": "Server=YOUR_SERVER_NAME;Database=YemekSiparisi_DB;Trusted_Connection=True;TrustServerCertificate=True;"
    ```
2.  **Veritabanını Oluşturma:** Terminalde API dizinine giderek aşağıdaki komutları çalıştırın (Migration'ların işlenmesi ve Seed verilerin yüklenmesi için):
    ```bash
    dotnet ef database update
    ```
3.  **API'yi Çalıştırma:** 
    ```bash
    dotnet run
    ```
    *API varsayılan olarak `http://localhost:5000` portundan hizmet verecektir.*

### 2. Mobile (Flutter) Kurulumu

1.  **Bağımlılıkları Yükleme:** Mobil uygulama dizininde şu komutu çalıştırın:
    ```bash
    flutter pub get
    ```
2.  **API Bağlantı Ayarı:** `lib/services/api_service.dart` dosyasını açın. Eğer emülatör veya fiziksel cihaz üzerinden yerel API'ye bağlanacaksanız `baseUrl` değerini kendi yerel IP adresiniz veya `http://localhost:5000/api` olarak güncelleyin.
3.  **Uygulamayı Çalıştırma:**
    ```bash
    flutter run
    ```

---

## 🛡️ Admin Erişimi

Sisteme kayıt olan **ilk kullanıcı** otomatik olarak `Admin` rolüne sahip olur. Admin yetkisiyle giriş yapıldığında, profil sayfasında **"Yönetici Paneli"** butonu aktifleşecektir. Bu panelden tüm siparişleri yönetebilir ve sistem istatistiklerini görüntüleyebilirsiniz.

---

## 📜 Lisans ve Notlar

Bu proje, Yapay Zeka Koordinatörlüğü ve modern uygulama geliştirme standartları göz önünde bulundurularak hazırlanmıştır. Tüm görseller ve veriler profesyonel bir kullanıcı deneyimi sunmak adına özenle seçilmiştir.

---
*Geliştirici: Elif Duman*
