import 'dart:convert';
import 'package:intl/intl.dart';

class AppUser {
  final String id;
  final String fullName;
  final String rollNumber;
  final String registrationNumber;
  final String phone;
  final String passwordHash;
  final DateTime memberSince;

  AppUser({
    required this.id,
    required this.fullName,
    required this.rollNumber,
    required this.registrationNumber,
    required this.phone,
    required this.passwordHash,
    required this.memberSince,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'rollNumber': rollNumber,
    'registrationNumber': registrationNumber,
    'phone': phone,
    'passwordHash': passwordHash,
    'memberSince': memberSince.toIso8601String(),
  };

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
    id: json['id'],
    fullName: json['fullName'],
    rollNumber: json['rollNumber'],
    registrationNumber: json['registrationNumber'],
    phone: json['phone'],
    passwordHash: json['passwordHash'],
    memberSince: DateTime.parse(json['memberSince']),
  );
}

enum PrintColor { blackAndWhite, color }
enum PaperSize { a4, a3, a5, letter }

class PrintFile {
  final String fileName;
  final String filePath;
  final int copies;
  final PrintColor printColor;
  final PaperSize paperSize;
  final bool isDoubleSided;

  PrintFile({
    required this.fileName,
    required this.filePath,
    this.copies = 1,
    this.printColor = PrintColor.blackAndWhite,
    this.paperSize = PaperSize.a4,
    this.isDoubleSided = false,
  });

  double get cost {
    double pricePerPage = printColor == PrintColor.color ? 5.0 : 3.0;
    return pricePerPage * copies;
  }

  Map<String, dynamic> toJson() => {
    'fileName': fileName,
    'filePath': filePath,
    'copies': copies,
    'printColor': printColor.index,
    'paperSize': paperSize.index,
    'isDoubleSided': isDoubleSided,
  };

  factory PrintFile.fromJson(Map<String, dynamic> json) => PrintFile(
    fileName: json['fileName'],
    filePath: json['filePath'],
    copies: json['copies'],
    printColor: PrintColor.values[json['printColor']],
    paperSize: PaperSize.values[json['paperSize']],
    isDoubleSided: json['isDoubleSided'],
  );
}

enum OrderStatus { pending, printing, readyForPickup, delivered, cancelled }

class PrintOrder {
  final String id;
  final String userId;
  final String token;
  final List<PrintFile> files;
  final double totalPrice;
  final DateTime createdAt;
  final OrderStatus status;

  PrintOrder({
    required this.id,
    required this.userId,
    required this.token,
    required this.files,
    required this.totalPrice,
    required this.createdAt,
    this.status = OrderStatus.pending,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'token': token,
    'files': files.map((f) => f.toJson()).toList(),
    'totalPrice': totalPrice,
    'createdAt': createdAt.toIso8601String(),
    'status': status.index,
  };

  factory PrintOrder.fromJson(Map<String, dynamic> json) => PrintOrder(
    id: json['id'],
    userId: json['userId'],
    token: json['token'],
    files: (json['files'] as List).map((f) => PrintFile.fromJson(f)).toList(),
    totalPrice: json['totalPrice'],
    createdAt: DateTime.parse(json['createdAt']),
    status: OrderStatus.values[json['status']],
  );
}

class AppNotification {
  final String id;
  final String userId;
  final String title;
  final String message;
  final DateTime createdAt;
  bool isRead;
  final String? orderToken;

  AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.createdAt,
    this.isRead = false,
    this.orderToken,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'title': title,
    'message': message,
    'createdAt': createdAt.toIso8601String(),
    'isRead': isRead,
    'orderToken': orderToken,
  };

  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
    id: json['id'],
    userId: json['userId'],
    title: json['title'],
    message: json['message'],
    createdAt: DateTime.parse(json['createdAt']),
    isRead: json['isRead'],
    orderToken: json['orderToken'],
  );
}

class TokenGenerator {
  static String generate(int currentCount) {
    return 'T${currentCount.toString().padLeft(3, '0')}';
  }
}
