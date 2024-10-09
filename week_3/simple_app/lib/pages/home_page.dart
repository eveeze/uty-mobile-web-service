// lib/pages/home_page.dart

// Mengimpor package flutter untuk membangun widget dan material design
import 'package:flutter/material.dart';
// Mengimpor widget TodoList dari file utils/todo_list.dart
import 'package:simple_app/utils/todo_list.dart';

// HomePage adalah widget Stateful yang menampilkan halaman utama dari aplikasi To-do
class HomePage extends StatefulWidget {
  const HomePage({super.key}); // Konstruktor dengan key opsional

  @override
  State<HomePage> createState() =>
      _HomePageState(); // Menghubungkan HomePage dengan state
}

// _HomePageState adalah kelas state yang mengelola perubahan pada halaman
class _HomePageState extends State<HomePage> {
  final TextEditingController _controller =
      TextEditingController(); // Controller untuk menangani input teks
  // Daftar to-do yang berisi nama tugas dan status apakah sudah selesai atau belum
  List<List<dynamic>> toDoList = [
    ['Code With Otabek', true],
    ['Learn Flutter', true],
    ['Drink Coffee', false],
    ['Explore Firebase', false],
  ];

  bool isGridView =
      false; // Menyimpan status apakah tampilan grid aktif atau tidak

  // Fungsi untuk mengganti mode tampilan antara ListView dan GridView
  void toggleViewMode() {
    setState(() {
      isGridView =
          !isGridView; // Membalik status isGridView setiap kali dipanggil
    });
  }

  // Fungsi untuk mengubah status checkbox (apakah tugas sudah selesai atau belum)
  void checkBoxChanged(int index) {
    setState(() {
      toDoList[index][1] = !toDoList[index]
          [1]; // Membalik status selesai dari to-do berdasarkan index
    });
  }

  // Fungsi untuk menambahkan tugas baru ke daftar to-do
  void saveNewTask() {
    if (_controller.text.isNotEmpty) {
      // Memastikan input tidak kosong
      setState(() {
        toDoList.add([
          _controller.text,
          false
        ]); // Menambahkan tugas baru dengan status belum selesai
        _controller.clear(); // Mengosongkan input setelah menambah tugas
      });
    }
  }

  // Fungsi untuk menghapus tugas dari daftar berdasarkan index
  void deleteTask(int index) {
    setState(() {
      toDoList
          .removeAt(index); // Menghapus tugas pada posisi index yang dipilih
    });
  }

  // Fungsi untuk navigasi ke halaman edit tugas
  void navigateToEditTask(int index) {
    Navigator.pushNamed(context, '/edit', arguments: {
      'taskName': toDoList[index][0], // Mengirim nama tugas sebagai argument
      'index': index, // Mengirim index dari tugas sebagai argument
    }).then((updatedTask) {
      // Jika tugas berhasil diperbarui, mengganti nama tugas dalam daftar
      if (updatedTask != null && updatedTask is Map<String, dynamic>) {
        setState(() {
          toDoList[updatedTask['index']] = [
            updatedTask['taskName'],
            toDoList[updatedTask['index']]
                [1] // Mempertahankan status selesai dari tugas
          ];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
      // Kondisi untuk menampilkan GridView atau ListView berdasarkan status isGridView
      body: isGridView
          ? Padding(
              padding: const EdgeInsets.all(
                  4.0), // Memberikan padding untuk GridView
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
            )
          : ListView.builder(
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
      // FloatingActionButton di bagian bawah untuk menambah tugas baru
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 20), // Padding untuk FloatingActionButton
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20), // Padding untuk TextField
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
              ),
            ),
            // Tombol tambah tugas baru dengan ikon plus
            FloatingActionButton(
              onPressed:
                  saveNewTask, // Memanggil fungsi untuk menyimpan tugas baru
              child: const Icon(Icons.add), // Ikon plus pada tombol
            ),
          ],
        ),
      ),
    );
  }
}
