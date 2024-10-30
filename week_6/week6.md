# Laporan Minggu Keenam Mobile & Web Service Praktik Kelas IX
**Nama**: Tito Zaki Saputro  
**NPM**: 5220411045  

---

## Dokumentasi Hasil Belajar Minggu ke-06

### 1. Membuat Tutorial Konversi Desain Figma ke Flutter
Membuat design figmanya terlebih dahulu , berikut screenshot design figma yang saya buat untuk  :
#### Design Figma
- design splash , intro , sign in , sign up<br>
![design figma login](/week_6/images/figma%20login.png)<br>
- design halaman produk dan detail produk
![design produk](/week_6/images/produk.png)<br>
- design halaman tambah dan edit produk 
![design tambah dan edit produk](/week_6/images/tambah.png)<br>
- design untuk pembayaran dengan mode cash dan qris<br>
![design pembayaran](/week_6/images/transaksi.png)<br>
- design verify otp<br>
![design verify otp](/week_6/images/verify.png)<br>

#### Konversi ke FLutter
Karena keterbatasan waktu saya tidak bisa menjelaskan satu persatu, karena kebanyakan waktu saya habiskan untuk mengembangkan api dan flutter nya . berikut hasil konersinya. 
- Splash<br>
![hasil splash](/week_6/images/splash.png)<br>
- Intro<br>
![hasil intro](/week_6/images/hasilIntro.png)<br>
- Sign In<br>
![hasil sign in](/week_6/images/hasilLogin.png)<br>
- Sign Up<br>
![hasil sign up](/week_6/images/hasilRegister.png)<br>
- Verifikasi<br>
![hasil verifikasi](/week_6/images/hasilverif.png)<br>
- Kelola Produk<br>
![hasil kelola produk](/week_6/images/hasilKelola.png)<br>
- Tambah Produk<br>
![hasil produk](/week_6/images/hasilAdd.png)<br>
- Edit Produk<br>
![hasil edit](/week_6/images/hasilEdit.png)<br>
- Cart<br>
![hasil cart](/week_6/images/hasilCart.png)<br>
- Cash Payment<br>
![hasil cash payment](/week_6/images/hasilCash.png)<br>
- QRIS Payment<br>
![hasil qris payment](/week_6/images/hasilQRIS.png)<br>
- Payment Berhasil<br>
![hasil pembayaran berhasil](/week_6/images/hasilTransaksi.png)<br>


