📝 Laporan Minggu Kelima Mobile & Web Service Praktik Kelas IX
=============================================================
**Nama**: Tito Zaki Saputro  
**NPM**: 5220411045

## Daftar Isi
- [📝 Laporan Minggu Kelima Mobile \& Web Service Praktik Kelas IX](#-laporan-minggu-kelima-mobile--web-service-praktik-kelas-ix)
  - [Daftar Isi](#daftar-isi)
- [Pendahuluan](#pendahuluan)
- [1. Tugas Widget dibuat Menggunakan Figma](#1-tugas-widget-dibuat-menggunakan-figma)
- [2. Review Materi REST API](#2-review-materi-rest-api)
  - [Karakteristik REST API](#karakteristik-rest-api)
  - [Konsep Penting dalam REST API](#konsep-penting-dalam-rest-api)
  - [Struktur Permintaan dan Respons REST API](#struktur-permintaan-dan-respons-rest-api)
  - [Keamanan dalam REST API](#keamanan-dalam-rest-api)
  - [Praktik Terbaik dalam Penggunaan REST API](#praktik-terbaik-dalam-penggunaan-rest-api)
- [3. Membuat API CRUD](#3-membuat-api-crud)
  - [Inisialisasi](#inisialisasi)
  - [`.env`](#env)
  - [`config/db.js`](#configdbjs)
  - [`models/Product.js`](#modelsproductjs)
  - [`controllers/productController.js`](#controllersproductcontrollerjs)
  - [`routes/productRoutes.js`](#routesproductroutesjs)
  - [`server.js`](#serverjs)
- [4. Testing API CRUD](#4-testing-api-crud)
  - [`POST`](#post)
  - [`GET`](#get)
  - [`PUT`](#put)
  - [`DELETE`](#delete)
- [Referensi](#referensi)

---
# Pendahuluan
Pada minggu kelima kali ini tuntutan hasil belajar untuk minggu ini ada 
1. Dari tugas widget, dibuat menggunakan figma
2. Review materi Rest API
3. Membuat API CRUD dan berikan penjelasan lengkap (misalnya, Form Login)

# 1. Tugas Widget dibuat Menggunakan Figma
Hasil Pembelajaran minggu ini salah satunya ada pembuatan design figma dari **[tugas widget](https://elearning.uty.ac.id/mod/assign/view.php?id=3370)** seperti gambar dibawah :
<br>![gambar tugas widget](/week_5/images/tugasWidget.png)<br>
Berikut merupakan hasil design dari figma saya :
<br>![gambar tugas figma](/week_5/images/figma.png)<br>




# 2. Review Materi REST API
REST API (Representational State Transfer Application Programming Interface) adalah arsitektur yang menggunakan prinsip-prinsip REST untuk membangun layanan web. REST adalah pendekatan berbasis arsitektur yang memanfaatkan HTTP untuk memungkinkan komunikasi antara klien dan server. REST API memungkinkan aplikasi untuk saling berkomunikasi dan bertukar data melalui internet dengan menggunakan berbagai metode HTTP.

## Karakteristik REST API
REST API memiliki beberapa karakteristik yang membedakannya dari jenis API lainnya:
- **Stateless**: Setiap permintaan dari klien ke server harus mencakup semua informasi yang diperlukan untuk memahami dan memproses permintaan tersebut. Server tidak menyimpan konteks permintaan sebelumnya.
- **Cacheable**: Data yang dikirimkan dalam respons dapat ditandai sebagai cacheable atau tidak, untuk meningkatkan kinerja dengan menyimpan respons sementara di sisi klien.
- **Layered System**: REST memungkinkan arsitektur sistem yang berlapis, di mana komponen di satu lapisan tidak perlu mengetahui detail di lapisan lainnya.
- **Uniform Interface**: REST mengandalkan penggunaan serangkaian prinsip yang seragam untuk semua API, seperti menggunakan URL yang mudah dibaca dan metode HTTP yang umum.

## Konsep Penting dalam REST API
REST API dibangun di atas beberapa konsep inti yang memungkinkan pertukaran data dan komunikasi antara klien dan server secara efektif.

1. **Endpoint**<br>
   Endpoint adalah URL (Uniform Resource Locator) yang digunakan untuk mengakses sumber daya di server. Setiap sumber daya diidentifikasi oleh endpoint unik, dan melalui endpoint ini klien dapat melakukan operasi seperti **GET**, **POST**, **PUT**, dan **DELETE**. Berikut merupakan contoh endpoint lokal saat membuat **REST API**

   Contoh endpoint:`https://localhost:3000/users`


 2. **HTTP Methods**<br>
    Metode HTTP mendefinisikan tindakan yang akan dilakukan terhadap sumber daya. REST API menggunakan beberapa metode HTTP standar:
    - **GET**: Digunakan untuk mengambil atau membaca data dari server. Biasanya tidak mengubah data di server.
    - **POST**: Digunakan untuk mengirim data ke server, biasanya untuk membuat sumber daya baru.
    - **PUT**: Digunakan untuk memperbarui sumber daya yang ada di server dengan data baru.
    - **DELETE**: Digunakan untuk menghapus sumber daya dari server.
    - **PATCH**: Digunakan untuk melakukan pembaruan sebagian pada sumber daya yang ada.

3. **Resources**<br>
Sumber daya dalam konteks REST API adalah entitas yang dapat diakses melalui URL dan dioperasikan dengan metode HTTP. Sumber daya dapat berupa objek atau data yang diakses dan dimodifikasi.
    Contoh sumber daya:
    - `/users` untuk mengakses data pengguna.
    - `/products` untuk mengakses data produk.

4. **URI (Uniform Resource Identifier)**<br>
URI digunakan untuk mengidentifikasi sumber daya di REST API. URI biasanya berbentuk URL yang dapat menunjukkan lokasi sumber daya di server.Contoh URI: `https://localhost:3000/users/123`
5. **Status Code**<br>
Setiap permintaan HTTP akan menerima respons berupa status code, yang memberikan informasi mengenai keberhasilan atau kegagalan permintaan tersebut. Beberapa kode status HTTP umum dalam REST API antara lain:
- **200 OK**: Permintaan berhasil dan respons berisi data yang diminta.
- **201 Created**: Permintaan berhasil dan sumber daya baru telah dibuat.
- **400 Bad Request**: Permintaan yang dikirimkan salah atau tidak valid.
- **401 Unauthorized**: Klien tidak memiliki otorisasi yang tepat untuk mengakses sumber daya.
- **404 Not Found**: Sumber daya yang diminta tidak ditemukan.
- **500 Internal Server Error**: Terjadi kesalahan pada server saat memproses permintaan.

6. **Headers**<br>
Headers adalah bagian dari setiap permintaan dan respons HTTP. Header memberikan metadata tentang permintaan atau respons, seperti format data, otorisasi, dan jenis konten yang dikirimkan. Contoh header penting:
   - **Content-Type**: Menentukan format data yang dikirimkan, misalnya `application/json`.
   - **Authorization**: Header ini digunakan untuk otorisasi, biasanya dengan token atau kunci API.
7. **JSON (JavaScript Object Notation)**<br>
JSON adalah format data yang sering digunakan untuk mengirim dan menerima data melalui REST API. JSON berbentuk sederhana dan mudah dibaca oleh manusia serta mesin. Contoh format JSON:
    ```json
    {
    "id": 123,
    "name": "Prabowo Widodo",
    "email": "Pradodo@example.com"
    }
    ```

## Struktur Permintaan dan Respons REST API

1.  **Permintaan (Request)** Setiap permintaan REST API terdiri dari beberapa bagian:

    -   **Method**: Metode HTTP yang digunakan (GET, POST, PUT, DELETE, PATCH).
    -   **URI**: Alamat endpoint untuk sumber daya yang diakses.
    -   **Headers**: Informasi tambahan, seperti jenis konten dan otorisasi.
    -   **Body**: Isi dari permintaan, digunakan terutama pada POST, PUT, dan PATCH untuk mengirim data ke server.

    Contoh permintaan untuk membuat data baru (POST):
    ```http
    POST /api/users HTTP/1.1
    Host: api.example.com
    Content-Type: application/json
    Authorization: Bearer your_token_here

    {
       "name": "Jane Doe",
       "email": "janedoe@example.com"
    }
    ```

2.  **Respons (Response)** Respons dari server terdiri dari:

    -   **Status Line**: Menyatakan hasil dari permintaan dengan kode status HTTP.
    -   **Headers**: Metadata tentang respons, misalnya jenis konten yang dikembalikan.
    -   **Body**: Isi dari respons, berisi data yang diminta oleh klien (jika ada).

    Contoh respons untuk permintaan GET:

    ```http
    HTTP/1.1 200 OK
    Content-Type: application/json

    {
       "id": 123,
       "name": "John Doe",
       "email": "johndoe@example.com"
    }
    ```

## Keamanan dalam REST API

Keamanan adalah aspek penting dalam REST API. Beberapa mekanisme keamanan yang umum digunakan adalah:

1.  **Authentication (Otentikasi)**:<br>
    Proses verifikasi identitas pengguna, biasanya dilakukan dengan menggunakan token (misalnya JWT - JSON Web Token) atau kunci API.
2.  **Authorization (Otorisasi)**::<br>
    Proses menentukan apakah pengguna yang telah diotentikasi memiliki hak akses ke sumber daya tertentu.
3.  **HTTPS**: :<br>
   REST API harus diakses melalui HTTPS untuk memastikan komunikasi aman dengan enkripsi data yang dikirimkan antara klien dan server.
4.  **Rate Limiting**: :<br>
   Pembatasan jumlah permintaan dari klien dalam jangka waktu tertentu untuk melindungi server dari serangan berlebihan (misalnya DDoS).

## Praktik Terbaik dalam Penggunaan REST API

1.  **Penggunaan Verb HTTP yang Tepat**::<br>
    Gunakan metode HTTP yang sesuai dengan aksi yang diinginkan (GET untuk membaca, POST untuk membuat, PUT untuk memperbarui, DELETE untuk menghapus).
2.  **Statelessness**::<br>
    Pastikan API tidak menyimpan status klien, dan setiap permintaan berisi semua informasi yang diperlukan.
3.  **Versioning**: :<br>
   Gunakan versi API untuk mengelola perubahan tanpa merusak aplikasi klien. Contohnya, tambahkan versi dalam URL seperti `/api/v1/users`.
4.  **Paginasi**: :<br>
   Saat mengembalikan daftar besar data, gunakan paginasi untuk menghindari masalah kinerja dan memastikan bahwa respons tetap cepat.

* * * * *

# 3. Membuat API CRUD
## Inisialisasi 
Pada hasil pembelajaran saya minggu ini saya akan membuat API yang melakukan CRUD untuk aplikasi Warung dimana saya akan membuat API untuk **Product** aplikasi **Warung Mbah Manto**. Berikut merupakan langkah-langkah bagaimana saya Membuat API CRUD untuk Product.

Membuat direktori dengan nama yang diinginkan dalam kasus saya , saya membuat dan menamainya sebagai beriku :
> Saya menggunakan terminal powershell
```bash
mkdir backend
cd backend
```
API CRUD yang akan kita buat kali ini kita akan membuatnya menggunakan **Node Js** dan **Express Js**. Pastikan anda sudah menginstall **Node Js**. [Install Node Js](https://nodejs.org/en/download/prebuilt-installer)


Setelah memastikan sudah menginstall **Node Js** , di dalam direktori backend kita lakukan inisialisasi **Node Js**
```bash
npm init -y
```
atau yang terlihat seperti pada gambar<br>
![gambar npm init](/week_5/images/init.png)<br>

Setelah itu kita perlu menginstall package-package yang diperlukan berikut merupakan package.json saya saat membuat API ini
```json
{
  "name": "auth-api",
  "version": "1.0.0",
  "description": "Authentication API with WhatsApp OTP",
  "main": "server.js",
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js"
  },
  "dependencies": {
    "axios": "^1.6.2",
    "bcryptjs": "^2.4.3",
    "cors": "^2.8.5",
    "dotenv": "^16.3.1",
    "express": "^4.18.2",
    "jsonwebtoken": "^9.0.2",
    "mongoose": "^7.6.3",
    "twilio": "^5.3.4"
  },
  "devDependencies": {
    "nodemon": "^3.0.1"
  }
}

```

package yang diperlukan untuk membuat API CRUD seperti **express**, **mongoose**, **cors** ,**dotenv**
```bash
npm install express mongoose cors dotenv
```
Penjelasan package yang diinstall:
- express: Framework web untuk Node.js yang memudahkan pembuatan API
- mongoose: Library untuk berinteraksi dengan MongoDB
- cors: Middleware untuk menangani Cross-Origin Resource Sharing
- dotenv: Untuk mengelola environment variables


Berikut adalah struktur folder yang digunakan dalam API ini:
```tree
backend/
├── config/
│   └── db.js           # Konfigurasi konek database MongoDB
├── models/
│   └── Product.js      # Schema model untuk product
├── controllers/
│   └── productController.js  # Logic handling untuk product
├── routes/
│   └── productRoutes.js      # Definisi routing product
├── .env                # Environment variables
└── server.js          # Entry point aplikasi
```

Sebelumnya kita akan melakukan setup database dan deploy database untuk **MongoDB** , berikut contoh untuk membuat sebuah cluster database MongoDB step stepnya : 
1. Membuat akun dan login di **MongoDB**<br>
   ![akun mongodb](/week_5/images/akun.png)<br>
2. membuat project baru atau cluster baru <br>
   ![buat cluster mongodb](/week_5/images/new.png)<br>
3. Menamai dan membuat project nya<br>
   ![namain mongodb](/week_5/images/namain.png)<br>
4. create project dengan memberikan siapa saja yang dapat permision<br>
   ![buat project](/week_5/images/create.png)<br>
5. buat cluster<br>
   ![buat project](/week_5/images/cluster.png)<br>
6. Deploy cluster menggunakan yang free dan layanan google cloud , lalu pilih server yang berada di jakarta.<br>
   ![buat project](/week_5/images/deploy.png)<br>
7. lalu akan ada menu tampilan untuk koneksi , simpan password yang diberikan lalu create database user<br>
   ![buat project](/week_5/images/koneksi.png)<br>
8. setting network acces dengan melakukan , `add ip addres` dan `klik allow acces from anywhere` lalu simpan<br>
   ![buat project](/week_5/images/network.png)<br>
9.  lalu pilih koneksi method `driver`<br>
   ![buat project](/week_5/images/driver.png)<br>
10. pilih driver yang mau dipakai dalam kasus saya `Node Js`  lalu simpan `connection stringnya` <br>
   ![buat project](/week_5/images/nodes.png)<br>

11. lalu copy string koneksinya ke `.env`

Berikut merupakan kode kode yang digunakan untuk API CRUD

## `.env`
```bash
MONGODB_URI=koneksion_string_dari_database_mongodb_deploy_atlas
PORT=3000
```
**MONGODB_URI** digunakan untuk koneksi kepada database **MongoDB** yang sudah saya deploy di Atlas **MongoDB**

## `config/db.js`
```javascript
// backend/config/db.js
// Mengimpor library mongoose untuk berinteraksi dengan MongoDB
const mongoose = require("mongoose");

// Membuat fungsi asinkron untuk menghubungkan aplikasi ke MongoDB
const connectDB = async () => {
  try {
    // Mencoba menghubungkan ke MongoDB menggunakan URI dari variabel lingkungan (env)
    await mongoose.connect(process.env.MONGODB_URI);
    // Jika berhasil terhubung, tampilkan pesan sukses ke konsol
    console.log("MongoDB connected successfully");
  } catch (error) {
    // Jika terjadi kesalahan saat mencoba menghubungkan, tampilkan pesan error ke konsol
    console.error("MongoDB connection error:", error);
    // Keluar dari proses aplikasi dengan kode status 1 yang menunjukkan error
    process.exit(1);
  }
};

// Mengekspor fungsi connectDB agar dapat digunakan di file lain
module.exports = connectDB;


```

## `models/Product.js`<br>
Berikut merupakan kode untuk schema atau model product yang akan digunakan.
```javascript
// Mengimpor library mongoose untuk membuat model dan skema MongoDB
const mongoose = require("mongoose");

// Membuat skema untuk model Product
const productSchema = new mongoose.Schema(
  {
    // Mendefinisikan field "name" yang tipe datanya String dan wajib diisi (required)
    name: { type: String, required: true },
    
    // Mendefinisikan field "stock" yang tipe datanya Number dan wajib diisi (required)
    stock: { type: Number, required: true },
    
    // Mendefinisikan field "producerPrice" (Harga produsen) yang tipe datanya Number dan wajib diisi
    producerPrice: { type: Number, required: true },
    
    // Mendefinisikan field "salePrice" (Harga jual) yang tipe datanya Number dan wajib diisi
    salePrice: { type: Number, required: true },
  },
  
  // Menambahkan opsi timestamps untuk otomatis menambahkan field "createdAt" dan "updatedAt"
  { timestamps: true }
);

// Mengekspor model Product agar dapat digunakan di file lain, dengan menggunakan skema productSchema
module.exports = mongoose.model("Product", productSchema);

```
Schema product memiliki field:

- name: Nama produk (String, required)
- stock: Jumlah stok produk (Number, required)
- producerPrice: Harga dari produsen (Number, required)
- salePrice: Harga jual ke konsumen (Number, required)
- timestamps: Secara otomatis menambahkan createdAt dan updatedAt

## `controllers/productController.js`<br>
Untuk kode dalam kontroller digunakan untuk melakukan logika CRUD yang akan dilakukan pada produk
```javascript
// Mengimpor model Product dari file Product.js
const Product = require("../models/Product");

// Mendapatkan semua produk
exports.getAllProducts = async (req, res) => {
  try {
    // Mengambil semua data produk dari database
    const products = await Product.find();
    // Mengirim respon dengan status 200 dan data produk dalam format JSON
    res.status(200).json(products);
  } catch (error) {
    // Jika terjadi error, cetak pesan error di konsol
    console.error("Error fetching products:", error);
    // Mengirim respon dengan status 500 (Server error) dan pesan kesalahan
    res.status(500).json({ message: "Server error" });
  }
};

// Mendapatkan produk berdasarkan ID
exports.getProductById = async (req, res) => {
  try {
    // Mencari produk berdasarkan ID yang dikirim di parameter request
    const product = await Product.findById(req.params.id);
    // Jika produk tidak ditemukan, kirim respon dengan status 404 (Tidak ditemukan)
    if (!product) {
      return res.status(404).json({ message: "Product not found" });
    }
    // Jika produk ditemukan, kirim respon dengan status 200 dan produk dalam format JSON
    res.status(200).json(product);
  } catch (error) {
    // Jika terjadi error, cetak pesan error di konsol
    console.error("Error fetching product:", error);
    // Mengirim respon dengan status 500 (Server error) dan pesan kesalahan
    res.status(500).json({ message: "Server error" });
  }
};

// Membuat produk baru
exports.createProduct = async (req, res) => {
  try {
    // Mendapatkan data produk dari body request
    const { name, stock, producerPrice, salePrice } = req.body;
    // Membuat instance produk baru menggunakan data yang diberikan
    const newProduct = new Product({ name, stock, producerPrice, salePrice });
    // Menyimpan produk baru ke database
    await newProduct.save();
    // Mengirim respon dengan status 201 (Created) dan informasi produk yang baru dibuat
    res
      .status(201)
      .json({ message: "Product created successfully", product: newProduct });
  } catch (error) {
    // Jika terjadi error, cetak pesan error di konsol
    console.error("Error creating product:", error);
    // Mengirim respon dengan status 500 (Server error) dan pesan kesalahan
    res.status(500).json({ message: "Server error" });
  }
};

// Memperbarui produk
exports.updateProduct = async (req, res) => {
  try {
    // Mendapatkan data produk yang diperbarui dari body request
    const { name, stock, producerPrice, salePrice } = req.body;
    // Mencari dan memperbarui produk berdasarkan ID dengan data yang baru, 
    // opsi "new: true" mengembalikan data produk yang sudah diperbarui
    // dan "runValidators: true" memastikan data valid sesuai skema
    const updatedProduct = await Product.findByIdAndUpdate(
      req.params.id,
      { name, stock, producerPrice, salePrice },
      { new: true, runValidators: true }
    );
    // Jika produk tidak ditemukan, kirim respon dengan status 404 (Tidak ditemukan)
    if (!updatedProduct) {
      return res.status(404).json({ message: "Product not found" });
    }
    // Mengirim respon dengan status 200 dan informasi produk yang sudah diperbarui
    res
      .status(200)
      .json({
        message: "Product updated successfully",
        product: updatedProduct,
      });
  } catch (error) {
    // Jika terjadi error, cetak pesan error di konsol
    console.error("Error updating product:", error);
    // Mengirim respon dengan status 500 (Server error) dan pesan kesalahan
    res.status(500).json({ message: "Server error" });
  }
};

// Menghapus produk
exports.deleteProduct = async (req, res) => {
  try {
    // Mencari dan menghapus produk berdasarkan ID
    const product = await Product.findByIdAndDelete(req.params.id);
    // Jika produk tidak ditemukan, kirim respon dengan status 404 (Tidak ditemukan)
    if (!product) {
      return res.status(404).json({ message: "Product not found" });
    }
    // Mengirim respon dengan status 200 dan pesan sukses setelah produk dihapus
    res.status(200).json({ message: "Product deleted successfully" });
  } catch (error) {
    // Jika terjadi error, cetak pesan error di konsol
    console.error("Error deleting product:", error);
    // Mengirim respon dengan status 500 (Server error) dan pesan kesalahan
    res.status(500).json({ message: "Server error" });
  }
};

```

## `routes/productRoutes.js`<br>
Berikut merupakan kode untuk mendefinisikan endpoint untuk setiap operasi CRUD.
```javascript
// Mengimpor library express untuk membuat router
const express = require("express");
// Membuat instance router dari express
const router = express.Router();
// Mengimpor controller produk dari file productController.js
const productController = require("../controllers/productController");

// Rute untuk operasi CRUD

// Rute untuk mendapatkan semua produk
router.get("/", productController.getAllProducts); // Mendapatkan semua produk

// Rute untuk mendapatkan produk berdasarkan ID
router.get("/:id", productController.getProductById); // Mendapatkan produk berdasarkan ID

// Rute untuk membuat produk baru
router.post("/", productController.createProduct); // Membuat produk baru

// Rute untuk memperbarui produk berdasarkan ID
router.put("/:id", productController.updateProduct); // Memperbarui produk berdasarkan ID

// Rute untuk menghapus produk berdasarkan ID
router.delete("/:id", productController.deleteProduct); // Menghapus produk berdasarkan ID

// Mengekspor router agar dapat digunakan di file lain
module.exports = router;

```

## `server.js`<br>
lalu kita setup server nya
```javascript
// Mengimpor library express untuk membuat server
const express = require("express");
// Mengimpor library cors untuk mengatasi masalah CORS (Cross-Origin Resource Sharing)
const cors = require("cors");
// Mengimpor library mongoose untuk berinteraksi dengan MongoDB
const mongoose = require("mongoose");
// Memuat variabel lingkungan dari file .env
require("dotenv").config();
// Mengimpor fungsi connectDB untuk menghubungkan ke MongoDB
const connectDB = require("./config/db");

// Mengimpor rute autentikasi, transaksi, dan produk
const authRoutes = require("./routes/authRoutes");
const transactionRoutes = require("./routes/transactionRoutes");
const productRoutes = require("./routes/productRoutes");

// Membuat instance aplikasi express
const app = express();

// Middleware

// Mengaktifkan CORS agar server bisa menerima permintaan dari domain lain
app.use(cors());
// Middleware untuk mengurai (parsing) JSON dalam request body
app.use(express.json());

// Menghubungkan ke MongoDB menggunakan fungsi connectDB
connectDB();

// Rute

// Mengatur rute untuk autentikasi
app.use("/api/auth", authRoutes);
// Mengatur rute untuk transaksi
app.use("/api/transaction", transactionRoutes);
// Mengatur rute untuk produk
app.use("/api/products", productRoutes); // <-- Menambahkan rute untuk produk

// Mendefinisikan port dari variabel lingkungan atau menggunakan port 3000 secara default
const PORT = process.env.PORT || 3000;
// Menjalankan server dan mencetak pesan saat server sudah aktif
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

```

Berikut merupakan seluruh endpoint nya:
| Method | Endpoint          | Deskripsi                        |
| ------ | ----------------- | -------------------------------- |
| GET    | /api/products     | Mengambil semua produk           |
| GET    | /api/products/:id | Mengambil produk berdasarkan ID  |
| POST   | /api/products     | Membuat produk baru              |
| PUT    | /api/products/:id | Mengupdate produk berdasarkan ID |
| DELETE | /api/products/:id | Menghapus produk berdasarkan ID  |

# 4. Testing API CRUD
saya akan melakukan testing menggunakan Postman, nyalakan server di lokal server dengan command.
```bash
node server.js
```
yang terlihat seperti pada gambar , jika berhasil maka akan ada text seperti pada gambar

![gambar run server](/week_5/images/run.png)

jika ada kesalahan maka akan muncul seperti ini

![gambar error 1](/week_5/images/error1.png)

Berikut merupakan hasil testing postman : 
## `POST`
Create Product (POST /api/products) , Setting pada Headers dan body seperti pada gambar lakuan pada setiap metode.
![header](/week_5/images/header.png)<br>
setting untuk body dan isikan message dalam format **JSON**
![body](/week_5/images/bodys.png)<br>

```http
Endpoint: /api/products
Method: POST
Request Body (JSON):
```
```json
{
  "name": "Laptop MSI GF63",
  "stock": 50,
  "producerPrice": 500,
  "salePrice": 700
}
```
jika berhasil maka akan masuk ke database MongoDB yang telah di deploy .
![database berhasil](/week_5/images/database1.png)<br>


Response:

Status 201 (Created) jika berhasil, dengan detail produk yang baru dibuat.
![post berhasil](/week_5/images/post_succes.png)<br>
Status 404 (Not Found) jika tidak ditemukan , karena salah dalam endpoint
![error 404](/week_5/images/error2.png)<br>

## `GET`
GET Product (GET /api/products) untuk menampilkan seluruh data produk , Setting pada Headers dan body seperti pada gambar lakuan pada setiap metode.
![header](/week_5/images/header.png)<br>
setting untuk body dan isikan message dalam format **JSON**
![body](/week_5/images/bodys.png)<br>

```http
Endpoint: /api/products
Method: get
```
Tidak perlu ada body karena hanya akan menampilkan semua produk yang telah ditambahkan.

jika berhasil maka akan menampilkan seluruh produk.
![berhasil get](/week_5/images/get.png)<br>


Response:
Status 200 (OK) jika berhasil, dengan detail produk yang baru dibuat berhasil menampilkan seluruh data product.

Get Product by ID (GET) digunakan untuk menampilkan produk berdasarkan id. copy id yang ingin di cek lalu masukan ke endpointnya.
```http
Endpoint: /api/products/:id
Method: GET
Request Body: Tidak diperlukan
Parameter: ID produk (misalnya, ganti :id dengan ID produk yang sudah dibuat sebelumnya, misalnya 64b8c43d50c3f521a9c8c123)
```
Response:

Status 200 jika produk ditemukan, dengan detail produk.
![berhasil get by id](/week_5/images/getid.png)<br>
Status 404 jika ID produk tidak ditemukan.

## `PUT`
Put digunakan untuk mengedit product
```http
Update Product (PUT /api/products/:id)
Endpoint: /api/products/:id
Method: PUT
Request Body (JSON):
```
```JSON
{
        "_id": "671a05099231c102403a2a6a",
        "name": "Laptop HP Pavilion ",
        "stock": 39,
        "producerPrice": 500,
        "salePrice": 1000,
        "createdAt": "2024-10-24T08:27:53.151Z",
        "updatedAt": "2024-10-24T08:30:25.970Z"
}
```
Parameter: ID produk (ganti :id dengan ID produk yang ingin di-update).
![body put](/week_5/images/pavilion.png)<br>

Response:

Status 200 jika produk berhasil di-update, dengan detail produk yang diperbarui.
![update put](/week_5/images/update.png)<br>
setelah terupdate dan di cek lagi di get by id sudah berubah di database juga sudah berubah.
![update put](/week_5/images/updated.png)<br>
![update mongo](/week_5/images/updatemongo.png)<br>

Status 404 jika ID produk tidak ditemukan.

## `DELETE`
Untuk menghapus product berdasarkan id.
```http
Delete Product (DELETE /api/products/:id)
Endpoint: /api/products/:id
Method: DELETE
Request Body: Tidak diperlukan
Parameter: ID produk (ganti :id dengan ID produk yang ingin dihapus).
```
![gambar mau delete](/week_5/images/delete.png)<br>
Response:

Status 200 jika produk berhasil dihapus.
![deleted](/week_5/images/deleted.png)<br>
di database sudah terhapus
![deleted mongo](/week_5/images/mongohapus.png)<br>

Status 404 jika ID produk tidak ditemukan.

# Referensi
-------
- Flutter Documentation: [flutter.dev](https://flutter.dev/)
- ListView.builder Widget: [ListView.builder Docs](https://api.flutter.dev/flutter/widgets/ListView-class.html)
- GridView.builder Widget: [GridView.builder Doc](https://api.flutter.dev/flutter/widgets/GridView-class.html)
