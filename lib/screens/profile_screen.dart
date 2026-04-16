import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../models/models.dart';
import '../../services/app_state.dart';
import '../../widgets/common.dart';
import 'auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded, color: Colors.white),
              title: const Text('Take a Photo', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded, color: Colors.white),
              title: const Text('Choose from Gallery', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (source == null) return;
    final picked = await picker.pickImage(source: source, imageQuality: 80, maxWidth: 512);
    if (picked != null && context.mounted) {
      await context.read<AppState>().updateProfilePicture(picked.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.currentUser;

    if (user == null) return const SizedBox();

    int totalDelivered = state.orders.where((o) => o.status == OrderStatus.delivered).length;
    double totalSpent = state.orders.fold(0.0, (sum, o) => sum + o.totalPrice);
    final picPath = state.profilePicturePath;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () async {
              await context.read<AppState>().logout();
              if (!context.mounted) return;
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Profile Info
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _pickImage(context),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor.withOpacity(0.15),
                            image: picPath != null ? DecorationImage(image: FileImage(File(picPath)), fit: BoxFit.cover) : null,
                          ),
                          child: picPath == null
                              ? Center(child: Text(user.fullName[0].toUpperCase(), style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)))
                              : null,
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(color: const Color(0xFF800000), shape: BoxShape.circle, border: Border.all(color: const Color(0xFF0F172A), width: 2)),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.fullName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 4),
                        Text('Roll: ${user.rollNumber}', style: TextStyle(fontSize: 14, color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text(user.phone, style: const TextStyle(fontSize: 13, color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Stats Row
              Row(
                children: [
                  Expanded(child: StatCard(title: 'Orders', value: '${state.orders.length}', icon: Icons.receipt_long)),
                  const SizedBox(width: 12),
                  Expanded(child: StatCard(title: 'Delivered', value: '$totalDelivered', icon: Icons.check_circle_outline)),
                  const SizedBox(width: 12),
                  Expanded(child: StatCard(title: 'Spent', value: '৳${totalSpent.toStringAsFixed(0)}', icon: Icons.payments_outlined, valueColor: Colors.orangeAccent)),
                ],
              ),
              const SizedBox(height: 32),

              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 12),
                child: Text('ACCOUNT DETAILS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.white)),
              ),

              // Unified Account Card
              GlassCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildInfoTile(Icons.person_outline, 'Full Name', user.fullName),
                    _divider(),
                    _buildInfoTile(Icons.badge_outlined, 'Roll Number', user.rollNumber),
                    _divider(),
                    _buildInfoTile(Icons.numbers, 'Registration No.', user.registrationNumber),
                    _divider(),
                    _buildInfoTile(Icons.phone_outlined, 'Phone', user.phone),
                    _divider(),
                    _buildInfoTile(Icons.calendar_today_outlined, 'Member Since', DateFormat('dd MMM yyyy').format(user.memberSince)),
                  ],
                ),
              ),

              const SizedBox(height: 100), // floaty nav padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 13)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _divider() => Container(height: 1, color: Colors.white.withOpacity(0.05), margin: const EdgeInsets.only(left: 52, right: 16));
}
