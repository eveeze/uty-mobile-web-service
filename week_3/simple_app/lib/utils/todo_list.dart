// lib/utils/todo_list.dart

// Mengimpor package flutter yang menyediakan widget dan material design
import 'package:flutter/material.dart';
// Mengimpor package flutter_slidable yang menyediakan widget untuk menampilkan aksi geser
import 'package:flutter_slidable/flutter_slidable.dart';

// TodoList adalah kelas StatelessWidget yang menampilkan daftar tugas dengan fitur geser untuk mengedit atau menghapus
class TodoList extends StatelessWidget {
  // Constructor dengan parameter yang dibutuhkan
  const TodoList({
    super.key, // Key opsional untuk widget
    required this.taskName, // Nama tugas yang akan ditampilkan
    required this.taskCompleted, // Status apakah tugas telah selesai
    required this.onChanged, // Fungsi yang dipanggil saat checkbox diubah
    required this.deleteFunction, // Fungsi untuk menghapus tugas
    required this.editFunction, // Fungsi untuk mengedit tugas
  });

  // Deklarasi variabel yang akan digunakan di dalam widget
  final String taskName; // Nama tugas
  final bool taskCompleted; // Status penyelesaian tugas
  final Function(bool?)?
      onChanged; // Fungsi yang dipanggil saat checkbox diubah
  final Function(BuildContext)? deleteFunction; // Fungsi untuk menghapus tugas
  final Function()? editFunction; // Fungsi untuk mengedit tugas

  @override
  Widget build(BuildContext context) {
    // Menggunakan widget Padding untuk memberikan jarak pada widget child
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom:
            0, // Padding pada bagian atas, kiri, kanan, dan tanpa padding bawah
      ),
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
        // Widget yang menjadi konten utama (daftar tugas)
        child: Container(
          padding:
              const EdgeInsets.all(20), // Padding di seluruh sisi kontainer
          decoration: BoxDecoration(
            color: Colors.deepPurple, // Warna latar belakang kontainer
            borderRadius: BorderRadius.circular(
                15), // Membuat kontainer dengan sudut melengkung
          ),
          child: Row(
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
              // Expanded agar teks tugas menyesuaikan ruang yang tersedia
              Expanded(
                child: Text(
                  taskName, // Nama tugas
                  style: TextStyle(
                    color: Colors.white, // Warna teks
                    fontSize: 18, // Ukuran teks
                    // Jika tugas selesai, teks dicoret, jika tidak, tidak ada dekorasi
                    decoration: taskCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationColor: Colors.white, // Warna garis coret
                    decorationThickness: 2, // Ketebalan garis coret
                  ),
                  overflow: TextOverflow
                      .ellipsis, // Jika teks terlalu panjang, akan dipotong dengan titik-titik
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