Hasil konversi tersebut dapat berjalan karena pembuatan API untuk CRUD , OTP , dan Payment Gateway.
### 2. Melanjutkan Pembuatan API untuk OTP (contoh: WhatsApp) dan Payment Gateway
membuat api otp dan payment gateway
#### OTP
- `config/db.js`
```javascript
// Mengimpor library mongoose untuk menghubungkan Node.js dengan MongoDB
const mongoose = require("mongoose");

// Membuat fungsi asinkron untuk menghubungkan ke database MongoDB
const connectDB = async () => {
  try {
    // Mencoba menghubungkan ke database MongoDB menggunakan URI dari variabel lingkungan
    await mongoose.connect(process.env.MONGODB_URI);
    // Jika berhasil, menampilkan pesan "MongoDB connected successfully" ke konsol
    console.log("MongoDB connected successfully");
  } catch (error) {
    // Jika terjadi kesalahan, menampilkan pesan kesalahan ke konsol
    console.error("MongoDB connection error:", error);
    // Menghentikan proses aplikasi dengan kode status 1, menandakan ada kesalahan
    process.exit(1);
  }
};

// Mengekspor fungsi connectDB agar bisa digunakan di file lain
module.exports = connectDB;

```
- `controllers/authController.js`
```javascript
// Mengimpor model User dari file User.js
const User = require("../models/User");
// Mengimpor fungsi generateOTP dan sendWhatsAppOTP dari utils/fonnte
const { generateOTP, sendWhatsAppOTP } = require("../utils/fonnte");
// Mengimpor library jwt untuk membuat token JWT
const jwt = require("jsonwebtoken");
// Mengimpor library bcrypt untuk menangani hashing password
const bcrypt = require("bcryptjs");

// Fungsi register untuk registrasi pengguna baru
exports.register = async (req, res) => {
  try {
    const { phone, name, password } = req.body;

    // Mengecek apakah pengguna sudah ada
    let user = await User.findOne({ phone });
    if (user && user.isVerified) {
      return res.status(400).json({ message: "User already exists" });
    }

    // Membuat OTP
    const otp = generateOTP();
    const otpExpiry = new Date();
    otpExpiry.setMinutes(otpExpiry.getMinutes() + 5); // OTP berlaku selama 5 menit

    // Membuat atau memperbarui data pengguna
    if (!user) {
      user = new User({
        phone,
        name,
        password,
        otp: {
          code: otp,
          expiresAt: otpExpiry,
        },
      });
    } else {
      user.name = name;
      user.password = password;
      user.otp = {
        code: otp,
        expiresAt: otpExpiry,
      };
    }

    // Hash password dilakukan oleh pre-save hook pada model User
    await user.save();

    // Mengirim OTP melalui WhatsApp menggunakan Fonnte
    await sendWhatsAppOTP(phone, otp);

    res.status(200).json({ message: "OTP sent successfully" });
  } catch (error) {
    console.error("Registration error:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// Fungsi untuk memverifikasi OTP pengguna
exports.verifyOTP = async (req, res) => {
  try {
    const { phone, otp } = req.body;

    // Mencari pengguna berdasarkan nomor telepon
    const user = await User.findOne({ phone });
    if (!user) {
      return res.status(400).json({ message: "User not found" });
    }

    // Memeriksa apakah OTP cocok dan masih berlaku
    if (user.otp.code !== otp || user.otp.expiresAt < new Date()) {
      return res.status(400).json({ message: "Invalid or expired OTP" });
    }

    // Menandai pengguna sebagai terverifikasi
    user.isVerified = true;
    user.otp = undefined; // Menghapus OTP setelah verifikasi
    await user.save();

    // Membuat token JWT
    const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET, {
      expiresIn: "1h",
    });

    res.status(200).json({ message: "User verified successfully", token });
  } catch (error) {
    console.error("Error in verifying OTP:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// Fungsi untuk mengirim ulang OTP
exports.resendOTP = async (req, res) => {
  try {
    const { phone } = req.body;

    // Mencari pengguna berdasarkan nomor telepon
    const user = await User.findOne({ phone });
    if (!user) {
      return res.status(400).json({ message: "User not found" });
    }

    // Jika pengguna sudah terverifikasi, tidak perlu mengirim OTP ulang
    if (user.isVerified) {
      return res.status(400).json({ message: "User is already verified" });
    }

    // Membuat OTP baru
    const otp = generateOTP();
    const otpExpiry = new Date();
    otpExpiry.setMinutes(otpExpiry.getMinutes() + 5); // OTP berlaku selama 5 menit

    // Memperbarui OTP pengguna
    user.otp = {
      code: otp,
      expiresAt: otpExpiry,
    };
    await user.save();

    // Mengirim OTP melalui WhatsApp menggunakan Fonnte
    await sendWhatsAppOTP(phone, otp);

    res.status(200).json({ message: "OTP resent successfully" });
  } catch (error) {
    console.error("Error in resending OTP:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// Fungsi login untuk pengguna
exports.login = async (req, res) => {
  try {
    const { phone, password } = req.body;

    // Mencari pengguna berdasarkan nomor telepon
    const user = await User.findOne({ phone });

    if (!user) {
      return res.status(400).json({ message: "User not found" });
    }

    // Memeriksa apakah pengguna dalam kondisi terkunci
    if (user.isLocked()) {
      const lockUntil = new Date(user.lockUntil);
      return res.status(403).json({
        message: `User is banned until ${lockUntil.toLocaleTimeString()}`,
      });
    }

    // Memeriksa apakah password cocok dengan yang disimpan
    const isPasswordMatch = await user.matchPassword(password);
    if (!isPasswordMatch) {
      // Menambah jumlah percobaan login yang gagal
      user.failedLoginAttempts += 1;

      if (user.failedLoginAttempts >= 5) {
        // Mengunci pengguna selama 15 menit
        user.lockUntil = new Date(Date.now() + 15 * 60 * 1000); // 15 menit
        await user.save();
        return res.status(403).json({
          message:
            "User is temporarily banned for 15 minutes due to multiple failed login attempts",
        });
      }

      await user.save();
      return res.status(401).json({ message: "Invalid password" });
    }

    // Mengatur ulang jumlah percobaan login yang gagal pada login sukses
    user.failedLoginAttempts = 0;
    user.lockUntil = undefined;

    // Menghasilkan dan mengirim OTP untuk verifikasi login
    const otp = generateOTP();
    const otpExpiry = new Date();
    otpExpiry.setMinutes(otpExpiry.getMinutes() + 5);

    user.otp = {
      code: otp,
      expiresAt: otpExpiry,
    };
    await user.save();

    // Mengirim OTP melalui WhatsApp
    await sendWhatsAppOTP(phone, otp);

    res.status(200).json({
      message: "OTP sent for login verification",
      name: user.name,
    });
  } catch (error) {
    console.error("Login error:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// Fungsi untuk memverifikasi OTP login
exports.verifyLoginOTP = async (req, res) => {
  try {
    const { phone, password, otp } = req.body;

    // Mencari pengguna berdasarkan nomor telepon
    const user = await User.findOne({ phone });
    if (!user) {
      return res.status(400).json({ message: "User not found" });
    }

    // Memverifikasi password
    const isPasswordMatch = await user.matchPassword(password);
    if (!isPasswordMatch) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    // Memeriksa apakah OTP cocok dan masih berlaku
    if (user.otp.code !== otp || user.otp.expiresAt < new Date()) {
      return res.status(400).json({ message: "Invalid or expired OTP" });
    }

    // Menghapus OTP
    user.otp = undefined;
    await user.save();

    // Membuat token JWT
    const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET, {
      expiresIn: "1h",
    });

    res.status(200).json({
      message: "Login successful",
      token,
      isVerified: true,
      name: user.name,
    });
  } catch (error) {
    console.error("Login OTP verification error:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// Fungsi untuk mengirim ulang OTP login
exports.resendLoginOTP = async (req, res) => {
  try {
    const { phone, password } = req.body;

    // Mencari pengguna berdasarkan nomor telepon
    const user = await User.findOne({ phone });
    if (!user) {
      return res.status(400).json({ message: "User not found" });
    }

    // Memverifikasi password
    const isPasswordMatch = await user.matchPassword(password);
    if (!isPasswordMatch) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    // Membuat OTP baru
    const otp = generateOTP();
    const otpExpiry = new Date();
    otpExpiry.setMinutes(otpExpiry.getMinutes() + 5);

    user.otp = {
      code: otp,
      expiresAt: otpExpiry,
    };
    await user.save();

    // Mengirim OTP melalui WhatsApp
    await sendWhatsAppOTP(phone, otp);

    res.status(200).json({ message: "Login OTP resent successfully" });
  } catch (error) {
    console.error("Error in resending login OTP:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// Fungsi untuk mendapatkan profil pengguna
exports.getUserProfile = async (req, res) => {
  try {
    const user = await User.findById(req.user._id).select("name");
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    res.status(200).json(user);
  } catch (error) {
    console.error("Error fetching user profile:", error);
    res.status(500).json({ message: "Server error" });
  }
};

```
- `middleware/authMiddleware.js`
```javascript
// backend/middleware/authMiddleware.js
const jwt = require("jsonwebtoken");
const User = require("../models/User");

const protect = async (req, res, next) => {
  try {
    let token;

    if (
      req.headers.authorization &&
      req.headers.authorization.startsWith("Bearer")
    ) {
      token = req.headers.authorization.split(" ")[1];
    }

    if (!token) {
      return res.status(401).json({ message: "Not authorized, no token" });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = await User.findById(decoded.userId).select("-otp");
    next();
  } catch (error) {
    console.error("Auth middleware error:", error);
    res.status(401).json({ message: "Not authorized, token failed" });
  }
};

module.exports = { protect };

```
- `models/User.js`
```javascript
// backend/models/User.js
const mongoose = require("mongoose");
const bcrypt = require("bcryptjs");

const userSchema = new mongoose.Schema(
  {
    phone: { type: String, required: true, unique: true },
    name: { type: String, required: true },
    password: { type: String, required: true },
    otp: { 
      code: String, 
      expiresAt: Date 
    },
    isVerified: { type: Boolean, default: false },
    failedLoginAttempts: { type: Number, default: 0 }, // Track failed login attempts
    lockUntil: { type: Date }, // Lock user until this date if necessary
  },
  { timestamps: true }
);

// Method to check if the user is currently locked
userSchema.methods.isLocked = function () {
  return this.lockUntil && this.lockUntil > Date.now();
};

// Compare the entered password with the hashed password
userSchema.methods.matchPassword = async function (enteredPassword) {
  return await bcrypt.compare(enteredPassword, this.password);
};

// Pre-save hook to hash the password before saving
userSchema.pre("save", async function (next) {
  // Only hash the password if it has been modified (or is new)
  if (!this.isModified("password")) {
    return next();
  }
  
  // Generate salt and hash password
  const salt = await bcrypt.genSalt(10);
  this.password = await bcrypt.hash(this.password, salt);
  next();
});

module.exports = mongoose.model("User", userSchema);

```
Penjelasan tambahan:

-   **Kolom `failedLoginAttempts` dan `lockUntil`**: Kolom ini digunakan untuk melacak jumlah percobaan login yang gagal dan menentukan waktu penguncian jika pengguna mencapai batas percobaan yang diizinkan.
-   **Method `isLocked`**: Method ini mengembalikan `true` jika pengguna terkunci dan waktu penguncian (`lockUntil`) masih belum lewat.
-   **Method `matchPassword`**: Method ini membandingkan password yang dimasukkan pengguna dengan password yang tersimpan di database.
-   **Hook `pre("save")`**: Hook ini meng-hash password pengguna sebelum data disimpan, jika password tersebut telah dimodifikasi.
- `routes/authRoutes.js`
```javascript
// backend/routes/authRoutes.js
const express = require("express");
const router = express.Router();
const authController = require("../controllers/authController");
const { protect } = require("../middleware/authMiddleware");

router.post("/register", authController.register);
router.post("/verify-otp", authController.verifyOTP);
router.post("/resend-otp", authController.resendOTP);
router.post("/login", authController.login);
router.post("/verify-login-otp", authController.verifyLoginOTP);
router.post("/resend-login-otp", authController.resendLoginOTP);
router.get("/user-profile", protect, authController.getUserProfile);

module.exports = router;

```
- `utils/fonnte.js`
```javascript
// backend/utils/fonnte.js
const axios = require("axios");

// Fungsi untuk mengirim OTP melalui WhatsApp menggunakan API Fonnte
const sendWhatsAppOTP = async (phone, otp) => {
  try {
    // Format pesan OTP
    const message = `Your OTP code is: ${otp}. This code will expire in 5 minutes.`;

    // Format nomor telepon (pastikan dalam format internasional)
    const formattedPhone = phone.startsWith("+") ? phone : `+${phone}`;

    // Kirim pesan WhatsApp menggunakan Fonnte
    const response = await axios.post(
      "https://api.fonnte.com/send",
      {
        target: formattedPhone,
        message: message,
        countryCode: "", // Kosongkan jika nomor sudah termasuk kode negara
      },
      {
        headers: {
          Authorization: process.env.FONNTE_API_KEY, // API key Fonnte
        },
      }
    );

    console.log("Pesan WhatsApp berhasil dikirim:", response.data);
    return response.data;
  } catch (error) {
    console.error("Gagal mengirim OTP WhatsApp melalui Fonnte:", error);
    throw new Error("Failed to send OTP"); // Lempar error jika pengiriman OTP gagal
  }
};

// Fungsi untuk menghasilkan kode OTP 6 digit acak
const generateOTP = () => {
  return Math.floor(100000 + Math.random() * 900000).toString();
};

module.exports = {
  sendWhatsAppOTP,
  generateOTP,
};

```
Penjelasan tambahan:

