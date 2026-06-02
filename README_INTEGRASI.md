# 📂 Bagian Miftah - Finlimit
## File yang perlu ditambahkan ke project:

```
lib/
├── models/
│   └── transaction_model.dart       ← BARU
├── database/
│   └── database_helper.dart         ← BARU
├── viewmodels/
│   ├── transaction_viewmodel.dart   ← BARU
│   └── settings_viewmodel.dart      ← BARU
├── widgets/
│   └── transaction_card.dart        ← BARU
├── views/
│   ├── transaction_history_screen.dart  ← BARU
│   └── settings_screen.dart             ← BARU
└── main.dart                        ← UPDATE (tambah MultiProvider)
```

---

## 🔧 Langkah Integrasi

### 1. Update pubspec.yaml
Tambahkan dependencies berikut di bagian `dependencies:`:
```yaml
provider: ^6.1.2
sqflite: ^2.3.3+1
path: ^1.9.0
```
Lalu jalankan:
```bash
flutter pub get
```

### 2. Copy semua file ke folder lib/
Salin semua file sesuai struktur di atas ke dalam folder `lib/` project.

### 3. Update main.dart
Ganti isi `main.dart` dengan versi yang sudah disediakan (ada MultiProvider).

### 4. Hubungkan ke Bottom Navigation
Di file home/dashboard (milik Ariel), tambahkan navigasi ke halaman Miftah:
```dart
import 'package:finlimit/views/transaction_history_screen.dart';
import 'package:finlimit/views/settings_screen.dart';

// Contoh di BottomNavigationBar:
case 2: return const TransactionHistoryScreen();
case 3: return const SettingsScreen();
```

### 5. Untuk Nabil (Auth) - Logout
Di `settings_screen.dart` bagian `_showLogoutDialog`, ada komentar:
```dart
// TODO: Nabil - tambahkan logika logout di sini
// Contoh: Navigator.pushAndRemoveUntil ke LoginScreen
```
Ganti dengan navigasi ke LoginScreen milik Nabil.

---

## 📦 Dependencies yang Digunakan
| Package | Versi | Fungsi |
|---------|-------|--------|
| provider | ^6.1.2 | State management |
| sqflite | ^2.3.3+1 | Database SQLite |
| path | ^1.9.0 | Path helper untuk database |

---

## ✅ Fitur yang Sudah Dibuat

### 🕒 Transaction History
- Tampil semua transaksi dikelompokkan per tanggal
- Filter: Semua / Pengeluaran / Pemasukan
- Summary total pengeluaran & pemasukan di header
- Hapus transaksi dengan konfirmasi dialog
- Empty state jika belum ada transaksi
- Icon & warna berbeda per kategori

### ⚙️ Settings
- Edit profil (nama, email, telepon)
- Pengaturan dompet (nama, limit harian, limit bulanan)
- Toggle mode gelap
- Toggle notifikasi
- Ganti mata uang
- Tentang aplikasi
- Logout (koneksi ke Nabil)

---
*Dibuat oleh: Miftah Farid*
