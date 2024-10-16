📝 Laporan Minggu Keempat Mobile & Web Service Praktik Kelas IX
=============================================================

**Nama**: Tito Zaki Saputro
**NPM**: 5220411045

* * * * *

# Daftar Isi

1. [Pendahuluan](#pendahuluan)  
2. [Penjelasan](#penjelasan)  
   1. [Struktur](#1-struktur)  
   2. [Main Function](#2-main-function)  
      - [main.dart](#main)  
   3. [Models](#3-models)  
      - [data.dart](#data)  
   4. [Pages](#4-pages)  
      - [home_screen.dart](#home_screendart)  
      - [main_screen.dart](#main_screendart)  

* * * * *
# Pendahuluan
Pada minggu-4 diberikan tugas untuk slicing ui bertema food app . terdapat login section dan home section. berikut laporan dari tugas minggu-4.

# Penjelasan
## 1. Struktur 
![struktur direktori](/week_4/images/struktur.png)<br>
Dari struktur diatas saya membedakan dua direktori yang pertama direktori **models** untuk menyimpan data dan direktori **pages** untuk halaman-halaman dari app.
## 2. main function
### main
```dart
// lib/main.dart

import 'package:flutter/material.dart';
import 'package:minggu_4/pages/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Widget App Demo',
        theme: ThemeData(
          // Ubah warna tema utama menjadi kuning
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const HomeScreen());
  }
}

```

### Penjelasan
**`class MyApp`**:

-   Entry point utama aplikasi, dengan `MaterialApp` yang mengatur tema aplikasi dan halaman awal.
-   **`theme`**:
    -   Menggunakan `ColorScheme.fromSeed` dengan warna kuning sebagai tema utama, yang memberikan nuansa konsisten pada UI.
-   **`home`**:
    -   Mengarahkan ke halaman `HomeScreen` sebagai halaman pertama yang dilihat pengguna.
## 3. models
### data
```dart
// lib/models/data.dart
class Data {
  String? nama; //untuk menyimpan nama
  String? npm; //untuk menyimpan npm
  String? password; //untuk menyimpan passsowrd

  Data({this.nama, this.npm, this.password});
}
```
### Penjelasan
**`class Data`**:

-   Model yang digunakan untuk menyimpan data pengguna, seperti `nama`, `npm`, dan `password`.
-   Constructor `Data({this.nama, this.npm, this.password})` memungkinkan inisialisasi dari ketiga field tersebut.
-   **Fields**:
    -   `String? nama`: Menyimpan nama pengguna.
    -   `String? npm`: Menyimpan NPM pengguna.
    -   `String? password`: Menyimpan password pengguna.

## 4. Pages
### home_screen.dart
Pada halaman ini adalah halaman unttuk login
#### controller
```dart
class _HomeScreenState extends State<HomeScreen> {
  final npmController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController(); 

  @override
  void dispose() {
    npmController.dispose();
    nameController.dispose();
    passwordController.dispose(); 
    super.dispose();
  }
```
**`npmController`, `nameController`, `passwordController`**:
controller tersebut menggunakan `TextEditingController` yang digunakan untuk menangkap input pengguna dari text fields.

#### error dialog
```dart
 // Method untuk menampilkan pesan kesalahan
  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),// text error
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

```
Method untuk menampilkan dialog error ketika ada input yang kosong. Menggunakan showDialog bawaan dari Flutter.

#### Widget Tree
<br> ![image widget](/week_4/images/home.png)<br>

```dart
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            // Text Selamat Datang di Angkringan Podomoro
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Selamat Datang di Angkringan Podomoro",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFC107), // Warna kuning
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Gambar ilustrasi login
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Image.asset(
                './public/password.png', // Ganti dengan path gambar ilustrasi
                height: 400,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            // Form Input Nama
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.yellow.shade50, // Warna input jadi kuning
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // Shadow positioning
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: "Nama",
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      hintText: "Masukkan nama...",
                      border: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                    controller: nameController,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Form Input NPM
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.yellow.shade50,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // Shadow positioning
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: "NPM",
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      hintText: "Masukkan NPM...",
                      border: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                    controller: npmController,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Form Input Password
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.yellow.shade50,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // Shadow positioning
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    obscureText: true, // Mengatur text menjadi tersembunyi
                    decoration: const InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      hintText: "Masukkan password...",
                      border: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                    controller: passwordController,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Tombol Login
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color:
                      Colors.yellow.shade700, // Warna tombol jadi kuning gelap
                  boxShadow: [
                    BoxShadow(
                      color: Colors.yellow.shade600.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // Shadow positioning
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () {
                    // Validasi apakah input kosong
                    if (nameController.text.isEmpty ||
                        npmController.text.isEmpty ||
                        passwordController.text.isEmpty) {
                      showErrorDialog(
                          "Nama, NPM, dan Password tidak boleh kosong!"); // Tampilkan pesan error jika ada yang kosong
                    } else {
                      // Buat objek Data dengan nama dan NPM yang diinput
                      Data userData = Data(
                        nama: nameController.text,
                        npm: npmController.text,
                        password: passwordController
                            .text, // Include password in the Data object
                      );

                      // Navigasi ke MainScreen dengan mengirimkan objek Data
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MainScreen(data: userData),
                        ),
                      );

                      // Clear input setelah login
                      npmController.clear();
                      nameController.clear();
                      passwordController
                          .clear(); // Clear password setelah login
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.login,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
```
Berikut Penjelasan mengenai widget tree pada **home_screen Widget Tree**:

1.  **`Scaffold`**:
    -   Menjadi layout utama halaman ini, dengan `body` berupa `SingleChildScrollView` untuk memungkinkan halaman di-scroll.
2.  **`Column`**:
    -   Mengorganisasi elemen-elemen UI seperti teks, gambar, dan input field dalam bentuk kolom secara vertikal.
3.  **`Padding`**:
    -   Menambahkan jarak sekitar elemen-elemen seperti teks dan input field untuk tata letak yang lebih rapi.
4.  **`TextField`**:
   <br> ![text field](/week_4/images/text_field.png) <br>
    -   Input form untuk `Nama`, `NPM`, dan `Password` dengan masing-masing `controller` untuk menangkap input pengguna.
    -   **Decorations**:
        -   Menggunakan warna kuning untuk menunjukkan gaya branding halaman.
5.  **`TextButton`**:
   <br> ![button](/week_4/images/text_button.png)<br>
    -   Tombol untuk login. Ketika ditekan, akan memvalidasi input dan mengarahkan pengguna ke `MainScreen` jika berhasil.
6.  **`Text`**:
   <br> ![text](/week_4/images/text.png)<br>
    -   Merupakan widget untuk menampilkan text `Selamat Datang di Angkringan Podomoro `
7. **`Image`** : 
   <br> ![image widget](/week_4/images/gambar.png)<br>
    - Untuk menampilkan gambar

### main_screen.dart
Merupakan halaman utama setelah login. Menggunakan `StatelessWidget` karena datanya sudah diterima dari `HomeScreen` dan tidak berubah.-   Menerima parameter `Data` untuk menampilkan nama pengguna.

```dart
// lib/pages/main_screen.dart

import 'package:flutter/material.dart';
import 'package:minggu_4/models/data.dart'; // Import model Data

class MainScreen extends StatelessWidget {
  final Data data; // Terima objek Data

  const MainScreen({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryYellow = Color(0xFFFFC107); // Define yellow color

    return Scaffold(
      backgroundColor: Colors.white, // Light background for better contrast
      appBar: AppBar(
        backgroundColor: primaryYellow,
        title: const Text('Angkringan Podomoro',
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Profile Picture and Greeting in a Row layout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar image with shadow
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(
                      './public/gigachad.jpg', // Replace with your profile image path
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(width: 16),
                  // Text greeting with yellow accent
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hallo, ${data.nama}', // Use data.nama
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primaryYellow,
                          ),
                        ),
                        const Text(
                          'Selamat Pagi.',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Large food image with rounded corners and shadow
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    './public/foods.png', // Replace with your food image path
                    height: 400,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // List of food with images and prices
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daftar Makanan:',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryYellow,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      ListTile(
                        leading: Image(
                          image: AssetImage(
                              './public/burger.jpeg'), // Replace with food icon
                          width: 40,
                          height: 40,
                        ),
                        title: Text(
                          'Burger',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text('Rp23.000'),
                        trailing:
                            Icon(Icons.arrow_forward_ios, color: primaryYellow),
                      ),
                      ListTile(
                        leading: Image(
                          image: AssetImage(
                              './public/bakso.png'), // Replace with food icon
                          width: 40,
                          height: 40,
                        ),
                        title: Text(
                          'Bakso',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text('Rp15.000'),
                        trailing:
                            Icon(Icons.arrow_forward_ios, color: primaryYellow),
                      ),
                      ListTile(
                        leading: Image(
                          image: AssetImage(
                              './public/mie.png'), // Replace with food icon
                          width: 40,
                          height: 40,
                        ),
                        title: Text(
                          'Mie Ayam',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text('Rp17.000'),
                        trailing:
                            Icon(Icons.arrow_forward_ios, color: primaryYellow),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Button to explore more food options

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
```

#### Widget Tree
##### `Scaffold`

-   Widget dasar yang digunakan untuk membuat struktur layar. Di dalamnya terdapat `AppBar` dan `body`, yang membentuk kerangka dasar halaman.
    -   **`backgroundColor: Colors.white`**: Mengatur warna latar belakang layar menjadi putih untuk memberikan kontras yang lebih baik.

##### `AppBar`
<br>![appbar](/week_4/images/appbar.png)<br>
-   Menampilkan bilah di bagian atas layar yang berisi judul dan branding aplikasi.
    -   **`backgroundColor: primaryYellow`**: Mengatur warna latar belakang AppBar menjadi kuning, sesuai dengan tema aplikasi.
    -   **`title: Text('Angkringan Podomoro')`**: Menampilkan teks judul berwarna putih.
    -   **`centerTitle: true`**: Menempatkan judul di tengah AppBar.

##### `SingleChildScrollView`

-   Membuat seluruh konten di layar dapat digulir (scroll), sehingga jika konten lebih panjang dari tinggi layar, pengguna bisa menggulir untuk melihat semua elemen.

##### `Column`

-   Widget tata letak yang mengatur widget anaknya dalam urutan vertikal. Ini adalah wadah utama yang memuat seluruh konten halaman ini.

##### `SizedBox(height: 24)`

-   Menambahkan jarak vertikal antara widget, menciptakan ruang antara `AppBar` dan bagian profil.

##### `Padding`

-   Menambahkan padding (jarak) di sekitar widget anaknya. Pada contoh ini, padding digunakan untuk memberikan jarak horizontal di sekitar `Row` dan daftar makanan.
    -   **`padding: EdgeInsets.symmetric(horizontal: 16)`**: Menambahkan padding horizontal sebesar 16 piksel di kiri dan kanan.

##### `Row`

-   Menata widget anaknya (foto profil dan teks sapaan) dalam susunan horizontal.
    -   **`crossAxisAlignment: CrossAxisAlignment.center`**: Menyelaraskan widget secara vertikal di tengah baris.

##### `CircleAvatar`
<br>![appbar](/week_4/images/chad.png)<br>

-   Widget berbentuk lingkaran yang digunakan untuk menampilkan gambar profil pengguna.
    -   **`radius: 40`**: Mengatur ukuran lingkaran sebesar 40 piksel.
    -   **`backgroundImage: AssetImage('./public/gigachad.jpg')`**: Menampilkan gambar dari berkas lokal sebagai foto profil.

##### `SizedBox(width: 16)`

-   Menambahkan jarak horizontal antara gambar profil dan teks sapaan.

##### `Expanded`

-   Memungkinkan kolom teks mengambil sisa ruang horizontal di dalam `Row`, sehingga teks tidak tumpang tindih dengan foto profil.

##### `Text`
<br>![appbar](/week_4/images/tito.png)<br>
-   Menampilkan pesan sapaan kepada pengguna.
    -   **`Text('Hallo, ${data.nama}')`**: Menampilkan sapaan personal dengan nama yang diambil dari variabel `data.nama`.
    -   **`Text('Selamat Pagi.')`**: Menampilkan teks sapaan "Selamat Pagi" dengan warna abu-abu.

##### `Container`

-   Wadah yang digunakan untuk menambahkan dekorasi (seperti bayangan dan sudut melengkung) di sekitar gambar.
    -   **`decoration: BoxDecoration`**: Menambahkan bayangan dan sudut melengkung pada wadah.
        -   **`borderRadius: BorderRadius.circular(16)`**: Membuat sudut gambar menjadi melengkung.
        -   **`BoxShadow`**: Menambahkan bayangan di sekitar wadah untuk memberikan efek kedalaman.

##### `ClipRRect`
<br>![appbar](/week_4/images/burger.png)<br>

-   Memotong gambar agar sesuai dengan bentuk sudut yang melengkung.
    -   **`borderRadius: BorderRadius.circular(16)`**: Memastikan gambar yang dipotong memiliki sudut melengkung.
    -   **`Image.asset('./public/foods.png')`**: Menampilkan gambar makanan utama yang disesuaikan untuk memenuhi lebar layar dengan sudut melengkung.

##### `ListView`
<br>![appbar](/week_4/images/list.png)<br>

-   Daftar bergulir yang berisi item makanan. `shrinkWrap: true` memastikan tinggi daftar disesuaikan dengan kontennya.
    -   **`physics: NeverScrollableScrollPhysics()`**: Menonaktifkan kemampuan daftar untuk digulir karena seluruh halaman sudah bisa digulir.

##### `ListTile`
<br>![appbar](/week_4/images/list.png)<br>

-   Mewakili setiap item makanan dalam daftar dengan gambar, judul, subjudul (harga), dan ikon navigasi.
    -   **`leading: Image.asset()`**: Menampilkan ikon makanan di sebelah kiri.
    -   **`title: Text()`**: Menampilkan nama makanan dalam teks tebal.
    -   **`subtitle: Text()`**: Menampilkan harga makanan.
    -   **`trailing: Icon()`**: Menampilkan ikon panah berwarna kuning yang menunjukkan lebih banyak detail.

##### `SizedBox(height: 24)`

-   Menambahkan jarak di bagian bawah halaman untuk memisahkan daftar makanan dari bagian bawah layar atau widget lainnya.

<br>![appbar](/week_4/images/main_screens.png)<br>
