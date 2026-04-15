# PrintQueue Mobile Application - Lab Report

## 1. Introduction

This lab report documents the design, development, and implementation of PrintQueue, a mobile application built using Flutter and Dart. PrintQueue is a student-facing printing service management application developed for university students to place print orders, track their order status in real time, and manage their printing history from their smartphones.

The app was developed as part of the Mobile Application Development lab course, focusing on real-world problem solving. Students in universities often face difficulties managing print jobs at campus printing centers, including long waits, no order tracking, and lack of communication. PrintQueue solves this by digitizing the entire process.

## 2. Objectives

The primary objectives of this project were:

*   To develop a cross-platform mobile application using the Flutter framework
*   To implement a secure user authentication system with university credentials
*   To create an order management system with automated token generation
*   To enable students to pick and configure files directly from their device storage
*   To provide real-time order tracking with estimated delivery times
*   To implement a local notification system for order status updates
*   To design a clean, modern, and intuitive user interface
*   To implement persistent local data storage using SharedPreferences

## 3. Tools & Technologies Used

| Tool / Technology | Version | Purpose |
| :--- | :--- | :--- |
| **Flutter SDK** | 3.x (Stable) | Cross-platform mobile framework |
| **Dart** | 3.x | Programming language |
| **Android Studio** | Latest | IDE for development |
| **Provider** | ^6.1.1 | State management |
| **SharedPreferences**| ^2.2.2 | Local data persistence |
| **FilePicker** | ^6.1.1 | File selection from device |
| **Intl** | ^0.19.0 | Date/time formatting |
| **Chrome / Android** | Latest | Testing platforms |

## 4. App Architecture

The PrintQueue application follows a layered architecture pattern with clear separation of concerns. The project structure is organized into the following layers:

### 4.1 Project Structure

| File / Folder | Description |
| :--- | :--- |
| `lib/main.dart` | App entry point, Provider setup, MaterialApp config |
| `lib/models/models.dart` | Data models: AppUser, PrintOrder, PrintFile, AppNotification, TokenGenerator |
| `lib/theme/app_theme.dart` | Global dark theme, colors, button and input styles |
| `lib/widgets/common.dart` | Reusable widgets: StatusBadge, FileTypeTag, ErrorBanner, helper functions |
| `lib/services/storage_service.dart`| Local data persistence using SharedPreferences (CRUD for users, orders, notifications) |
| `lib/services/app_state.dart` | ChangeNotifier state management: auth, orders, notifications, token logic |
| `lib/screens/splash_screen.dart` | Animated launch screen, auto-login check |
| `lib/screens/home_screen.dart` | Bottom navigation shell with 4 tabs and notification badge |
| `lib/screens/dashboard_screen.dart`| Home tab: active order card, stats, recent orders list |
| `lib/screens/new_order_screen.dart`| Order creation: file picker, print options sheet, price summary |
| `lib/screens/token_screen.dart` | Animated token display after order placement with copy function |
| `lib/screens/order_detail_screen.dart`| Full order details: progress bar, ETA, file list, pricing |
| `lib/screens/orders_screen.dart` | Order history with tab filtering and token search |
| `lib/screens/notifications_screen.dart`| In-app notifications list with read/unread state |
| `lib/screens/profile_screen.dart` | User profile, stats, account info, sign out |
| `lib/screens/auth/login_screen.dart` | Login form with roll number and password validation |
| `lib/screens/auth/register_screen.dart`| Registration form with name, roll, reg no, phone, password |

## 5. Features & Functionalities

### 5.1 User Authentication
The app implements a complete authentication system tailored for university students. New users register using their Full Name, Roll Number, Registration Number, Phone Number, and Password. Existing users log in using their Roll Number and Password. Passwords are hashed before storage using a simple hash function. User sessions are persisted locally so the user remains logged in after closing the app.

### 5.2 Daily Token Generation System
One of the core features of PrintQueue is the automatic token generation system. Every time a student places a new order, the system generates a short token number in the format T001, T002, T003, and so on. The counter resets to T001 every new day at midnight, ensuring that tokens remain short and easy to reference. The token is prominently displayed on screen after order placement and can be copied to the clipboard.

### 5.3 File Selection & Configuration
Students can pick multiple files from their device storage using the FilePicker package. Supported formats include PDF, DOCX, XLSX, PPTX, JPG, and PNG. For each selected file, the student can configure the following options:
*   Number of copies (1 or more)
*   Print color: Black & White (BDT 3/page) or Color (BDT 10/page)
*   Paper size: A4, A3, A5, or Letter
*   Double-sided printing toggle

### 5.4 Order Tracking & Status
Each order goes through four stages: Pending, Printing, Ready for Pickup, and Delivered. The current status is displayed using color-coded badges throughout the app. On the Order Detail screen, a visual progress bar shows all four stages with the current position highlighted. Estimated delivery time is calculated based on queue depth and displayed as both a clock time and minutes remaining.

### 5.5 In-App Notifications
The app includes an in-app notification system that automatically generates notifications at key order events: when an order is placed, when printing starts, and when the order is ready for pickup. Unread notifications are shown with a badge count on the bottom navigation bar. Tapping the Notifications tab marks all notifications as read.

### 5.6 Order History
The Orders screen provides a tabbed view of all orders: Active (pending/printing/ready), All, and Done (delivered/cancelled). Students can search orders by token number. Each order card shows the token, file count, price, time ago, and status. Tapping any order opens its full detail screen.