-   **Fungsi `sendWhatsAppOTP`**: Mengirim pesan OTP menggunakan API Fonnte. Fungsi ini menerima parameter `phone` (nomor telepon) dan `otp` (kode OTP), kemudian mengirimkan pesan yang berisi kode OTP ke nomor telepon yang dituju.
    -   **Format Nomor Telepon**: Jika nomor telepon tidak diawali dengan tanda `+`, akan otomatis ditambahkan agar berada dalam format internasional.
    -   **Permintaan ke API Fonnte**: Menggunakan `axios` untuk mengirim permintaan POST ke endpoint Fonnte, beserta header Authorization untuk autentikasi API.
    - **Fungsi `generateOTP`**: Menghasilkan kode OTP 6 digit acak

- `server.js`
```javascript
// backend/server.js
const express = require("express");
const cors = require("cors");
const mongoose = require("mongoose");
require("dotenv").config();
const connectDB = require("./config/db"); // Import the MongoDB connection
const errorHandler = require("./middleware/errorHandler");

const authRoutes = require("./routes/authRoutes");
const transactionRoutes = require("./routes/transactionRoutes");
const productRoutes = require("./routes/productRoutes");
const categoryRoutes = require("./routes/categoryRoutes");

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Connect to MongoDB
connectDB();

// Routes
app.use("/api/auth", authRoutes);
app.use("/api/transaction", transactionRoutes);
app.use("/api/products", productRoutes); // <-- Add this line
app.use("/api/categories", categoryRoutes);
app.use(errorHandler);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

```

#### Payment Gateway
- `models/Transaction.js`
```javascript
// /models/Transaction.js
const mongoose = require("mongoose");

const transactionSchema = new mongoose.Schema(
  {
    products: [
      {
        product: {
          type: mongoose.Schema.Types.ObjectId,
          ref: "Product",
          required: true,
        },
        quantity: { type: Number, required: true },
        profit: { type: Number, required: true },
      },
    ],
    totalProfit: { type: Number, required: true },
    totalCost: { type: Number, required: true },
    paymentType: {
      type: String,
      enum: ["cash", "credit", "qris"],
      required: true,
    },
    amountPaid: { type: Number },
    change: { type: Number },
    buyerName: { type: String },
    debt: { type: Number },
    qrisImageUrl: { type: String },
    qrisPaymentUrl: { type: String },
    orderId: { type: String }, // New field for QRIS order ID
    paymentStatus: {
      type: String,
      enum: ["pending", "completed" , "failed"],
      default: "pending",
    },
    date: { type: Date, default: Date.now },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Transaction", transactionSchema);

```
- `controller/transactionController.js`
```javascript
// /controllers/transactionController.js
const Product = require("../models/Product");
const Transaction = require("../models/Transaction");
const {
  createQRISPayment,
  checkPaymentStatus,
} = require("../utils/paymentHelper");
const { validateWebhookRequest } = require("../utils/midtransHelpers");

exports.purchaseProducts = async (req, res) => {
  try {
    const { items, paymentType, amountPaid, buyerName } = req.body;
    let totalProfit = 0;
    let totalCost = 0;
    let productDetails = [];

    for (const item of items) {
      const { productId, quantity } = item;
      const product = await Product.findById(productId);
      if (!product)
        return res
          .status(404)
          .json({ message: `Product with ID ${productId} not found` });
      if (product.stock < quantity)
        return res
          .status(400)
          .json({ message: `Not enough stock for product ${product.name}` });

      const profit = (product.salePrice - product.producerPrice) * quantity;
      totalProfit += profit;
      totalCost += product.salePrice * quantity;
      productDetails.push({ product: productId, quantity, profit });
      product.stock -= quantity;
      await product.save();
    }

    let transactionData = {
      products: productDetails,
      totalProfit,
      totalCost,
      paymentType,
    };

    switch (paymentType) {
      case "cash":
        if (amountPaid < totalCost) {
          return res
            .status(400)
            .json({ message: "Amount paid is insufficient for cash payment" });
        }
        transactionData.amountPaid = amountPaid;
        transactionData.change = amountPaid - totalCost;
        transactionData.paymentStatus = "completed";
        break;

      case "credit":
        transactionData.buyerName = buyerName;
        transactionData.debt = totalCost;
        break;

      case "qris":
        const { orderId, qrisUrl, qrisImageUrl } = await createQRISPayment(
          totalCost
        );
        transactionData.qrisPaymentUrl = qrisUrl;
        transactionData.qrisImageUrl = qrisImageUrl;
        transactionData.paymentStatus = "pending";
        transactionData.orderId = orderId;
        break;

      default:
        return res.status(400).json({ message: "Invalid payment type" });
    }

    const transaction = new Transaction(transactionData);
    await transaction.save();

    if (paymentType === "qris") {
      return res.status(201).json({
        message: "QRIS payment generated. Awaiting payment confirmation",
        qrisUrl: transaction.qrisPaymentUrl,
        orderId: transaction.orderId,
      });
    }

    res
      .status(201)
      .json({ message: "Transaction completed successfully", transaction });
  } catch (error) {
    console.error("Error processing purchase:", error);
    res.status(500).json({ message: "Server error" });
  }
};
// Hitung total untung hari ini
exports.getTodayProfit = async (req, res) => {
  try {
    const today = new Date();
    today.setHours(0, 0, 0, 0); // Set to start of the day

    // Ambil semua transaksi hari ini
    const transactions = await Transaction.find({
      date: { $gte: today },
    });

    // Akumulasi keuntungan harian dari setiap transaksi
    const totalProfit = transactions.reduce((acc, transaction) => {
      return acc + transaction.totalProfit;
    }, 0);

    res.status(200).json({ totalProfit });
  } catch (error) {
    console.error("Error fetching today's profit:", error);
    res.status(500).json({ message: "Server error" });
  }
};

exports.updateTransactionStatus = async (req, res) => {
  try {
    const { transactionId, status } = req.body;

    if (!["completed", "pending"].includes(status)) {
      return res
        .status(400)
        .json({ message: "Invalid status for cash or credit" });
    }

    const transaction = await Transaction.findById(transactionId);
    if (!transaction)
      return res.status(404).json({ message: "Transaction not found" });

    if (transaction.paymentType === "qris") {
      return res
        .status(400)
        .json({ message: "Use QRIS webhook for status updates" });
    }

    transaction.paymentStatus = status;
    if (status === "completed" && transaction.paymentType === "credit")
      transaction.debt = 0;

    await transaction.save();
    res.status(200).json({ message: "Status updated", transaction });
  } catch (error) {
    console.error("Error updating status:", error);
    res.status(500).json({ message: "Server error" });
  }
};

exports.getTransactions = async (req, res) => {
  try {
    const { paymentType, paymentStatus } = req.query;
    let filter = {};

    if (paymentType) filter.paymentType = paymentType;
    if (paymentStatus) filter.paymentStatus = paymentStatus;

    const transactions = await Transaction.find(filter).populate(
      "products.product"
    );
    res.status(200).json({ transactions });
  } catch (error) {
    console.error("Error fetching transactions:", error);
    res.status(500).json({ message: "Server error" });
  }
};

exports.getDebtors = async (req, res) => {
  try {
    const debtors = await Transaction.find({
      paymentType: "credit",
      debt: { $gt: 0 },
    })
      .select("buyerName debt")
      .populate("products.product");
    res.status(200).json({ debtors });
  } catch (error) {
    console.error("Error fetching debtors:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// Endpoint webhook untuk pembayaran QRIS
exports.qrisWebhook = async (req, res) => {
  try {
    // Validate webhook signature
    if (!validateWebhookRequest(req.body)) {
      return res.status(403).json({ message: "Invalid signature" });
    }

    const { order_id, transaction_status } = req.body;

    const transaction = await Transaction.findOne({ orderId: order_id });
    if (!transaction) {
      return res.status(404).json({ message: "Transaction not found" });
    }

    switch (transaction_status) {
      case "settlement":
        transaction.paymentStatus = "completed";
        break;
      case "pending":
        transaction.paymentStatus = "pending";
        break;
      case "cancel":
      case "expire":
      case "deny":
        transaction.paymentStatus = "failed";
        break;
    }

    await transaction.save();
    res.status(200).json({ message: "Webhook processed successfully" });
  } catch (error) {
    console.error("Error processing webhook:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// Add new endpoint to check payment status
exports.checkQRISStatus = async (req, res) => {
  try {
    const { orderId } = req.params;
    const transaction = await Transaction.findOne({ orderId });

    if (!transaction) {
      return res.status(404).json({ message: "Transaction not found" });
    }

    const paymentStatus = await checkPaymentStatus(orderId);

    if (paymentStatus.transaction_status === "settlement") {
      transaction.paymentStatus = "completed";
      await transaction.save();
    }

    res.status(200).json({
      transactionStatus: transaction.paymentStatus,
      midtransStatus: paymentStatus.transaction_status,
    });
  } catch (error) {
    console.error("Error checking QRIS status:", error);
    res.status(500).json({ message: "Server error" });
  }
};

```
- `routes/trancationRoutes.js`
```javascript
// backend/routes/transactionRoutes.js
const express = require("express");
const router = express.Router();
const transactionController = require("../controllers/transactionController");

router.post("/purchase", transactionController.purchaseProducts);
router.get("/profit-today", transactionController.getTodayProfit);
router.post("/qris-webhook", transactionController.qrisWebhook);
router.get("/qris-status/:orderId", transactionController.checkQRISStatus);

module.exports = router;

```
- `utils/paymentHelper.js`
```javascript
// utils/paymentHelper.js
const axios = require("axios");

async function createQRISPayment(amount) {
  const orderId = `order-${Date.now()}`; // Generate unique order ID

  try {
    const response = await axios.post(
      process.env.MIDTRANS_ENV === "production"
        ? "https://api.midtrans.com/v2/charge"
        : "https://api.sandbox.midtrans.com/v2/charge",
      {
        payment_type: "qris",
        transaction_details: {
          order_id: orderId,
          gross_amount: amount,
        },
        qris: { acquirer: "gopay" },
      },
      {
        headers: {
          "Content-Type": "application/json",
          Authorization: `Basic ${Buffer.from(
            process.env.MIDTRANS_SERVER_KEY + ":"
          ).toString("base64")}`,
        },
      }
    );

    return { orderId, qrisUrl: response.data.actions[0].url };
  } catch (error) {
    console.error("Midtrans API Error:", error.response?.data || error.message);
    throw new Error("Failed to create QRIS payment");
  }
}

// Function to check payment status
async function checkPaymentStatus(orderId) {
  try {
    const response = await axios.get(
      `${
        process.env.MIDTRANS_ENV === "production"
          ? "https://api.midtrans.com"
          : "https://api.sandbox.midtrans.com"
      }/v2/${orderId}/status`,
      {
        headers: {
          Authorization: `Basic ${Buffer.from(
            process.env.MIDTRANS_SERVER_KEY + ":"
          ).toString("base64")}`,
        },
      }
    );
    return response.data;
  } catch (error) {
    console.error("Error checking payment status:", error);
    throw new Error("Failed to check payment status");
  }
}

module.exports = { createQRISPayment, checkPaymentStatus };

```
Kode API di atas mengimplementasikan alur transaksi dengan integrasi pembayaran QRIS menggunakan layanan Midtrans. Berikut adalah penjelasan ringkas dari setiap bagian terkait QRIS:

