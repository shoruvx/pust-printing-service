import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../widgets/common.dart';
import 'package:intl/intl.dart';
import 'order_detail_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  void _showDeliverySnackBar(BuildContext context, String token) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 80),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        backgroundColor: const Color(0xFF228B22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        duration: const Duration(seconds: 5),
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Order Delivered! 🎉',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                  Text('Order $token is ready for pickup.',
                      style: const TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final notifications = state.notifications;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.transparent,
        actions: [
          if (notifications.isNotEmpty)
            TextButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Clear All'),
                    content: const Text('Remove all notifications?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Clear', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
                if (confirm == true && context.mounted) {
                  context.read<AppState>().clearAllNotifications();
                }
              },
              icon: const Icon(Icons.delete_sweep_rounded, size: 18, color: Colors.white70),
              label: const Text('Clear All', style: TextStyle(color: Colors.white70, fontSize: 13)),
            ),
        ],
      ),
      body: notifications.isEmpty
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.notifications_off_rounded, size: 64, color: Colors.white24),
                SizedBox(height: 16),
                Text('No notifications yet.', style: TextStyle(color: Colors.white54, fontSize: 16)),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            itemCount: notifications.length,
            itemBuilder: (context, i) {
              final notif = notifications[i];
              final isDelivery = notif.title.toLowerCase().contains('delivered');
              return GlassCard(
                padding: EdgeInsets.zero,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: notif.isRead ? Colors.transparent : Theme.of(context).primaryColor.withOpacity(0.08),
                  ),
                  child: ListTile(
                    onTap: () async {
                      // Show delivery snackbar only on first read of a delivery notification
                      if (!notif.isRead && isDelivery && notif.orderToken != null) {
                        _showDeliverySnackBar(context, notif.orderToken!);
                      }
                      // Mark this notification as read
                      await context.read<AppState>().markNotificationsRead();
                      // Navigate to order detail if applicable
                      if (notif.orderToken != null && context.mounted) {
                        try {
                          final order = state.orders.firstWhere((o) => o.token == notif.orderToken);
                          Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailScreen(order: order)));
                        } catch (e) {
                          // order not found, skip navigation
                        }
                      }
                    },
                    leading: CircleAvatar(
                      backgroundColor: isDelivery
                          ? const Color(0xFF228B22).withOpacity(0.2)
                          : Theme.of(context).primaryColor.withOpacity(0.2),
                      child: Icon(
                        isDelivery ? Icons.check_circle_rounded : Icons.notifications_rounded,
                        color: isDelivery ? const Color(0xFF228B22) : Theme.of(context).primaryColor,
                      ),
                    ),
                    title: Text(notif.title,
                        style: TextStyle(
                          fontWeight: notif.isRead ? FontWeight.normal : FontWeight.bold,
                          color: Colors.white,
                        )),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(notif.message, style: const TextStyle(color: Colors.white70)),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('MMM dd, hh:mm a').format(notif.createdAt),
                          style: const TextStyle(color: Colors.white38, fontSize: 11),
                        ),
                      ],
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    trailing: notif.isRead
                        ? null
                        : Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                  ),
                ),
              );
            },
          ),
    );
  }
}
