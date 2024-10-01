# 📝 Laporan Minggu Kedua Mobile & Web Service Praktik Kelas IX

**Nama**: Tito Zaki Saputro  
**NPM**: 5220411045


---

## Pendahuluan

Pada minggu kedua ini, saya mempelajari framework **Flutter** untuk pengembangan aplikasi mobile. untuk **IDE** yang saya gunakan adalah **Visual Studio Code** dan untuk virtual device nya saya menggunakan *Pixel 8 Pro* dari **Android Studio**

## 🤔 Apa itu WIDGET ?
Widget merupakan komponen yang sangat penting dalam Flutter. Setiap elemen dalam antarmuka pengguna Flutter adalah sebuah widget. Dari tombol sederhana hingga seluruh layar aplikasi, semuanya dibangun menggunakan widget.

## Stateless Widget dan Stateful Widget 
Ada dua widget utama di dalam flutter yaitu Stateless Widget dan Stateful Widget
###  Stateless Widget 🗿
Widget ini bersifat tidak dapat berubah atau static, artinya setelah dibangun, mereka tidak dapat mengubah tampilan mereka sebagai respons terhadap peristiwa atau interaksi pengguna. Widget ini cocok digunakan untuk komponen UI yang tidak perlu berubah secara dinamis.
### Stateful Widget 🧩
Widget ini dapat mengubah tampilan mereka sebagai respons terhadap peristiwa atau interaksi pengguna. Mereka mempertahankan status yang dapat berubah seiring waktu. Widget ini cocok untuk komponen UI yang merespons interaksi pengguna atau perubahan data.

### MaterialApp Wdiget 🌐
MaterialApp adalah widget inti dalam aplikasi Flutter yang menyediakan beberapa fitur penting seperti tema, routing, dan pengaturan navigasi. MaterialApp secara default mendukung Material Design, yang merupakan standar desain dari Google.
```dart
MaterialApp(
  title: 'Belajar App',
  theme: ThemeData(
    primarySwatch: Colors.blue, // Menentukan tema aplikasi
  ),
  home: const BelajarHomePage(title: 'Belajar Widget Flutter'), // Halaman utama
)

```
MaterialApp menyediakan elemen-elemen inti untuk tampilan aplikasi, termasuk tema dan navigasi halaman.
### Scaffold Wdiget 🏗️
Scaffold adalah widget yang menyediakan struktur dasar aplikasi, seperti bagian untuk **AppBar**, **Drawer**, dan **FloatingActionButton**. Ini sangat berguna untuk membangun tata letak aplikasi berbasis **Material Design**.
```dart
Scaffold(
  appBar: AppBar(
    title: Text('Judul Aplikasi'), // Bar atas aplikasi
  ),
  body: Center(
    child: Text('Isi aplikasi di sini!'), // Bagian utama aplikasi
  ),
  floatingActionButton: FloatingActionButton(
    onPressed: _incrementCounter, // Tombol aksi mengambang
    child: Icon(Icons.add),
  ),
)

```