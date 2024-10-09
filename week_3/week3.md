📝 Laporan Minggu Ketiga Mobile & Web Service Praktik Kelas IX
=============================================================

**Nama**: Tito Zaki Saputro\
**NPM**: 5220411045

* * * * *

Daftar Isi
----------

- [📝 Laporan Minggu Ketiga Mobile \& Web Service Praktik Kelas IX](#-laporan-minggu-ketiga-mobile--web-service-praktik-kelas-ix)
  - [Daftar Isi](#daftar-isi)
  - [Pendahuluan](#pendahuluan)
  - [Penjelasan Widget yang Digunakan](#penjelasan-widget-yang-digunakan)
    - [MaterialApp](#materialapp)
      - [Contoh Kode:](#contoh-kode)
    - [StatelessWidget](#statelesswidget)
      - [Contoh Kode:](#contoh-kode-1)
    - [StatefulWidget](#statefulwidget)
      - [Contoh Kode:](#contoh-kode-2)
    - [AppBar](#appbar)
      - [Contoh Kode:](#contoh-kode-3)
    - [Scaffold](#scaffold)
      - [Contoh Kode:](#contoh-kode-4)
    - [TextField](#textfield)
      - [Contoh Kode:](#contoh-kode-5)
    - [ListView dan GridView](#listview-dan-gridview)
      - [Contoh Kode:](#contoh-kode-6)
    - [Slidable](#slidable)
      - [Contoh Kode:](#contoh-kode-7)
    - [Checkbox](#checkbox)
      - [Contoh Kode:](#contoh-kode-8)
- [Dokumentasi Error](#dokumentasi-error)
    - [Error 1: Kesalahan pada Implementasi `TextField` Controller](#error-1-kesalahan-pada-implementasi-textfield-controller)
      - [Deskripsi Error:](#deskripsi-error)
      - [Kode saat Error:](#kode-saat-error)
      - [Solusi Perbaikan:](#solusi-perbaikan)
      - [Kode setelah Perbaikan:](#kode-setelah-perbaikan)
    - [Error 2: Kesalahan pada Implementasi `ListView.builder`](#error-2-kesalahan-pada-implementasi-listviewbuilder)
      - [Deskripsi Error:](#deskripsi-error-1)
      - [Kode saat Error:](#kode-saat-error-1)
      - [Solusi Perbaikan:](#solusi-perbaikan-1)
      - [Kode setelah Perbaikan:](#kode-setelah-perbaikan-1)
    - [Error 3: Kesalahan pada Fungsi `toggleViewMode`](#error-3-kesalahan-pada-fungsi-toggleviewmode)
      - [Deskripsi Error:](#deskripsi-error-2)
      - [Kode saat Error:](#kode-saat-error-2)
      - [Solusi Perbaikan:](#solusi-perbaikan-2)
      - [Kode setelah Perbaikan:](#kode-setelah-perbaikan-2)
- [Penutup](#penutup)
- [Referensi](#referensi)

* * * * *

Pendahuluan
-----------

Aplikasi Flutter yang saya bangun adalah aplikasi To-do sederhana dengan fitur pengeditan, penghapusan, dan penambahan tugas. Aplikasi ini menggunakan berbagai widget dari Flutter untuk membangun antarmuka pengguna yang interaktif dan responsif. Dalam laporan ini, saya akan menjelaskan setiap widget yang digunakan dalam kode aplikasi saya.

* * * * *

Penjelasan Widget yang Digunakan
--------------------------------

### MaterialApp

`MaterialApp` adalah widget utama dalam Flutter yang mengatur pengaturan global aplikasi, seperti rute, tema, dan pengaturan navigasi. Pada aplikasi ini, `MaterialApp` digunakan untuk mendefinisikan struktur dan rute aplikasi.

#### Contoh Kode:

```dart
return MaterialApp(
      debugShowCheckedModeBanner:
          false, // Menyembunyikan label debug di pojok kanan atas
      initialRoute: '/', // Rute awal atau halaman pertama saat aplikasi dibuka
      routes: {
        '/': (context) => const HomePage(), // Rute ke halaman HomePage
        '/edit': (context) =>
            const EditTaskPage(), // Rute ke halaman EditTaskPage
      },
    );
```

Pada contoh di atas, `MaterialApp` digunakan untuk menentukan halaman awal dan mendefinisikan rute ke halaman lain, seperti `HomePage` dan `EditTaskPage`.

### StatelessWidget

`StatelessWidget` adalah widget yang tidak memiliki state dan bersifat statis. Aplikasi saya menggunakan `StatelessWidget` untuk beberapa widget yang tidak memerlukan perubahan data, seperti widget `MyApp` dan `TodoList`.

#### Contoh Kode:

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor dengan key opsional

  @override
  Widget build(BuildContext context) {
    // Menggunakan MaterialApp untuk mengatur tema dan struktur aplikasi
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, // Menyembunyikan label debug di pojok kanan atas
      initialRoute: '/', // Rute awal atau halaman pertama saat aplikasi dibuka
      routes: {
        '/': (context) => const HomePage(), // Rute ke halaman HomePage
        '/edit': (context) =>
            const EditTaskPage(), // Rute ke halaman EditTaskPage
      },
    );
  }
}

```

Di sini, `MyApp` adalah `StatelessWidget` yang hanya mendefinisikan rute tanpa ada perubahan state.

### StatefulWidget

`StatefulWidget` digunakan ketika widget perlu menyimpan atau mengubah state. Dalam aplikasi ini, `StatefulWidget` digunakan pada halaman `HomePage` dan `EditTaskPage`, yang membutuhkan interaksi pengguna untuk mengubah daftar to-do.

#### Contoh Kode:

```dart
// HomePage adalah widget Stateful yang menampilkan halaman utama dari aplikasi To-do
class HomePage extends StatefulWidget {
  const HomePage({super.key}); // Konstruktor dengan key opsional

  @override
  State<HomePage> createState() =>
      _HomePageState(); // Menghubungkan HomePage dengan state
}
```

Pada contoh di atas, `HomePage` adalah `StatefulWidget` yang mengelola state dari daftar to-do dan mengatur interaksi dengan pengguna.

### AppBar

`AppBar` adalah bagian atas dari aplikasi yang biasanya berisi judul dan ikon tindakan. Pada aplikasi ini, `AppBar` digunakan untuk menampilkan judul aplikasi dan tombol untuk mengganti mode tampilan.

#### Contoh Kode:

```dart
appBar: AppBar(
        title: const Text('Simple Todo'), // Judul di AppBar
        backgroundColor: Colors.deepPurple, // Warna latar belakang AppBar
        actions: [
          // Tombol untuk mengganti mode tampilan antara GridView dan ListView
          IconButton(
            icon: Icon(isGridView
                ? Icons.list
                : Icons.grid_view), // Ikon berubah sesuai mode tampilan
            onPressed:
                toggleViewMode, // Memanggil fungsi toggleViewMode saat ditekan
          ),
        ],
      ),
```

`AppBar` di atas menampilkan judul aplikasi dan ikon yang berfungsi untuk mengubah tampilan antara `ListView` dan `GridView`.

### Scaffold

`Scaffold` adalah widget dasar dalam Flutter yang menyediakan struktur dasar untuk halaman seperti AppBar, Body, dan FloatingActionButton. Aplikasi ini menggunakan `Scaffold` untuk mengatur tata letak halaman, termasuk menampilkan `AppBar`, daftar to-do, dan tombol aksi.

#### Contoh Kode:

```dart
return Scaffold(
      backgroundColor:
          Colors.deepPurple.shade300, // Mengatur warna latar belakang
      appBar: AppBar(
        title: const Text('Simple Todo'), // Judul di AppBar
        backgroundColor: Colors.deepPurple, // Warna latar belakang AppBar
        actions: [
          // Tombol untuk mengganti mode tampilan antara GridView dan ListView
          IconButton(
            icon: Icon(isGridView
                ? Icons.list
                : Icons.grid_view), // Ikon berubah sesuai mode tampilan
            onPressed:
                toggleViewMode, // Memanggil fungsi toggleViewMode saat ditekan
          ),
        ],
      ),
```

Pada contoh ini, `Scaffold` digunakan untuk membungkus seluruh elemen halaman, termasuk AppBar, body (yang berisi daftar to-do), dan `FloatingActionButton`.

### TextField

`TextField` digunakan untuk mengambil input teks dari pengguna. Pada aplikasi ini, `TextField` digunakan untuk menambahkan tugas baru dan mengedit tugas yang sudah ada.

#### Contoh Kode:
```dart
child: TextField(
    controller:
        _controller, // Menghubungkan controller dengan input teks
    decoration: InputDecoration(
    hintText: 'tambahkan to do list kamu', // Placeholder input
    filled: true,
    fillColor: Colors
        .deepPurple.shade200, // Warna latar belakang input
    enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
        color:
            Colors.deepPurple, // Warna border saat tidak fokus
        ),
        borderRadius:
            BorderRadius.circular(15), // Membuat sudut melengkung
    ),
    focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
        color: Colors.deepPurple, // Warna border saat fokus
        ),
        borderRadius:
            BorderRadius.circular(15), // Membuat sudut melengkung
    ),
    ),
),
```

Pada contoh ini, `TextField` mengambil input dari pengguna, misalnya untuk menambahkan tugas baru ke daftar to-do.

### ListView dan GridView

`ListView` dan `GridView` digunakan untuk menampilkan daftar item. Aplikasi ini menyediakan dua mode tampilan: `ListView` untuk menampilkan tugas dalam satu kolom dan `GridView` untuk menampilkan tugas dalam dua kolom.

#### Contoh Kode:
contoh dari listview : 
```dart
ListView.builder(
    itemCount: toDoList.length, // Jumlah item dalam ListView
    itemBuilder: (BuildContext context, int index) {
    // Menampilkan setiap tugas dalam bentuk TodoList di dalam ListView
    return TodoList(
        taskName: toDoList[index][0], // Nama tugas
        taskCompleted: toDoList[index]
            [1], // Status penyelesaian tugas
        onChanged: (value) => checkBoxChanged(
            index), // Fungsi untuk mengubah status checkbox
        deleteFunction: (context) =>
            deleteTask(index), // Fungsi untuk menghapus tugas
        editFunction: () =>
            navigateToEditTask(index), // Fungsi untuk mengedit tugas
    );
    },
),
```
contoh dari gridview : 
```dart
child: GridView.builder(
    itemCount: toDoList.length, // Jumlah item dalam GridView
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Jumlah item per baris
        crossAxisSpacing: 4, // Jarak antar item secara horizontal
        mainAxisSpacing: 4, // Jarak antar item secara vertikal
        childAspectRatio:
            2, // Mengatur rasio lebar dan tinggi item agar lebih lebar
    ),
    itemBuilder: (BuildContext context, int index) {
        // Menampilkan setiap tugas dalam bentuk Card di dalam GridView
        return Card(
        elevation: 4, // Mengatur ketinggian bayangan Card
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                10), // Membuat sudut Card melengkung
        ),
        color:
            Colors.deepPurple.shade100, // Warna latar belakang Card
        child: Padding(
            padding: const EdgeInsets.all(8.0), // Padding dalam Card
            child: TodoList(
            taskName: toDoList[index][0], // Nama tugas
            taskCompleted: toDoList[index]
                [1], // Status penyelesaian tugas
            onChanged: (value) => checkBoxChanged(
                index), // Fungsi untuk mengubah status checkbox
            deleteFunction: (context) =>
                deleteTask(index), // Fungsi untuk menghapus tugas
            editFunction: () => navigateToEditTask(
                index), // Fungsi untuk mengedit tugas
            ),
        ),
        );
    },
),
```

`ListView.builder` menampilkan daftar to-do secara vertikal, sedangkan `GridView.builder` menampilkan daftar tersebut dalam dua kolom.

### Slidable

`Slidable` adalah widget yang memungkinkan pengguna untuk menggeser item dan menampilkan opsi aksi seperti mengedit atau menghapus. Aplikasi ini menggunakan `Slidable` untuk memberikan opsi penghapusan dan pengeditan pada setiap tugas di daftar to-do.

#### Contoh Kode:
```dart
child: Slidable(
    // Bagian aksi geser (slide) di bagian akhir (kanan) dari item
    endActionPane: ActionPane(
        motion: const StretchMotion(), // Efek geser dengan animasi "stretch"
        children: [
        // Tombol geser untuk menghapus tugas
        SlidableAction(
            onPressed:
                deleteFunction, // Fungsi yang akan dijalankan saat tombol di klik
            icon: Icons.delete, // Ikon untuk tombol hapus
            backgroundColor: Colors.red, // Warna latar belakang tombol hapus
            borderRadius:
                BorderRadius.circular(15), // Membuat ujung tombol melengkung
        ),
        // Tombol geser untuk mengedit tugas
        SlidableAction(
            onPressed: (context) =>
                editFunction!(), // Fungsi edit dipanggil saat tombol di klik
            icon: Icons.edit, // Ikon untuk tombol edit
            backgroundColor: Colors.green, // Warna latar belakang tombol edit
            borderRadius:
                BorderRadius.circular(15), // Membuat ujung tombol melengkung
        ),
        ],
    ),
```

Dengan `Slidable`, pengguna dapat menggeser item tugas dan memilih untuk menghapus atau mengedit tugas tersebut.

### Checkbox

`Checkbox` adalah widget yang digunakan untuk menandai apakah tugas sudah selesai atau belum. Pada aplikasi ini, setiap tugas memiliki `Checkbox` untuk menandai statusnya.

#### Contoh Kode:
```dart
children: [
        // Checkbox untuk menandai apakah tugas sudah selesai
        Checkbox(
        value: taskCompleted, // Status penyelesaian tugas
        onChanged:
            onChanged, // Fungsi yang dipanggil saat checkbox diubah
        checkColor: Colors.black, // Warna centang
        activeColor: Colors.white, // Warna checkbox saat aktif
        side: const BorderSide(
            color: Colors.white, // Warna border pada checkbox
        ),
        ),
```

`Checkbox` di atas memungkinkan pengguna untuk mengubah status selesai atau belum dari suatu tugas.

* * * * *

# Dokumentasi Error
### Error 1: Kesalahan pada Implementasi `TextField` Controller

#### Deskripsi Error:

Pada saat saya mencoba menjalankan aplikasi, aplikasi saya tidak dapat menambahkan tugas baru dari input pengguna. Setelah ditelusuri, kesalahan ini disebabkan oleh tidak adanya inisialisasi `TextEditingController` pada `TextField`, sehingga input tidak dapat dibaca dan disimpan dengan benar.

#### Kode saat Error:
```dart
child: TextField(
    decoration: InputDecoration(
        hintText: 'tambahkan to do list kamu', // Placeholder input
        filled: true,
        fillColor: Colors.deepPurple.shade200, // Warna latar belakang input
    ),
),
```

Pada kode di atas, `TextField` tidak memiliki controller yang mengatur input, sehingga nilai yang dimasukkan oleh pengguna tidak bisa diambil dan todo list tidak akan diatambahkan.
![gambar todolist tidak bisa ditambahkan](/week_3/images/image.png)

#### Solusi Perbaikan:

Untuk memperbaiki kesalahan ini, saya menambahkan `TextEditingController` agar input dapat dikontrol dan digunakan dalam aplikasi.

#### Kode setelah Perbaikan:
```dart
final TextEditingController _controller = TextEditingController(); // Inisialisasi controller

child: TextField(
    controller: _controller, // Menambahkan controller untuk mengatur input
    decoration: InputDecoration(
        hintText: 'tambahkan to do list kamu', // Placeholder input
        filled: true,
        fillColor: Colors.deepPurple.shade200, // Warna latar belakang input
    ),
),
```

Setelah menambahkan `TextEditingController`, input dari pengguna dapat dibaca dan digunakan untuk menambahkan tugas ke daftar to-do.

* * * * *

### Error 2: Kesalahan pada Implementasi `ListView.builder`

#### Deskripsi Error:

Saat mencoba menampilkan daftar to-do menggunakan `ListView.builder`, aplikasi menampilkan error berupa "RangeError (index): Invalid value: Not in range 0..X, inclusive: Y", yang artinya saya mencoba mengakses indeks yang tidak valid di dalam list.

#### Kode saat Error:
```dart
ListView.builder(
    itemCount: toDoList.length + 1, // Kesalahan: Menambahkan 1 menyebabkan ListView mencoba mengakses indeks yang tidak ada
    itemBuilder: (BuildContext context, int index) {
        return TodoList(
            taskName: toDoList[index][0],
            taskCompleted: toDoList[index][1],
        );
    },
),
```

Pada kode di atas, kesalahan terletak pada penggunaan `itemCount: toDoList.length + 1`. Penambahan ini menyebabkan `ListView` mencoba mengakses indeks yang melebihi panjang dari `toDoList`.

#### Solusi Perbaikan:

Saya memperbaiki kesalahan ini dengan mengubah `itemCount` menjadi `toDoList.length` tanpa penambahan apapun.

#### Kode setelah Perbaikan:
```dart
ListView.builder(
    itemCount: toDoList.length, // Menghapus penambahan 1 sehingga hanya menampilkan jumlah item yang valid
    itemBuilder: (BuildContext context, int index) {
        return TodoList(
            taskName: toDoList[index][0],
            taskCompleted: toDoList[index][1],
        );
    },
),
```

Dengan menghapus penambahan pada `itemCount`, aplikasi dapat menampilkan daftar to-do tanpa error indeks.

* * * * *

### Error 3: Kesalahan pada Fungsi `toggleViewMode`

#### Deskripsi Error:

Ketika mencoba mengubah tampilan antara `ListView` dan `GridView`, aplikasi mengalami error dengan pesan "setState() or markNeedsBuild() called during build".

#### Kode saat Error:
```dart
void toggleViewMode() {
    isGridView = !isGridView; // Mengubah mode tampilan
}
```

Pada kode di atas, saya hanya mengubah nilai `isGridView`, namun tidak memanggil `setState()` untuk memberitahu Flutter bahwa ada perubahan state.

#### Solusi Perbaikan:

Saya memperbaikinya dengan menambahkan `setState()` di dalam fungsi `toggleViewMode()`.

#### Kode setelah Perbaikan:
```dart
void toggleViewMode() {
    setState(() {
        isGridView = !isGridView; // Mengubah mode tampilan dengan memanggil setState
    });
}
```

Setelah menambahkan `setState()`, aplikasi dapat mengubah mode tampilan antara `ListView` dan `GridView` tanpa mengalami error.

* * * * *

# Penutup
-------
untuk kode keseluruhan dari simple todo akan ada di folder [simple_app](https://github.com/eveeze/uty-mobile-web-service/tree/week3/week_3/simple_app)


# Referensi
-------
- Flutter Documentation: [flutter.dev](https://flutter.dev/)
- ListView.builder Widget: [ListView.builder Docs](https://api.flutter.dev/flutter/widgets/ListView-class.html)
- GridView.builder Widget: [GridView.builder Doc](https://api.flutter.dev/flutter/widgets/GridView-class.html)