1.  **Transaksi Pembelian dengan QRIS (`purchaseProducts` di `transactionController.js`)**:

    -   Saat pembeli memilih QRIS sebagai metode pembayaran, fungsi `createQRISPayment` dari `paymentHelper.js` dipanggil. Fungsi ini mengirimkan permintaan ke API Midtrans untuk membuat pembayaran QRIS.
    -   Midtrans kemudian mengembalikan `orderId`, `qrisUrl`, dan gambar QRIS (`qrisImageUrl`), yang digunakan untuk menghasilkan kode QR bagi pelanggan.
    -   Data transaksi dengan status "pending" disimpan ke database dan URL QRIS dikirimkan kembali ke pembeli untuk melakukan pembayaran.
2.  **Memeriksa Status Pembayaran QRIS (`checkQRISStatus` di `transactionController.js`)**:

    -   Endpoint ini memungkinkan klien memeriksa status pembayaran QRIS untuk transaksi tertentu berdasarkan `orderId`.
    -   Fungsi `checkPaymentStatus` memeriksa status terbaru dari Midtrans, lalu memperbarui status pembayaran di database jika telah berubah menjadi "completed".
3.  **Helper Pembayaran QRIS (`paymentHelper.js`)**:

    -   `createQRISPayment` berfungsi membuat transaksi QRIS dengan memanggil API Midtrans, lalu mengembalikan informasi seperti `orderId` dan `qrisUrl`.
    -   `checkPaymentStatus` berfungsi memeriksa status transaksi QRIS dengan `orderId` yang diberikan dan mengembalikan status terbaru dari Midtrans.

Secara keseluruhan, kode ini mengelola alur transaksi pembayaran menggunakan QRIS melalui Midtrans. Kode ini menyediakan endpoint untuk membuat transaksi QRIS, menerima notifikasi dari Midtrans melalui webhook, serta memeriksa status transaksi QRIS kapan saja.

### 3. Mengintegrasikan Desain Figma (Flutter) dengan API
Tahapan ini mencakup proses menghubungkan aplikasi Flutter dengan API yang sudah dibuat.

- `main.dart`
```dart
import 'package:flutter/material.dart';
import 'package:minggu_4/pages/splash_screen.dart';
import 'package:minggu_4/pages/intro_screen.dart';
import 'package:minggu_4/pages/transaksi_screen.dart';
import 'package:minggu_4/pages/cash_screen.dart';
import 'package:minggu_4/pages/success_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warung Mbah Manto',
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreenPage(), // Start with splash screen
      routes: {
        '/intro': (context) => const IntroScreen(),
        '/transaksi': (context) => TransaksiScreen(
              token: 'your_token', // Replace with actual token
              cart: {}, // Replace with actual cart data
              onCartUpdate: (updatedCart) {},
            ),
        '/cash': (context) => CashScreen(
              items: [], // Replace with actual items
              totalCost: 0.0, // Replace with actual total cost
              paymentType: 'cash', // Replace with the appropriate payment type
              token: 'your_token', // Replace with actual token
              onPaymentComplete: (_) {},
            ),
        '/success': (context) => SuccessScreen(),
      },
    );
  }
}

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    // Navigate to IntroScreen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/intro');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen(); // Show the splash screen first
  }
}

```

