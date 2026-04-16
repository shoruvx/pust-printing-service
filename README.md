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
    <img src="https://img.shields.io/badge/Download-APK-brightgreen?style=for-the-badge&logo=android" alt="Download APK"/>
  </a>
</p>

---

## 📱 Download & Install

### Android (Samsung & all Android devices)

1. Go to the **[Releases](../../releases/latest)** page of this repository.
2. Download the latest **`app-release.apk`** file.
3. On your Android device, go to **Settings → Security → Install Unknown Apps** and allow installation from your browser/file manager.
4. Open the downloaded APK file and tap **Install**.
5. Launch **PrintQueue** from your app drawer.

> ⚠️ You may need to enable "Install from unknown sources" in your Android settings the first time.

### iOS

> iOS builds require a Mac with Xcode. See [Building for iOS](#-building-from-source) below.

---

## 🚀 Getting Started

### 1. Login / Sign Up

- Open the app. You'll land on the **Login screen**.
- Enter your **university email** and **password** to sign in.
- If you're a new user, tap **"Sign Up"** and fill in your details (Name, Student ID, Email, Password).
- Your account will be created and you'll be taken directly to the Dashboard.

---

## 🏠 Dashboard

The Dashboard is your home screen showing a real-time snapshot of your printing activity.

| Section | Description |
|---|---|
| **Greeting** | Personalized welcome with today's date |
| **Latest Order Card** | Shows your most recent order with its token, status, and progress bar |
| **Quick Stats** | Total orders placed, delivered count, and total amount spent |
| **Active Orders** | Live list of orders currently in progress |

> 💡 The Latest Order card stays pinned on your dashboard until you place a new order — even if your last order was already delivered.

---

## 🖨️ Placing a New Order

1. Tap the **"+" (New Order)** button in the bottom navigation bar.
2. **Upload your file** — tap the dropzone or drag & drop to select a PDF or document from your device.
3. Configure your print settings:
   - **Copies** — number of copies needed
   - **Color Mode** — Black & White or Color
   - **Paper Size** — A4, A3, Letter, etc.
   - **Double-Sided** — toggle on/off
4. Add any **Special Instructions** (optional) — e.g., "Staple pages", "Print landscape".
5. Review the **Order Summary** at the bottom (total price & page count).
6. Tap **"Place Order"** to confirm.

### Order Token
After placing an order, you'll receive a **unique daily token** (e.g., `A-01`, `A-02`). Show this token at the printing counter to collect your printout.

---

## 📋 Order Lifecycle

```
Pending → Printing → Ready for Pickup → Delivered
```

| Status | Meaning |
|---|---|
| 🟡 **Pending** | Order received, waiting to be processed |
| 🔵 **Printing** | Your document is being printed |
| 🟢 **Ready for Pickup** | Printout is ready — collect at the counter |
| ✅ **Delivered** | Order collected successfully |
| ❌ **Cancelled** | Order was cancelled before printing started |

> ⚠️ Orders stuck in Pending/Printing for more than **30 seconds** without updates are automatically cancelled.

---

## ❌ Cancelling an Order

- You can cancel an order **only while it is in Pending status** (before printing begins).
- Go to the **Orders** screen, find your order, and tap **Cancel**.
- Cancelled orders are permanently removed from your history and the token slot is freed.

---

## 📦 Orders Screen

- Tap **"Orders"** in the bottom navigation bar.
- Use the **search bar** to filter orders by token (e.g., search "A-01").
- Switch between tabs:
  - **Active** — orders currently being processed
  - **All** — complete history of all orders
  - **Done** — delivered orders only

---

## 🔔 Notifications

- Tap the **bell icon** on the Dashboard to view all notifications.
- You'll receive notifications when:
  - Your **order is placed** successfully
  - Your **order is delivered**
- Tap **"Mark all as read"** to clear the notification badge.
- Tap **"Clear All"** to remove all notifications.

---

## 👤 Profile

The Profile screen shows your account information and statistics.

| Section | Description |
|---|---|
| **Avatar** | Tap the avatar to upload a profile picture from your gallery |
| **Name & Email** | Your registered university details |
| **Student ID** | Your university ID number |
| **Stats** | Total orders & total amount spent |
| **Account Details** | Email, Student ID, Department |
| **Logout** | Sign out of your account |

---

## ⚙️ Technical Notes

- **Data Storage**: Orders are stored locally on your device using SharedPreferences.
- **Authentication**: Powered by Firebase Authentication.
- **Offline**: The app can display your existing orders offline; placing new orders requires an internet connection.
- **Stuck Order Timeout**: Any order stuck in a non-final state for >30 seconds is automatically removed.

---

## 🛠️ Building from Source

### Prerequisites
- Flutter SDK (≥2.17.0)
- Android Studio / Xcode
- Firebase project configured

### Android APK
```bash
git clone https://github.com/shoruvx/pust-printing-service.git
cd pust-printing-service
flutter pub get
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### iOS IPA
```bash
flutter build ios --release
# Then archive & export in Xcode
```

---

## 👨‍💻 Developer Info

| | |
|---|---|
| **Project** | PUST Printing Service |
| **Platform** | Flutter (Android + iOS) |
| **Backend** | Firebase (Auth + Firestore) |
| **University** | Pabna University of Science & Technology |

---

<p align="center">Made with ❤️ for PUST students</p>