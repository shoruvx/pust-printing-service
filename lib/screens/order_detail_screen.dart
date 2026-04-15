import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../services/app_state.dart';
import '../../widgets/common.dart';
import 'package:intl/intl.dart';

class OrderDetailScreen extends StatelessWidget {
  final PrintOrder order;
  const OrderDetailScreen({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final latestOrder = context.watch<AppState>().orders.firstWhere((o) => o.id == order.id, orElse: () => order);
    int progressIndex = latestOrder.status.index;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Order ${latestOrder.token}'),
        backgroundColor: Colors.transparent,
      ),
      body: AmbientBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Status Card
              GlassCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        StatusBadge(status: latestOrder.status),
                      ],
                    ),
                    const SizedBox(height: 24),
                    OrderProgressBar(activeIndex: progressIndex),
                    const SizedBox(height: 24),
                    OrderETADisplay(order: latestOrder),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Files List
              const Text('Files to Print', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ...latestOrder.files.map((file) => GlassCard(
                padding: EdgeInsets.zero,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: FileTypeTag(fileName: file.fileName),
                  title: Text(file.fileName, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text('${file.copies} Copies • ${file.paperSize.name.toUpperCase()} • ${file.printColor == PrintColor.color ? 'Color' : 'B&W'} • ${file.isDoubleSided ? 'Double-sided' : 'Single-sided'}'),
                  trailing: Text('BDT ${file.cost.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              )).toList(),

              const SizedBox(height: 24),

              // Summary Card
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Order Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total Files'), Text('${latestOrder.files.length}')]),
                    const Divider(),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Placed On'), Text(DateFormat('MMM dd, yyyy - hh:mm a').format(latestOrder.createdAt))]),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Price', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          'BDT ${latestOrder.totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Cancel button — only while pending
              if (latestOrder.status == OrderStatus.pending)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.cancel_outlined, color: Colors.redAccent),
                    label: const Text('Cancel Order', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.redAccent),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Cancel Order?'),
                          content: Text('Are you sure you want to cancel order ${latestOrder.token}? This cannot be undone.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Keep')),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Cancel Order', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true && context.mounted) {
                        await context.read<AppState>().cancelOrder(latestOrder.id);
                        if (context.mounted) Navigator.pop(context);
                      }
                    },
                  ),
                ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
