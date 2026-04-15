import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../widgets/common.dart';
import 'dashboard_screen.dart';
import 'new_order_screen.dart';
import 'orders_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  final Set<String> _alreadyNotified = {};
  late AppState _appState;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const OrdersScreen(),
    const NotificationsScreen(),
    const ProfileScreen(),
  ];

  final List<_NavItem?> _navItems = [
    const _NavItem(icon: Icons.dashboard_rounded, label: 'Home'),
    const _NavItem(icon: Icons.list_alt_rounded, label: 'Orders'),
    null, // center FAB placeholder
    const _NavItem(icon: Icons.notifications_rounded, label: 'Alerts'),
    const _NavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  int _screenIndex(int slot) => slot < 2 ? slot : slot - 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _appState = context.read<AppState>();
      _appState.addListener(_onStateChanged);
    });
  }

  @override
  void dispose() {
    _appState.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (!mounted || _appState.orders.isEmpty) return;
    final latest = _appState.orders.first;
    if (latest.status == OrderStatus.delivered && !_alreadyNotified.contains(latest.id)) {
      // Only pop up if the delivery notification still exists (not cleared)
      final hasNotif = _appState.notifications.any(
        (n) => n.orderToken == latest.token && n.title.toLowerCase().contains('delivered'),
      );
      if (hasNotif) {
        _alreadyNotified.add(latest.id);
        _showDeliverySnackBar(latest.token);
      }
    }
  }

  void _showDeliverySnackBar(String token) {
    if (!mounted) return;

    final animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    final slideAnim = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animController, curve: Curves.easeOutCubic));

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => Positioned(
        top: MediaQuery.of(context).padding.top + 12,
        left: 16,
        right: 16,
        child: SlideTransition(
          position: slideAnim,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF228B22),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Order Ready! 🎉',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                        Text('Order $token is ready for pickup.',
                            style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(entry);
    animController.forward();

    Future.delayed(const Duration(seconds: 5), () {
      animController.reverse().then((_) {
        entry.remove();
        animController.dispose();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final unreadPills = appState.unreadPills;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: AmbientBackground(
        child: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: _buildFloatingNavBar(context, unreadPills),
    );
  }

  Widget _buildFloatingNavBar(BuildContext context, int unreadPills) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white.withOpacity(0.16), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 32,
                  spreadRadius: -4,
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_navItems.length, (slot) {
                if (_navItems[slot] == null) {
                  return _buildCenterButton(context);
                }
                final item = _navItems[slot]!;
                final screenIdx = _screenIndex(slot);
                final isSelected = _currentIndex == screenIdx;
                final badge = slot == 3 ? unreadPills : 0;
                return _buildNavItem(context, slot, screenIdx, item, isSelected, badge);
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCenterButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const NewOrderScreen()),
      ),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF800000),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF800000).withOpacity(0.55),
              blurRadius: 18,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int slot, int screenIdx, _NavItem item, bool isSelected, int badge) {
    return GestureDetector(
      onTap: () {
        setState(() => _currentIndex = screenIdx);
        if (slot == 3 && badge > 0) {
          context.read<AppState>().markNotificationsRead();
        }
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF800000) : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  item.icon,
                  color: isSelected ? Colors.white : Colors.white54,
                  size: 22,
                ),
                if (badge > 0)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                      child: Text('$badge',
                          style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center),
                    ),
                  )
              ],
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                item.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