- `splash_screen.dart`
```dart
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF093C25), // Dark green background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // The logo part of the splash screen
            Container(
              width:
                  300, // Adjust the width and height to fit the logo perfectly
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'public/hero.png'), // Replace with your image path
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // The text under the logo
            const Text(
              'Warung Mbah Manto',
              style: TextStyle(
                fontSize: 30, // Adjust the font size
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}

```

- `intro_screen.dart`
```dart
// lib/pages/intro_screen.dart
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF093C25), // Dark green background color
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 60), // Space from top
            Column(
              children: [
                Image.asset(
                  'public/hero.png', // Top icon
                  height: 150,
                ),
                const SizedBox(height: 24),
                Text(
                  'Kelola stok dan transaksi sembako dengan mudah dalam satu aplikasi!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 37,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B9B5E), // Button color
                    minimumSize: const Size(200, 60), // Full width button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  onPressed: () {
                    // Navigate to the login screen (home_screen)
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                    );
                  },
                  child: const Text(
                    'Mulai Kelola',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Image.asset(
                  'public/sembakoku.png', // Bottom image
                  height: 380,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

```

- `home_screen.dart`
```dart
// lib/pages/home_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minggu_4/pages/login_verify.dart';
import 'dart:convert';
import 'package:minggu_4/pages/register_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void showMessage(String message, {bool isError = true}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            isError ? 'Error' : 'Success',
            style: GoogleFonts.poppins(),
          ),
          content: Text(
            message,
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK', style: GoogleFonts.poppins()),
            ),
          ],
        );
      },
    );
  }

  void showBanMessage(DateTime lockUntil) {
    Duration remaining = lockUntil.difference(DateTime.now());
    String minutes = remaining.inMinutes.toString();

    showMessage(
      'Akun Anda dibanned sementara selama 15 menit. Sisa waktu: $minutes menit.',
      isError: true,
    );
  }

  Future<void> login() async {
    if (phoneController.text.isEmpty || passwordController.text.isEmpty) {
      showMessage("Nomor HP dan password tidak boleh kosong!");
      return;
    }

    String formattedPhone = phoneController.text;
    if (!formattedPhone.startsWith('+')) {
      formattedPhone = '+$formattedPhone';
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phone': formattedPhone,
          'password': passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        json.decode(response.body);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginVerifyPage(
              phone: formattedPhone,
              password: passwordController.text,
            ),
          ),
        );
      } else if (response.statusCode == 403) {
        final error = json.decode(response.body);
        if (error['message'].contains('banned')) {
          DateTime lockUntil = DateTime.parse(error['lockUntil']);
          showBanMessage(lockUntil);
        } else {
          showMessage(error['message'] ?? 'Login gagal');
        }
      } else {
        final error = json.decode(response.body);
        showMessage(error['message'] ?? 'Login gagal');
      }
    } catch (e) {
      showMessage('Terjadi kesalahan: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF093C25),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF157B3E),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: Container(
                  width: 300,
                  height: 300,
                  child: Image.asset(
                    'public/hero.png',
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Sign In',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Nomor Handphone',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: TextField(
                  controller: phoneController,
                  style: GoogleFonts.poppins(color: Color(0xFF000000)),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    hintText: '628188280680',
                    hintStyle: GoogleFonts.poppins(color: Color(0xFFB0A6A6)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Password',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: GoogleFonts.poppins(color: Color(0xFF000000)),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    hintText: 'Password',
                    hintStyle: GoogleFonts.poppins(color: Color(0xFFB0A6A6)),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A86B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Sign In',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum memiliki akun? ',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Daftarkan sekarang',
                        style: GoogleFonts.poppins(
                          color: Color(0xFF00A86B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

```

- `register_screen.dart`
```dart
// lib/pages/register_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'verify_pages.dart';
import 'home_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    phoneController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void showMessage(String message, {bool isError = true}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isError ? 'Error' : 'Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> register() async {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty) {
      showMessage("Nama, Nomor HP, dan Password tidak boleh kosong!");
      return;
    }

    String formattedPhone = phoneController.text;
    if (!formattedPhone.startsWith('+')) {
      formattedPhone = '+$formattedPhone';
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': nameController.text,
          'phone': formattedPhone,
          'password': passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyPage(
              phone: formattedPhone,
              name: nameController.text,
            ),
          ),
        );
      } else {
        final error = json.decode(response.body);
        showMessage(error['message'] ?? 'Terjadi kesalahan');
      }
    } catch (e) {
      showMessage('Terjadi kesalahan: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF093C25),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                './public/hero.png',
                height: 300,
                width: 300,
              ),
              const SizedBox(height: 20),
              Text(
                "Sign Up",
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Nomor Handphone",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              TextFieldContainer(
                child: TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: "+6281882880680",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Nama",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              TextFieldContainer(
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: "Frank Ocean",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Password",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              TextFieldContainer(
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (!isLoading)
                GestureDetector(
                  onTap: register,
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color(0xFF10B981),
                    ),
                    child: Center(
                      child: Text(
                        "Sign Up",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                )
              else
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sudah memiliki akun?",
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                      );
                    },
                    child: Text(
                      "Login sekarang",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF10B981),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E5E5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: child,
    );
  }
}

```

- `verify_pages.dart`
```dart
// verify_pages.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:minggu_4/pages/main_screen.dart';

class VerifyPage extends StatefulWidget {
  final String phone;
  final String name;

  const VerifyPage({
    super.key,
    required this.phone,
    required this.name,
  });

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final otpController = TextEditingController();
  bool isLoading = false;
  bool isResending = false;

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  void showMessage(String message, {bool isError = true}) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text(isError ? 'Error' : 'Success', style: GoogleFonts.poppins()),
          content: Text(message, style: GoogleFonts.poppins()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> verifyOTP() async {
    if (otpController.text.isEmpty) {
      showMessage("Kode OTP tidak boleh kosong!");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phone': widget.phone,
          'otp': otpController.text,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['token'] != null) {
        final token = data['token'];

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MainScreen(
              token: token,
            ),
          ),
        );
      } else {
        showMessage(data['message'] ?? 'Verifikasi OTP gagal');
      }
    } catch (e) {
      showMessage('Terjadi kesalahan: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> resendOTP() async {
    setState(() {
      isResending = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/auth/resend-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phone': widget.phone,
        }),
      );

      if (response.statusCode == 200) {
        showMessage('OTP baru telah dikirim ke WhatsApp Anda', isError: false);
      } else {
        final error = json.decode(response.body);
        showMessage(error['message'] ?? 'Gagal mengirim ulang OTP');
      }
    } catch (e) {
      showMessage('Terjadi kesalahan: $e');
    } finally {
      setState(() {
        isResending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verifikasi OTP',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF093C25),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFF093C25),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Masukkan Kode OTP',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Kode OTP telah dikirim ke WhatsApp ${widget.phone}',
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.yellow.shade50,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Kode OTP",
                      labelStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      hintText: "Masukkan 6 digit kode OTP",
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (!isLoading) ...[
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFF1B9B5E),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.shade600.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: verifyOTP,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Verifikasi",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFFFFC107)),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              if (!isResending) ...[
                Center(
                  child: TextButton(
                    onPressed: resendOTP,
                    child: Text(
                      "Kirim Ulang OTP",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFFFC107),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFFFFC107)),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B9B5E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Catatan:',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Kode OTP akan dikirim melalui WhatsApp ke nomor ${widget.phone}',
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: Colors.white),
                    ),
                    Text(
                      '• Kode OTP berlaku selama 5 menit',
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: Colors.white),
                    ),
                    Text(
                      '• Pastikan aplikasi WhatsApp Anda aktif',
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

```

