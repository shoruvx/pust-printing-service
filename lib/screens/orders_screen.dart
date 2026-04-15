import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../models/models.dart';
import '../../widgets/common.dart';
import 'order_detail_screen.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<AppState>().orders;
    
    // Filter by search
    final searched = orders.where((o) => o.token.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    
    final active = searched.where((o) => o.status != OrderStatus.delivered && o.status != OrderStatus.cancelled).toList();
    final done = searched.where((o) => o.status == OrderStatus.delivered || o.status == OrderStatus.cancelled).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Colors.transparent,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'All'),
            Tab(text: 'Done'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search by token...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty 
                  ? IconButton(icon: const Icon(Icons.clear), onPressed: () {
                      _searchCtrl.clear();
                      setState(() => _searchQuery = '');
                    })
                  : null,
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                RefreshIndicator(onRefresh: () async {}, child: _buildList(active)),
                RefreshIndicator(onRefresh: () async {}, child: _buildList(searched)),
                RefreshIndicator(onRefresh: () async {}, child: _buildList(done)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<PrintOrder> items) {
    if (items.isEmpty) return const Center(child: Text('No orders found.'));
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final order = items[i];
        return GlassCard(
          padding: EdgeInsets.zero,
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(order.token, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                StatusBadge(status: order.status),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text('${order.files.length} Files • BDT ${order.totalPrice.toStringAsFixed(2)}'),
                const SizedBox(height: 4),
                Text(DateFormat('MMM dd, yyyy - hh:mm a').format(order.createdAt), style: const TextStyle(fontSize: 12)),
              ],
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailScreen(order: order)));
            },
          ),
        );
      },
    );
  }
}
