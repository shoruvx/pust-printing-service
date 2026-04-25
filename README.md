# 📄 PUST Printing Service — User Manual

<p align="center">
  <img src="assets/pust_logo.png" width="120" alt="PUST Logo"/>
</p>

<p align="center">
  <strong>Pabna University of Science & Technology</strong><br/>
  Smart Printing Service Application
</p>

<p align="center">
  <a href="https://github.com/shoruvx/pust-printing-service/releases/latest">
    <img src="https://img.shields.io/github/v/release/shoruvx/pust-printing-service?label=Latest%20Release&style=for-the-badge&color=800000&logo=android" alt="Latest Release"/>
  </a>
  &nbsp;
  <img src="https://img.shields.io/badge/Platform-Flutter-02569B?style=for-the-badge&logo=flutter" alt="Flutter"/>
  &nbsp;
  <img src="https://img.shields.io/badge/Backend-Firebase-FFCA28?style=for-the-badge&logo=firebase" alt="Firebase"/>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Support-Android-3DDC84?style=flat-square&logo=android" alt="Android"/>
  <img src="https://img.shields.io/badge/Support-iOS-000000?style=flat-square&logo=apple" alt="iOS"/>
  <img src="https://img.shields.io/badge/Support-macOS-000000?style=flat-square&logo=apple" alt="macOS"/>
  <img src="https://img.shields.io/badge/Support-Windows-0078D4?style=flat-square&logo=windows" alt="Windows"/>
</p>

---

## 📥 Download & Install

### 📱 Android
**[→ Download PUST-Printing-Service-v1.0.apk](https://github.com/shoruvx/pust-printing-service/releases/download/v1.0.0/PUST-Printing-Service-v1.0.apk)**
1. Enable **Install from Unknown Sources** in your device settings.
2. Download and open the `.apk` file.
3. Follow the on-screen instructions to install.

### 🍎 iOS
> **Note:** iOS apps require Apple's App Store or a developer certificate for installation.
- To run on your iPhone: Clone the repo and build using **Xcode** on a Mac.
- [See Building from Source](#-building-from-source)

### 💻 macOS
**[→ Download PUST-Printing-Service-macOS.zip](https://github.com/shoruvx/pust-printing-service/releases/latest)**
1. Download the `.zip` file and extract it.
2. Drag **PUST Printing Service** to your **Applications** folder.
3. Right-click and select **Open** (the first time) to bypass the "unidentified developer" warning.

### 🪟 Windows
**[→ Download PUST-Printing-Service-Windows.zip](https://github.com/shoruvx/pust-printing-service/releases/latest)**
1. Download and extract the `.zip` file.
2. Run `pust_printing_service.exe`.
3. If Windows SmartScreen appears, click **More info** -> **Run anyway**.

---

## 🚀 Getting Started

### 1. Login / Sign Up

- Open the app — you'll land on the **Login** screen.
- Enter your **university email** or **Student ID** and **password** to sign in.
- New user? Tap **"Sign Up"** and fill in your details.
- You'll be taken directly to the Dashboard after login.

---

## 🏠 Dashboard

Your home screen with a real-time snapshot of your printing activity.

| Section | Description |
|---|---|
| **Greeting** | Personalised welcome with today's date |
| **Latest Order Card** | Most recent order: token, status, and progress bar |
| **Quick Stats** | Total orders, delivered count, and total amount spent |
| **Active Orders** | Live list of all in-progress orders |

> 💡 The Latest Order card stays pinned until you place a new one — even if the last order was already delivered.

---

## 🖨️ Placing a New Order

1. Tap the **"+" (New Order)** button in the navigation bar.
2. **Upload your file** — select a PDF/document from your device.
3. Configure your print settings:
   - **Copies** — number of copies
   - **Color Mode** — Black & White or Color
   - **Paper Size** — A4, A3, Letter, etc.
   - **Double-Sided** — toggle on/off
4. Add **Special Instructions** (optional).
5. Review the **Order Summary** and tap **"Place Order"**.

### 🎟️ Order Token
After placing an order you receive a **unique daily token** (e.g., `A-01`). Show this token at the printing counter to collect your printout.

---

## 📋 Order Lifecycle

```
Pending ──► Printing ──► Ready for Pickup ──► Delivered
```

| Status | Meaning |
|---|---|
| 🟡 **Pending** | Order received, waiting to be processed |
| 🔵 **Printing** | Your document is currently being printed |
| 🟢 **Ready for Pickup** | Printout ready — collect at the counter |
| ✅ **Delivered** | Order collected successfully |
| ❌ **Cancelled** | Order was cancelled |

---

## 🛠️ Building from Source

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (latest stable)
- **Android:** Android Studio + Android SDK
- **iOS/macOS:** Mac with Xcode + CocoaPods
- **Windows:** Visual Studio 2022 with "Desktop development with C++" workload

### Build Commands

#### Android
```bash
flutter build apk --release
```

#### iOS
```bash
flutter build ios --release
```

#### macOS
```bash
flutter build macos --release
```

#### Windows
```bash
flutter build windows --release
```

---

## ⚙️ Technical Stack

| Layer | Technology |
|---|---|
| **Framework** | Flutter (Dart) |
| **Platforms** | Android, iOS, macOS, Windows, Web |
| **Backend** | Firebase (Auth & Firestore) |
| **State Management** | Provider |
| **UI Design** | Glassmorphism / Material 3 |

---

## 👨‍💻 Project Info

| | |
|---|---|
| **University** | Pabna University of Science & Technology |
| **Version** | 1.1.0 |
| **License** | MIT |
| **GitHub** | [shoruvx/pust-printing-service](https://github.com/shoruvx/pust-printing-service) |

---

<p align="center">Made with ❤️ for PUST students</p>