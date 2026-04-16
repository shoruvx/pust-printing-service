import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../models/models.dart';
import '../../widgets/common.dart';
import 'order_detail_screen.dart';

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
        title: const Text('My Orders', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false, // Don't allow back since we use bottom nav
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: TextField(
                controller: _searchCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search by token...',
                  hintStyle: const TextStyle(color: Colors.white),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  suffixIcon: _searchQuery.isNotEmpty 
                    ? IconButton(icon: const Icon(Icons.clear, color: Colors.white), onPressed: () {
                        _searchCtrl.clear();
                        setState(() => _searchQuery = '');
                      })
                    : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                onChanged: (val) => setState(() => _searchQuery = val),
              ),
            ),
          ),
          TabBar(
            controller: _tabController,
            indicatorColor: Theme.of(context).primaryColor,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.white,
            dividerColor: Colors.white10,
            tabs: [
              Tab(text: 'Active (${active.length})'),
              Tab(text: 'All (${searched.length})'),
              Tab(text: 'Done (${done.length})'),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildList(active),
                _buildList(searched),
                _buildList(done),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<PrintOrder> items) {
    if (items.isEmpty) return const Center(child: Text('No orders found.', style: TextStyle(color: Colors.white)));
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final order = items[i];
        if (i == items.length - 1) {
           return Padding(
             padding: const EdgeInsets.only(bottom: 100), // padding for floaty nav
             child: OrderListTile(order: order, onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailScreen(order: order)));
             }),
           );
        }
        return OrderListTile(
          order: order,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailScreen(order: order)));
          },
        );
      },
    );
  }
}