- `login_verify.dart`
```dart
// lib/pages/login_verify.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:minggu_4/pages/main_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginVerifyPage extends StatefulWidget {
  final String phone;
  final String password;

  const LoginVerifyPage({
    Key? key,
    required this.phone,
    required this.password,
  }) : super(key: key);

  @override
  _LoginVerifyPageState createState() => _LoginVerifyPageState();
}

class _LoginVerifyPageState extends State<LoginVerifyPage> {
  final otpController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  void showMessage(String message, {bool isError = true}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isError ? 'Error' : 'Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> verifyLoginOTP() async {
    if (otpController.text.isEmpty) {
      showMessage("OTP tidak boleh kosong!");
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/auth/verify-login-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phone': widget.phone,
          'password': widget.password,
          'otp': otpController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String token = data['token'];

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(token: token),
          ),
        );
      } else {
        final error = json.decode(response.body);
        showMessage(error['message'] ?? 'Verifikasi OTP gagal');
      }
    } catch (e) {
      showMessage('Terjadi kesalahan: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> resendLoginOTP() async {
    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/auth/resend-login-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phone': widget.phone,
          'password': widget.password,
        }),
      );

      if (response.statusCode == 200) {
        showMessage("OTP berhasil dikirim ulang", isError: false);
      } else {
        final error = json.decode(response.body);
        showMessage(error['message'] ?? 'Gagal mengirim ulang OTP');
      }
    } catch (e) {
      showMessage('Terjadi kesalahan: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verifikasi OTP',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF093C25),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFF093C25),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Masukkan Kode OTP',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Kode OTP telah dikirim ke WhatsApp ${widget.phone}',
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade300,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.green.shade50,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Kode OTP",
                      labelStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      hintText: "Masukkan 6 digit kode OTP",
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF1B9B5E)),
                      ),
                    )
                  : Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color(0xFF1B9B5E),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.shade700.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextButton(
                            onPressed: verifyLoginOTP,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Verifikasi",
                                  style: GoogleFonts.poppins(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: TextButton(
                            onPressed: resendLoginOTP,
                            child: Text(
                              "Kirim Ulang OTP",
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF1B9B5E),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B9B5E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Catatan:',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Kode OTP akan dikirim melalui WhatsApp ke nomor ${widget.phone}',
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: Colors.white),
                    ),
                    const Text(
                      '• Kode OTP berlaku selama 5 menit',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    const Text(
                      '• Pastikan aplikasi WhatsApp Anda aktif',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

```

- `main_screen.dart`
```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:minggu_4/pages/edit_screen.dart';
import 'package:minggu_4/pages/add_screen.dart';
import 'package:minggu_4/pages/detail_screen.dart';
import 'package:minggu_4/pages/transaksi_screen.dart';
import 'package:google_fonts/google_fonts.dart'; // Tambahkan ini

class MainScreen extends StatefulWidget {
  final String token;

  const MainScreen({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? userName;
  List<dynamic> products = [];
  List<dynamic> categories = [];
  Map<String, int> cart = {};
  bool isLoading = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _minStockController = TextEditingController();
  final TextEditingController _producerPriceController =
      TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchProducts();
    fetchCategories();
  }

  Future<void> fetchUserData() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/auth/user-profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userName = data['name'];
        });
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/categories'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          categories = data['categories'];
        });
      }
    } catch (error) {
      print('Error fetching categories: $error');
    }
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/products'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          products = data['products'];
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching products: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addProduct() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/products'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': _nameController.text,
          'stock': int.parse(_stockController.text),
          'minStock': int.parse(_minStockController.text),
          'producerPrice': double.parse(_producerPriceController.text),
          'salePrice': double.parse(_salePriceController.text),
          'description': _descriptionController.text,
          'imageUrl': _imageUrlController.text,
          'category': selectedCategory,
        }),
      );

      if (response.statusCode == 201) {
        fetchProducts();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added successfully')),
        );
      }
    } catch (error) {
      print('Error adding product: $error');
    }
  }

  Future<void> updateProduct(String id) async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:3000/api/products/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': _nameController.text,
          'stock': int.parse(_stockController.text),
          'minStock': int.parse(_minStockController.text),
          'producerPrice': double.parse(_producerPriceController.text),
          'salePrice': double.parse(_salePriceController.text),
          'description': _descriptionController.text,
          'imageUrl': _imageUrlController.text,
          'category': selectedCategory,
        }),
      );

      if (response.statusCode == 200) {
        fetchProducts();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product updated successfully')),
        );
      }
    } catch (error) {
      print('Error updating product: $error');
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:3000/api/products/$id'),
      );

      if (response.statusCode == 200) {
        fetchProducts();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product deleted successfully')),
        );
      }
    } catch (error) {
      print('Error deleting product: $error');
    }
  }

  void addToCart(String productId) {
    setState(() {
      cart[productId] = (cart[productId] ?? 0) + 1;
    });
  }

  void navigateToEditScreen(Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditScreen(
          token: widget.token,
          productId: product['_id'] ?? '', // Optional productId for new product
          onSave: fetchProducts,
        ),
      ),
    );
  }

  void navigateToAddScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddScreen(
          token: widget.token,
          onSave: fetchProducts, // Callback to refresh product list
        ),
      ),
    );
  }

  void navigateToTransactionScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransaksiScreen(
          token: widget.token,
          cart: cart,
          onCartUpdate: (updatedCart) {
            setState(() {
              cart = updatedCart;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF093C25),
        title: Text(
          'Kelola Produk',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.add, color: Colors.white), // Icon warna putih
            onPressed: () => navigateToAddScreen(),
          ),
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart,
                    color: Colors.white), // Icon warna putih
                onPressed: () => navigateToTransactionScreen(),
              ),
              if (cart.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Text(
                    cart.values.reduce((a, b) => a + b).toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(product: product),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(product['imageUrl'] ??
                                    'https://via.placeholder.com/150'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'],
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Rp${product['salePrice']}',
                                style: GoogleFonts.poppins(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Stock: ${product['stock']}',
                                style: GoogleFonts.poppins(),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
                                    onPressed: () =>
                                        navigateToEditScreen(product),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () =>
                                        deleteProduct(product['_id']),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle,
                                        color: Colors.green),
                                    onPressed: () => addToCart(product['_id']),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

```

- `detail_screen.dart`
```dart
// lib/pages/detail_screen.dart
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const DetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Produk Utama
            Center(
              child: Image.network(
                product['imageUrl'] ?? 'https://via.placeholder.com/150',
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            // Harga Produk
            Text(
              'Rp ${product['salePrice']}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 10),
            // Nama Produk
            Text(
              product['name'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            // Deskripsi Produk
            Text(
              product['description'] ?? '',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            // Detail Produk
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildDetailCard('Stock', product['stock'].toString()),
                _buildDetailCard('Min Stock', product['minStock'].toString()),
                _buildDetailCard('Harga', 'Rp ${product['salePrice']}'),
                _buildDetailCard(
                    'Harga Asal', 'Rp ${product['producerPrice']}'),
                _buildDetailCard(
                    'Kategori', product['category']?['name'] ?? ''),
                _buildDetailCard('Status', product['status']),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}

```

