import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),

              // Profile picture with edit button
              GestureDetector(
                onTap: () => _pickImage(context),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor.withOpacity(0.15),
                        border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.6), width: 2.5),
                        image: picPath != null
                            ? DecorationImage(image: FileImage(File(picPath)), fit: BoxFit.cover)
                            : null,
                      ),
                      child: picPath == null
                          ? Icon(Icons.person, size: 60, color: Theme.of(context).primaryColor)
                          : null,
                    ),
                    // Camera badge
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF800000),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF1a1a2e), width: 2),
                      ),
                      child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              Text(user.fullName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(user.rollNumber, style: const TextStyle(color: Colors.white54, fontSize: 14)),
              const SizedBox(height: 32),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Account Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              GlassCard(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(onTap: () {}, leading: const Icon(Icons.numbers), title: const Text('Roll Number'), subtitle: Text(user.rollNumber)),
                    const Divider(height: 1),
                    ListTile(onTap: () {}, leading: const Icon(Icons.confirmation_number), title: const Text('Registration'), subtitle: Text(user.registrationNumber)),
                    const Divider(height: 1),
                    ListTile(onTap: () {}, leading: const Icon(Icons.phone), title: const Text('Phone Number'), subtitle: Text(user.phone)),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Printing Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              GlassCard(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(onTap: () {}, leading: const Icon(Icons.print), title: const Text('Total Orders Placed'), trailing: Text('${state.orders.length}', style: const TextStyle(fontSize: 18))),
                    const Divider(height: 1),
                    ListTile(onTap: () {}, leading: const Icon(Icons.check_circle_outline), title: const Text('Delivered Orders'), trailing: Text('$totalDelivered', style: const TextStyle(fontSize: 18))),
                    const Divider(height: 1),
                    ListTile(onTap: () {}, leading: const Icon(Icons.attach_money), title: const Text('Total Amount Spent'), trailing: Text('BDT ${totalSpent.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor))),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