### 5.7 User Profile
The Profile screen displays the student's full details including their name, roll number, registration number, phone, and membership date. A statistics section shows total orders placed, delivered orders, and total amount spent. Students can sign out from this screen.

## 6. Key Flutter/Dart Concepts Applied

| Concept | How It Was Used |
| :--- | :--- |
| **StatefulWidget** | Used in screens requiring dynamic UI updates like forms, file lists, and counters |
| **StatelessWidget** | Used for reusable display components like StatusBadge, FileTypeTag, cards |
| **ChangeNotifier (Provider)** | AppState class manages global app state and notifies listeners on change |
| **context.watch / context.read**| watch rebuilds UI on state change; read performs one-time actions without rebuilding |
| **async / await** | Used throughout for file picking, storage reads/writes, and order placement |
| **AnimationController** | Splash screen fade+scale animation, Token screen entrance animation |
| **SharedPreferences** | Persists users, orders, notifications, token counter, and session data locally |
| **JSON Serialization** | All models implement toJson() and fromJson() for storage and retrieval |
| **Navigator / Routes** | Push, pushReplacement, and pushAndRemoveUntil used for screen navigation |
| **CustomScrollView + Slivers** | Dashboard and Profile screens use SliverAppBar for collapsing header effect |
| **Bottom Sheet (Modal)** | File configuration options shown as a sliding bottom sheet panel |
| **Form Validation** | All input fields in Login and Register screens have validators with error messages |
| **IndexedStack** | Preserves state of all bottom navigation tabs without re-rendering |

## 7. Data Flow Diagram

The following describes the flow of data in the PrintQueue application:

1. User launches the app. SplashScreen checks SharedPreferences for a saved session.
2. If a session exists, the user is taken to HomeScreen. Otherwise, they are redirected to LoginScreen.
3. On registration, user data (hashed password included) is saved to SharedPreferences via StorageService.
4. On login, credentials are validated against stored data. On success, the user ID is saved as the current session.
5. AppState (ChangeNotifier) loads the current user's orders and notifications from StorageService.
6. When a new order is placed, AppState calls StorageService to get the next daily token number, creates a PrintOrder object, saves it, and generates a notification.
7. All screens observe AppState via context.watch, rebuilding automatically when orders or notifications change.
8. On logout, the session key is removed from SharedPreferences and the user is redirected to LoginScreen.

## 8. Results & Output

The PrintQueue application was successfully developed and tested on both Chrome (web) and Android (Samsung Galaxy M35). The following screens were implemented and verified:

| Screen | Status | Notes |
| :--- | :--- | :--- |
| **Splash Screen** | Working | Animated logo, auto-login redirect |
| **Register Screen**| Working | Full validation, duplicate roll check |
| **Login Screen** | Working | Roll + password authentication |
| **Dashboard Screen** | Working | Active order card, stats, pull-to-refresh |
| **New Order Screen** | Working | File picker, options sheet, price calculation |
| **Token Screen** | Working | Animated display, copy-to-clipboard |
| **Order Detail Screen**| Working | Progress bar, ETA, file breakdown |
| **Orders History Screen**| Working | Tabs, search by token, pull-to-refresh |
| **Notifications Screen**| Working | Auto-generated, read/unread state |
| **Profile Screen** | Working | Student details, stats, sign out |

## 9. Discussion

The development of PrintQueue provided valuable hands-on experience with the Flutter framework and the Dart programming language. Key learning outcomes from this project include:

*   Understanding of Flutter's widget tree and the difference between Stateful and Stateless widgets
*   Practical implementation of the Provider package for state management across multiple screens
*   Experience with asynchronous programming in Dart using async/await and Future
*   Understanding of local data persistence without a backend server using SharedPreferences
*   Implementation of JSON serialization and deserialization for complex data models
*   Designing a responsive and visually appealing dark-themed UI using ThemeData
*   Practical use of animations with AnimationController and Tween classes
*   File system interaction using the file_picker package on Android

One challenge encountered during development was the CardTheme vs CardThemeData API change in newer Flutter versions, which was resolved by updating the widget class name. Another challenge was ensuring the token counter resets correctly each day, which was solved by storing and comparing the current date string in SharedPreferences.

## 10. Conclusion

The PrintQueue application was successfully designed and developed as a complete student-facing mobile application for managing printing service orders. The app demonstrates the practical application of Flutter framework concepts including state management, local persistence, file picking, navigation, animations, and form validation.

The project meets all stated objectives: students can register with their university credentials, place print orders by selecting files from their device, receive a daily-resetting token number, track their order status with estimated delivery time, and receive in-app notifications. The app runs on both Android devices and web browsers without any platform-specific code changes, demonstrating Flutter's cross-platform capability.

Future improvements could include integration with a real backend server (Firebase or REST API), push notifications, QR code-based token scanning, online payment integration, and a separate admin panel for the print shop operator.

## References

1. Flutter Official Documentation. https://flutter.dev/docs
2. Dart Programming Language. https://dart.dev
3. Provider Package. https://pub.dev/packages/provider
4. SharedPreferences Package. https://pub.dev/packages/shared_preferences
5. FilePicker Package. https://pub.dev/packages/file_picker
6. Material Design 3 Guidelines. https://m3.material.io

--- End of Lab Report ---
Page | Department of Computer Science & Engineering
