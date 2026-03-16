# Mini Katalog (Flutter)

Android/iOS için geliştirilen mini e-katalog uygulaması.

## Özellikler
- Ürünleri API'den çekme (primary + fallback endpoint)
- Arama ve kategori filtreleme
- Ürün detay ekranı
- Sepete ekleme/çıkarma ve adet yönetimi
- Shimmer loading kartları
- Provider ile state management

## Teknik İyileştirmeler
- API parse/hata yönetimi güçlendirildi
- Route argüman güvenliği eklendi
- Boş sepetten "Keşfet" akışı düzeltildi
- Lint kuralları (`analysis_options.yaml`) eklendi
- Temel birim testleri eklendi
- GitHub Actions CI (`flutter analyze`, `flutter test`) eklendi
- MIT lisansı eklendi

## Kurulum
```bash
flutter pub get
flutter run
```

## Test ve Analiz
```bash
flutter analyze
flutter test
```

## Proje Yapısı
```text
lib/
  main.dart
  models/
  providers/
  screens/
  services/
  theme/
  widgets/
```

## Teslim Notu
Formdaki "Yalnızca Github bağlantısı" alanı için bu reponun public linki kullanılmalıdır.
Ekran görüntüsü yükleme alanına da uygulamadan alınan ekran görselleri eklenmelidir
(Ana Sayfa, Ürün Listesi, Ürün Detayı).

## Lisans
[MIT](LICENSE)