- `add_screen.dart`
```dart
// lib/pages/add_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class AddScreen extends StatefulWidget {
  final String token;
  final VoidCallback onSave;

  const AddScreen({
    Key? key,
    required this.token,
    required this.onSave,
  }) : super(key: key);

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _minStockController = TextEditingController();
  final TextEditingController _producerPriceController =
      TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  String? selectedCategoryId;
  List<dynamic> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/categories'),
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          categories = data; // Save categories list
        });
      }
    } catch (error) {
      print('Error fetching categories: $error');
    }
  }

  Future<void> addProduct() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/products'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: json.encode({
          'name': _nameController.text,
          'stock': int.parse(_stockController.text),
          'minStock': int.parse(_minStockController.text),
          'producerPrice': double.parse(_producerPriceController.text),
          'salePrice': double.parse(_salePriceController.text),
          'description': _descriptionController.text,
          'imageUrl': _imageUrlController.text,
          'category': selectedCategoryId,
        }),
      );

      if (response.statusCode == 201) {
        widget.onSave();
        Navigator.pop(context); // Return to the previous screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added successfully')),
        );
      }
    } catch (error) {
      print('Error adding product: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Produk',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF093C25),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTextField(_nameController, 'Product Name'),
            _buildTextField(_stockController, 'Stock',
                keyboardType: TextInputType.number),
            _buildTextField(_minStockController, 'Minimum Stock',
                keyboardType: TextInputType.number),
            _buildTextField(_producerPriceController, 'Producer Price',
                keyboardType: TextInputType.number),
            _buildTextField(_salePriceController, 'Sale Price',
                keyboardType: TextInputType.number),
            _buildTextField(_descriptionController, 'Description'),
            _buildTextField(_imageUrlController, 'Image URL'),
            DropdownButtonFormField<String>(
              value: selectedCategoryId,
              onChanged: (value) {
                setState(() {
                  selectedCategoryId = value;
                });
              },
              items: categories.map<DropdownMenuItem<String>>((category) {
                return DropdownMenuItem<String>(
                  value: category['_id'],
                  child: Text(
                    category['name'],
                    style: GoogleFonts.poppins(),
                  ),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Category',
                labelStyle: GoogleFonts.poppins(fontSize: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addProduct,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                backgroundColor: const Color(0xFF10B981),
                textStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text(
                'Tambah Produk',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: GoogleFonts.poppins(fontSize: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        ),
        style: GoogleFonts.poppins(),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _stockController.dispose();
    _minStockController.dispose();
    _producerPriceController.dispose();
    _salePriceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
}

```

- `edit_screen.dart`
```dart
// lib/pages/edit_screen.dart
// lib/pages/edit_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class EditScreen extends StatefulWidget {
  final String token;
  final String productId; // Product ID for editing
  final VoidCallback? onSave; // Callback to refresh product list

  const EditScreen({
    Key? key,
    required this.token,
    required this.productId,
    this.onSave,
  }) : super(key: key);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _minStockController = TextEditingController();
  final TextEditingController _producerPriceController =
      TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  String? selectedCategory;
  List<dynamic> categories = [];

  @override
  void initState() {
    super.initState();
    if (widget.productId.isNotEmpty) {
      fetchProductDetails();
    }
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/categories'),
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          categories = data;
        });
      }
    } catch (error) {
      print('Error fetching categories: $error');
    }
  }

  Future<void> fetchProductDetails() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/products/${widget.productId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _nameController.text = data['name'];
          _stockController.text = data['stock'].toString();
          _minStockController.text = data['minStock'].toString();
          _producerPriceController.text = data['producerPrice'].toString();
          _salePriceController.text = data['salePrice'].toString();
          _descriptionController.text = data['description'];
          _imageUrlController.text = data['imageUrl'];
          selectedCategory = data['category'];
        });
      } else {
        print('Failed to fetch product details');
      }
    } catch (error) {
      print('Error fetching product details: $error');
    }
  }

  Future<void> updateProduct() async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:3000/api/products/${widget.productId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: json.encode({
          'name': _nameController.text,
          'stock': int.parse(_stockController.text),
          'minStock': int.parse(_minStockController.text),
          'producerPrice': double.parse(_producerPriceController.text),
          'salePrice': double.parse(_salePriceController.text),
          'description': _descriptionController.text,
          'imageUrl': _imageUrlController.text,
          'category': selectedCategory,
        }),
      );

      if (response.statusCode == 200) {
        widget.onSave?.call();
        Navigator.pop(context, true);
      } else {
        print('Failed to update product');
      }
    } catch (error) {
      print('Error updating product: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Produk',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF093C25),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_nameController, 'Nama Produk'),
              _buildTextField(_stockController, 'Stok',
                  keyboardType: TextInputType.number),
              _buildTextField(_minStockController, 'Stok Minimum',
                  keyboardType: TextInputType.number),
              _buildTextField(_producerPriceController, 'Harga Produsen',
                  keyboardType: TextInputType.number),
              _buildTextField(_salePriceController, 'Harga Jual',
                  keyboardType: TextInputType.number),
              _buildTextField(_descriptionController, 'Deskripsi', maxLines: 3),
              _buildTextField(_imageUrlController, 'URL Gambar'),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                items: categories.map<DropdownMenuItem<String>>((category) {
                  return DropdownMenuItem<String>(
                    value: category['_id'],
                    child: Text(
                      category['name'],
                      style: GoogleFonts.poppins(),
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  labelStyle: GoogleFonts.poppins(fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    updateProduct();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: const Color(0xFF10B981),
                  textStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text(
                  'Perbarui Produk',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: GoogleFonts.poppins(fontSize: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        ),
        style: GoogleFonts.poppins(),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _stockController.dispose();
    _minStockController.dispose();
    _producerPriceController.dispose();
    _salePriceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
}

```

