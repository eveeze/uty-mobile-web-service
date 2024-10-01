import 'package:flutter/material.dart';

void main() {
  runApp(const BelajarApp());
}

class BelajarApp extends StatelessWidget {
  const BelajarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Belajar App',
      theme: ThemeData(
        primarySwatch: Colors.red, // Warna tema aplikasi
      ),
      home: const BelajarHomePage(title: 'Belajar Widget Flutter'),
    );
  }
}

class BelajarHomePage extends StatefulWidget {
  const BelajarHomePage({super.key, required this.title});

  final String title;

  @override
  State<BelajarHomePage> createState() => _BelajarHomePageState();
}

class _BelajarHomePageState extends State<BelajarHomePage> {
  int _counter = 0; // Menyimpan nilai counter
  double _sliderValue = 0; // Menyimpan nilai slider
  String _inputText = ''; // Menyimpan teks input dari pengguna

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Text('Nilai saat ini: $_counter',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _incrementCounter,
                  child: const Text('Tambah'),
                ),
              ],
            ),
            Slider(
              value: _sliderValue,
              min: 0,
              max: 100,
              onChanged: (value) {
                setState(() {
                  _sliderValue = value;
                });
              },
            ),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Masukkan Teks',
              ),
              onChanged: (value) {
                setState(() {
                  _inputText = value;
                });
              },
            ),
            Text('Teks yang dimasukkan: $_inputText'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Tambah Counter',
        child: const Icon(Icons.add),
      ),
    );
  }
}
