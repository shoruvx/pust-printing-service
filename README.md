# 📄 PUST PrintQueue — User Manual

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
  <a href="https://github.com/shoruvx/pust-printing-service/releases/download/v1.0.0/PUST-PrintQueue-v1.0.apk">
    <img src="https://img.shields.io/badge/Download-APK%20v1.0-brightgreen?style=for-the-badge&logo=android" alt="Download APK"/>
  </a>
  &nbsp;
  <img src="https://img.shields.io/badge/Platform-Flutter-02569B?style=for-the-badge&logo=flutter" alt="Flutter"/>
  &nbsp;
  <img src="https://img.shields.io/badge/Backend-Firebase-FFCA28?style=for-the-badge&logo=firebase" alt="Firebase"/>
</p>

---

## 📥 Download & Install

### ⬇️ Direct Download (Android)

**[→ Click here to download PUST-PrintQueue-v1.0.apk](https://github.com/shoruvx/pust-printing-service/releases/download/v1.0.0/PUST-PrintQueue-v1.0.apk)**

1. Tap the link above on your Android device (or scan a QR code to the releases page).
2. Go to **Settings → Security → Install Unknown Apps** and allow your browser/file manager.
3. Open the downloaded `.apk` file and tap **Install**.
4. Launch **PrintQueue** from your app drawer.

> ⚠️ You need to enable "Install from unknown sources" the first time only.

### iOS

> iOS builds require a Mac with Xcode. See [Building from Source](#-building-from-source) below.

---

## 🚀 Getting Started

### 1. Login / Sign Up

- Open the app — you'll land on the **Login** screen.
- Enter your **university email** and **password** to sign in.
- New user? Tap **"Sign Up"** and fill in Name, Student ID, Email, and Password.
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

1. Tap the **"+" (New Order)** button in the bottom navigation bar.
2. **Upload your file** — tap the dropzone or select a PDF/document from your device.
3. Configure your print settings:
   - **Copies** — number of copies
   - **Color Mode** — Black & White or Color
   - **Paper Size** — A4, A3, Letter, etc.
   - **Double-Sided** — toggle on/off
4. Add **Special Instructions** (optional) — e.g., *"Staple pages"*, *"Print landscape"*.
5. Review the **Order Summary** at the bottom (price & page count).
6. Tap **"Place Order"** to confirm.

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
| ❌ **Cancelled** | Order was cancelled before printing began |

> ⚠️ Orders stuck in a non-final state for more than **30 seconds** are automatically cancelled and removed.

---

## ❌ Cancelling an Order

- You can cancel an order **only while it is in Pending status** (before printing begins).
- Go to the **Orders** screen, find your order, and tap **Cancel**.
- Cancelled orders are permanently removed and the token slot is freed.

---

## 📦 Orders Screen

- Tap **"Orders"** in the bottom navigation bar.
- Use the **search bar** to filter by token (e.g., `A-01`).
- Switch between tabs:
  - **Active** — currently in-progress orders
  - **All** — full history
  - **Done** — delivered orders only

---

## 🔔 Notifications

- Tap the **bell icon** to view all notifications.
- Notifications are sent when your order is **placed** and when it is **delivered**.
- Tap **"Mark all read"** to clear the badge, or **"Clear All"** to remove them.

---

## 👤 Profile

| Section | Description |
|---|---|
| **Avatar** | Tap to upload a profile photo from your gallery |
| **Name & Email** | Your registered university details |
| **Student ID** | Your university ID number |
| **Stats** | Total orders placed & total spent |
| **Logout** | Sign out of your account |

---

## 🛠️ Building from Source

### Prerequisites
- Flutter SDK ≥ 2.17.0
- Android Studio (for Android) / Xcode (for iOS)
- Firebase project with Auth + Firestore enabled

### Android APK
```bash
git clone https://github.com/shoruvx/pust-printing-service.git
cd pust-printing-service
flutter pub get
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### iOS
```bash
flutter build ios --release
# Then open ios/Runner.xcworkspace in Xcode, archive, and export
```

---

## ⚙️ Technical Stack

| Layer | Technology |
|---|---|
| **Framework** | Flutter (Dart) |
| **Authentication** | Firebase Auth |
| **Database** | Cloud Firestore |
| **Local Storage** | SharedPreferences |
| **UI** | Glassmorphism + PUST Maroon & Green |
| **Fonts** | Google Fonts — Outfit |

---

## 👨‍💻 Project Info

| | |
|---|---|
| **University** | Pabna University of Science & Technology |
| **Platform** | Android & iOS |
| **Version** | 1.0.0 |
| **License** | MIT |

---

<p align="center">Made with ❤️ for PUST students</p>