- `transaksi_screen.dart`
```dart
// lib/pages/transaksi_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:minggu_4/pages/cash_screen.dart';
import 'package:minggu_4/pages/qris_screen.dart';

class TransaksiScreen extends StatefulWidget {
  final String token;
  final Map<String, int> cart;
  final ValueChanged<Map<String, int>> onCartUpdate;

  const TransaksiScreen({
    Key? key,
    required this.token,
    required this.cart,
    required this.onCartUpdate,
  }) : super(key: key);

  @override
  _TransaksiScreenState createState() => _TransaksiScreenState();
}

class _TransaksiScreenState extends State<TransaksiScreen> {
  Map<String, int> updatedCart = {};
  Map<String, dynamic> productDetails = {};
  final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

  @override
  void initState() {
    super.initState();
    updatedCart = Map.from(widget.cart); // Copy cart data
    _fetchProductDetails();
  }

  Future<void> _fetchProductDetails() async {
    final ids = updatedCart.keys.join(',');
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/api/products?ids=$ids'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json',
      },
    );

    print('Response body: ${response.body}'); // Cek isi respons sebelum parsing

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final List products = responseBody['products'];
        setState(() {
          for (var product in products) {
            productDetails[product['_id']] = product;
          }
        });
      } catch (e) {
        print('Error parsing JSON: $e');
      }
    } else {
      print(
          'Failed to load product details. Status code: ${response.statusCode}');
    }
  }

  void adjustQuantity(String productId, int delta) {
    setState(() {
      updatedCart[productId] = (updatedCart[productId] ?? 0) + delta;
      if (updatedCart[productId]! <= 0) {
        updatedCart.remove(productId);
      }
    });
    widget.onCartUpdate(updatedCart);
  }

  void proceedToPayment(String paymentType) async {
    // Calculate items and total cost once
    final items = updatedCart.entries.map((entry) {
      final product = productDetails[entry.key];
      return {
        'productId': entry.key,
        'productName':
            product != null ? product['name'] : 'Product ${entry.key}',
        'quantity': entry.value,
        'price': product != null
            ? (product['salePrice'] as num).toDouble()
            : 10000.0,
      };
    }).toList();

    final totalCost = items.fold<double>(
      0,
      (sum, item) =>
          sum + ((item['price'] as double) * (item['quantity'] as int)),
    );

    if (paymentType == 'qris') {
      // Handle QRIS payment
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/transaction/purchase'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'items': items
              .map((item) => {
                    'productId': item['productId'],
                    'quantity': item['quantity']
                  })
              .toList(),
          'paymentType': 'qris',
        }),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final qrisUrl = responseData['qrisUrl'];
        final orderId = responseData['orderId'];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QRISScreen(
              items: items,
              totalCost: totalCost,
              qrisUrl: qrisUrl,
              orderId: orderId,
              token: widget.token,
              onPaymentComplete: (_) {
                setState(() {
                  updatedCart.clear();
                  widget.onCartUpdate(updatedCart);
                });
              },
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('QRIS transaction failed: ${response.body}')),
        );
      }
    } else if (paymentType == 'cash') {
      // Handle cash payment without changes
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CashScreen(
            items: items,
            totalCost: totalCost,
            paymentType: paymentType,
            token: widget.token,
            onPaymentComplete: (_) {
              setState(() {
                updatedCart.clear();
                widget.onCartUpdate(updatedCart);
              });
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: updatedCart.keys.length,
        itemBuilder: (context, index) {
          final productId = updatedCart.keys.elementAt(index);
          final quantity = updatedCart[productId] ?? 0;
          final product = productDetails[productId];
          final productName =
              product != null ? product['name'] : 'Product ID: $productId';
          final productPrice = product != null ? product['salePrice'] : 0.0;

          return ListTile(
            title: Text(productName),
            subtitle: Text(
                'Harga: ${formatCurrency.format(productPrice)}\nQuantity: $quantity'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => adjustQuantity(productId, -1),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => adjustQuantity(productId, 1),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () => proceedToPayment("cash"),
              child: const Text("Cash"),
            ),
            ElevatedButton(
              onPressed: () => proceedToPayment("credit"),
              child: const Text("Credit"),
            ),
            ElevatedButton(
              onPressed: () => proceedToPayment("qris"),
              child: const Text("QRIS"),
            ),
          ],
        ),
      ),
    );
  }
}

```

- `cash_screen.dart`
```dart
// lib/pages/cash_screen.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CashScreen extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final double totalCost;
  final String paymentType;
  final String token;
  final ValueChanged<void> onPaymentComplete;

  const CashScreen({
    Key? key,
    required this.items,
    required this.totalCost,
    required this.paymentType,
    required this.token,
    required this.onPaymentComplete,
  }) : super(key: key);

  @override
  _CashScreenState createState() => _CashScreenState();
}

class _CashScreenState extends State<CashScreen> {
  double amountPaid = 0.0;
  double change = 0.0;
  final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

  void calculateChange() {
    setState(() {
      change = amountPaid - widget.totalCost;
    });
  }

  Future<void> completePayment() async {
    if (amountPaid < widget.totalCost) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insufficient payment amount')),
      );
      return;
    }

    final transactionData = {
      'items': widget.items
          .map((item) => {
                'productId': item['productId'],
                'quantity': item['quantity'],
              })
          .toList(),
      'paymentType': widget.paymentType,
      'amountPaid': amountPaid,
    };

    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/transaction/purchase'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json',
      },
      body: json.encode(transactionData),
    );

    if (response.statusCode == 201) {
      widget.onPaymentComplete(null);
      Navigator.pushReplacementNamed(context, '/success');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaction failed: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cash Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...widget.items.map((item) => ListTile(
                  title: Text(item['productName']),
                  subtitle: Text('Quantity: ${item['quantity']}'),
                  trailing:
                      Text('Price: ${formatCurrency.format(item['price'])}'),
                )),
            const Divider(),
            Text(
              'Total Cost: ${formatCurrency.format(widget.totalCost)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount Paid'),
              onChanged: (value) {
                setState(() {
                  amountPaid = double.tryParse(value) ?? 0.0;
                  calculateChange();
                });
              },
            ),
            const SizedBox(height: 10),
            Text('Change: ${formatCurrency.format(change)}'),
            const Spacer(),
            ElevatedButton(
              onPressed: completePayment,
              child: const Text('Confirm Payment'),
            ),
          ],
        ),
      ),
    );
  }
}

```

- `qris_screen.dart`
```dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class QRISScreen extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final double totalCost;
  final String qrisUrl;
  final String orderId;
  final String token;
  final ValueChanged<void> onPaymentComplete;
  final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

  QRISScreen({
    Key? key,
    required this.items,
    required this.totalCost,
    required this.qrisUrl,
    required this.orderId,
    required this.token,
    required this.onPaymentComplete,
  }) : super(key: key);

  Future<void> checkPaymentStatus(BuildContext context) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/api/transaction/qris-status/$orderId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['transactionStatus'] == 'completed') {
        onPaymentComplete(null);
        Navigator.pushReplacementNamed(context, '/success');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Print QR URL for simulation
    print("QR URL for simulation: $qrisUrl");

    return Scaffold(
      appBar: AppBar(
        title: const Text('QRIS Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...items.map((item) => ListTile(
                  title: Text(item['productName']),
                  subtitle: Text('Quantity: ${item['quantity']}'),
                  trailing:
                      Text('Price: ${formatCurrency.format(item['price'])}'),
                )),
            const Divider(),
            Text(
              'Total Cost: ${formatCurrency.format(totalCost)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Scan the QR code below to complete payment:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Center(
              child: Image.network(
                qrisUrl,
                width: 200,
                height: 200,
                errorBuilder: (context, error, stackTrace) =>
                    const Text('Failed to load QR code'),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => checkPaymentStatus(context), // Pass context here
              child: const Text('Check Payment Status'),
            ),
          ],
        ),
      ),
    );
  }
}

```

- `succes_screen.dart`
```dart
// lib/pages/success_screen.dart
import 'package:flutter/material.dart';
import 'package:minggu_4/pages/main_screen.dart';

class SuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Successful'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 100),
            const SizedBox(height: 20),
            const Text(
              'Payment Completed Successfully!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Return to MainScreen directly
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MainScreen(
                          token:
                              'your_token')), // Replace 'your_token' with the actual token value.
                  (route) => false,
                );
              },
              child: const Text('Return to Main Screen'),
            ),
          ],
        ),
      ),
    );
  }
}

```



## Kesimpulan
Rangkuman hasil pembelajaran dan pencapaian pada minggu keenam ini. Intinya Aplikasi Flutter saya kali ini mengguankan tech stack Mongo DB untuk database Node JS dan Express JS untuk API nya Untuk OTP menggunakan karya anak bangsa Fonnte untuk Payment Gateway menggunakan Midtrasn untuk melakukan simulasi pembelian qris menggunakan simulator sandbox midtrans lalu untuk membaut aplikasinya tentu menggunakan FLutter. Sekian hasil pmebelajaran minggu keenam

---
## ERROR
error nya kebanyakan gabisa di dokumentasi pak gaboong

--- 

## Referensi
- https://flutter.dev/
- https://expressjs.com/
- https://fonnte.com/
- https://simulator.sandbox.midtrans.com/qris/index
- https://midtrans.com/en
- https://www.mongodb.com/
