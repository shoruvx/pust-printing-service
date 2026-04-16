import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/models.dart';

class StatusBadge extends StatelessWidget {
  final OrderStatus status;

  const StatusBadge({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;
    switch (status) {
      case OrderStatus.pending:
        color = Colors.orange;
        text = 'Pending';
        break;
      case OrderStatus.printing:
        color = Colors.blue;
        text = 'Printing';
        break;
      case OrderStatus.readyForPickup:
        color = Colors.green;
        text = 'Ready for Pickup';
        break;
      case OrderStatus.delivered:
        color = Colors.grey;
        text = 'Delivered';
        break;
      case OrderStatus.cancelled:
        color = Colors.red;
        text = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}

class FileTypeTag extends StatelessWidget {
  final String fileName;
  
  const FileTypeTag({Key? key, required this.fileName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ext = fileName.split('.').last.toUpperCase();
    Color color = Colors.grey;
    if (ext == 'PDF') color = Colors.redAccent;
    if (ext == 'DOCX' || ext == 'DOC') color = Colors.blueAccent;
    if (ext == 'XLSX' || ext == 'XLS') color = Colors.greenAccent;
    if (ext == 'JPG' || ext == 'PNG') color = Colors.orangeAccent;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        ext,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10),
      ),
    );
  }
}

class ErrorBanner extends StatelessWidget {
  final String message;
  const ErrorBanner({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.redAccent),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent),
          const SizedBox(width: 12),
          Expanded(child: Text(message, style: const TextStyle(color: Colors.redAccent))),
        ],
      ),
    );
  }
}

class OrderProgressBar extends StatelessWidget {
  final int activeIndex;
  
  const OrderProgressBar({Key? key, required this.activeIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> stages = ['Pending', 'Printing', 'Ready', 'Delivered'];
    List<Widget> dots = [];
    
    for (int i = 0; i < 4; i++) {
      bool isDone = i <= activeIndex;
      dots.add(Column(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: isDone ? const Color(0xFF800000) : Colors.grey.shade800,
            child: isDone ? const Icon(Icons.check, size: 16, color: Colors.white) : const SizedBox(),
          ),
          const SizedBox(height: 8),
          Text(stages[i], style: TextStyle(fontSize: 10, color: isDone ? Colors.white : Colors.grey)),
        ],
      ));
      
      if (i < 3) {
        dots.add(Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 24),
            height: 2,
            color: isDone ? const Color(0xFF800000) : Colors.grey.shade800,
          ),
        ));
      }
    }
    
    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: dots);
  }
}

class OrderETADisplay extends StatelessWidget {
  final PrintOrder order;
  const OrderETADisplay({Key? key, required this.order}) : super(key: key);

  String _getETA(PrintOrder currentOrder) {
    if (currentOrder.status == OrderStatus.delivered) return 'Delivered';
    if (currentOrder.status == OrderStatus.readyForPickup) return 'Ready now';
    if (currentOrder.status == OrderStatus.cancelled) return 'Cancelled';
    
    final passed = DateTime.now().difference(currentOrder.createdAt).inSeconds;
    int secsLeft = 24 - passed;
    if (secsLeft < 1) secsLeft = 1;
    
    return 'in ~$secsLeft seconds';
  }

  @override
  Widget build(BuildContext context) {
    if (order.status == OrderStatus.delivered || order.status == OrderStatus.cancelled) {
      return const SizedBox();
    }
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.timer_outlined, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(
              'Estimated Pickup: ${_getETA(order)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
            ),
          ],
        );
      }
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;

  const GlassCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = const EdgeInsets.only(bottom: 12.0),
    this.borderRadius = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 24,
            spreadRadius: -4,
          )
        ]
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
                width: 1.0,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class AmbientBackground extends StatelessWidget {
  final Widget child;
  const AmbientBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return Stack(
      children: [
        Container(color: const Color(0xFF0F172A)), // Base theme slate
        Positioned(
          top: -100,
          right: -80,
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primary.withOpacity(0.4),
            ),
          ),
        ),
        Positioned(
          bottom: -50,
          left: -80,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1E293B).withOpacity(0.6),
            ),
          ),
        ),
        Positioned(
          top: 300,
          left: -100,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF228B22).withOpacity(0.15),
            ),
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
            child: Container(color: Colors.transparent),
          ),
        ),
        child,
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const StatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16.0),
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 28),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class OrderListTile extends StatelessWidget {
  final PrintOrder order;
  final VoidCallback onTap;

  const OrderListTile({Key? key, required this.order, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.receipt_long, color: Colors.white, size: 24),
        ),
        title: Text(
          order.token,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            '${order.files.length} file(s) · ৳${order.totalPrice.toStringAsFixed(0)} · ${_formatTimeAgo(order.createdAt)}',
            style: const TextStyle(fontSize: 13, color: Colors.white),
          ),
        ),
        trailing: StatusBadge(status: order.status),
      ),
    );
  }

  String _formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}
