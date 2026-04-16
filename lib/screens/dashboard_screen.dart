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
    final List<PrintOrder> recentOrders = state.orders.take(5).toList();

    int totalDelivered = state.orders.where((o) => o.status == OrderStatus.delivered).length;
    double totalSpent = state.orders.fold(0.0, (sum, o) => sum + o.totalPrice);
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, ${user?.fullName.split(' ').first ?? 'Student'} 👋',
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'PUST Printing Service',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 14, color: Colors.white),
                        const SizedBox(width: 6),
                        Text(
                          DateFormat('dd MMM yyyy').format(DateTime.now()),
                          style: const TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Active Orders Pill
              if (activeOrders.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8, height: 8,
                        decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${activeOrders.length} active orders in progress',
                        style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              if (activeOrders.isNotEmpty) const SizedBox(height: 16),

              // Hero Latest Order Card
              if (state.orders.isNotEmpty)
                _buildHeroOrderCard(context, state.orders.first),

              const SizedBox(height: 24),

              // Quick Stats Row
              Row(
                children: [
                  Expanded(child: StatCard(title: 'Total', value: '${state.orders.length}', icon: Icons.receipt_long)),
                  const SizedBox(width: 12),
                  Expanded(child: StatCard(title: 'Delivered', value: '$totalDelivered', icon: Icons.check_circle_outline)),
                  const SizedBox(width: 12),
                  Expanded(child: StatCard(title: 'Spent', value: '৳${totalSpent.toStringAsFixed(0)}', icon: Icons.payments_outlined, valueColor: Colors.orangeAccent)),
                ],
              ),

              const SizedBox(height: 32),

              // Recent Orders Section
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 12),
                child: Text(
                  'RECENT ORDERS',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.white),
                ),
              ),
              if (recentOrders.isEmpty)
                const Center(child: Padding(padding: EdgeInsets.all(32.0), child: Text("No orders yet.")))
              else
                ...recentOrders.map((o) => OrderListTile(
                  order: o,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailScreen(order: o))),
                )).toList(),
                
              const SizedBox(height: 100), // padding for floaty nav bar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroOrderCard(BuildContext context, PrintOrder order) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailScreen(order: order))),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Latest Order', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Text(
                        order.token,
                        style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2),
                      ),
                    ],
                  ),
                  StatusBadge(status: order.status),
                ],
              ),
              const SizedBox(height: 24),
              OrderProgressBar(activeIndex: order.status.index),
              const SizedBox(height: 24),
              // Bottom status bar inside card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _heroStatItem(Icons.folder_shared_outlined, '${order.files.length} files'),
                    _heroStatItem(Icons.content_copy, '${order.files.fold<int>(0, (sum, f) => sum + f.copies)} copies'),
                    _heroStatItem(Icons.access_time, _getShortEtaText(order.status)),
                  ],
                ),
              ),
              // Optional quick cancel right in the hero card if it's pending
              if (order.status == OrderStatus.pending) ...[
                const SizedBox(height: 16),
                Center(
                  child: TextButton.icon(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Cancel Order?'),
                          content: Text('Cancel order ${order.token}?'),
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
                    icon: const Icon(Icons.cancel_outlined, color: Colors.white, size: 16),
                    label: const Text('Cancel Request', style: TextStyle(color: Colors.white, fontSize: 13)),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _heroStatItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w500)),
      ],
    );
  }
  
  String _getShortEtaText(OrderStatus status) {
    if (status == OrderStatus.pending) return 'Waiting...';
    if (status == OrderStatus.printing) return 'Ready soon';
    if (status == OrderStatus.readyForPickup) return 'Ready now';
    return 'Done';
  }
}
