import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../models/models.dart';
import '../../widgets/common.dart';
import 'order_detail_screen.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.currentUser;
    final List<PrintOrder> activeOrders = state.orders.where(
      (o) => o.status != OrderStatus.delivered && o.status != OrderStatus.cancelled
    ).toList();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, ${user?.fullName.split(' ').first ?? 'Student'}'),
        centerTitle: false, // More modern left-aligned greeting
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Active Orders', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              if (activeOrders.isEmpty)
                const Center(child: Padding(padding: EdgeInsets.all(32.0), child: Text("No active orders.")))
              else
                ...activeOrders.map((order) => _buildOrderCard(context, order)).toList(),
              
              const SizedBox(height: 32),
              
              const Text('Quick Stats', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildStatCard(context, "Total Orders", "${state.orders.length}", Icons.print)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard(context, "Pending", "${activeOrders.length}", Icons.hourglass_top)),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, PrintOrder order) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailScreen(order: order)));
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.receipt_long, color: Theme.of(context).primaryColor, size: 24),
                      const SizedBox(width: 12),
                      Text(order.token, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    ],
                  ),
                  StatusBadge(status: order.status),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Divider(),
              ),
              OrderProgressBar(activeIndex: order.status.index),
              if (order.status != OrderStatus.delivered && order.status != OrderStatus.cancelled) ...[
                const SizedBox(height: 16),
                OrderETADisplay(order: order),
              ],
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Divider(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${order.files.length} Files', style: const TextStyle(fontSize: 16, color: Color(0xFF94A3B8))),
                  Text('BDT ${order.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 14, color: Color(0xFF94A3B8)),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('MMM dd, yyyy - hh:mm a').format(order.createdAt),
                    style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                  ),
                 ],
               ),
              // Quick cancel while pending only
              if (order.status == OrderStatus.pending) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.cancel_outlined, color: Colors.redAccent, size: 18),
                    label: const Text('Cancel Order', style: TextStyle(color: Colors.redAccent, fontSize: 13)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.redAccent, width: 1),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Cancel Order?'),
                          content: Text('Cancel order ${order.token}? This cannot be undone.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Keep')),
                            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Cancel', style: TextStyle(color: Colors.red))),
                          ],
                        ),
                      );
                      if (confirm == true && context.mounted) {
                        context.read<AppState>().cancelOrder(order.id);
                      }
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon) {
    return GlassCard(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 28, color: Theme.of(context).primaryColor),
                ),
                const SizedBox(height: 16),
                Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 4),
                Text(title, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
