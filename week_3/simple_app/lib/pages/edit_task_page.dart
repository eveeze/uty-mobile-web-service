// lib/pages/edit_task_page.dart

// Mengimpor package flutter untuk membangun widget dan material design
import 'package:flutter/material.dart';

// EditTaskPage adalah widget Stateful yang menampilkan halaman untuk mengedit tugas
class EditTaskPage extends StatefulWidget {
  const EditTaskPage({super.key}); // Konstruktor dengan key opsional

  @override
  _EditTaskPageState createState() =>
      _EditTaskPageState(); // Menghubungkan EditTaskPage dengan state
}

// _EditTaskPageState adalah kelas state yang mengelola perubahan pada halaman edit tugas
class _EditTaskPageState extends State<EditTaskPage> {
  final TextEditingController _controller =
      TextEditingController(); // Controller untuk menangani input teks

  @override
  void didChangeDependencies() {
    // Mendapatkan argument yang dikirim dari halaman sebelumnya menggunakan ModalRoute
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String,
        dynamic>?; // Akses argument secara aman dengan null-safety

    if (arguments != null) {
      _controller.text = arguments[
          'taskName']; // Mengisi input teks dengan nama tugas yang diterima
    }
    super.didChangeDependencies();
  }

  // Fungsi untuk menyimpan tugas yang sudah diedit
  void saveEditedTask() {
    final arguments = ModalRoute.of(context)?.settings.arguments
        as Map<String, dynamic>?; // Mendapatkan argument dari route

    if (arguments != null) {
      // Mengembalikan tugas yang sudah diperbarui ke halaman sebelumnya dengan Navigator.pop
      Navigator.pop(context, {
        'taskName': _controller.text, // Mengirim nama tugas yang sudah diedit
        'index': arguments['index'], // Mengirim index tugas yang diedit
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar di bagian atas dengan judul dan tombol untuk menyimpan perubahan
      appBar: AppBar(
        title: const Text('Edit Task'), // Judul AppBar
        backgroundColor: Colors.deepPurple, // Warna latar belakang AppBar
        actions: [
          // Tombol centang untuk menyimpan tugas yang sudah diedit
          IconButton(
            icon: const Icon(Icons.check), // Ikon centang
            onPressed:
                saveEditedTask, // Memanggil fungsi saveEditedTask saat tombol ditekan
          ),
        ],
      ),
      // Body halaman yang menampilkan input teks untuk mengedit tugas
      body: Padding(
        padding: const EdgeInsets.all(20), // Padding di sekitar TextField
        child: TextField(
          controller: _controller, // Menghubungkan controller dengan input teks
          decoration: const InputDecoration(
            labelText: 'Edit Task', // Label untuk input teks
            border: OutlineInputBorder(), // Border pada input teks
          ),
        ),
      ),
    );
  }
}
