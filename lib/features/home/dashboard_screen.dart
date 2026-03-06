import 'package:ezeewash_admin/features/home/order_screen.dart';
import 'package:ezeewash_admin/features/home/report_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'admin_settings.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool collapsed = false;
  int selectedIndex = 0;
  final GlobalKey<OrderScreenState> orderScreenKey = GlobalKey<OrderScreenState>();

  @override
  Widget build(BuildContext context) {
    final pages = [
      _MainContent(
        onNavigate: (index) => setState(() => selectedIndex = index),
        onAddManualOrder: () {
          setState(() => selectedIndex = 1);
          // Trigger the add order dialog after navigation
          WidgetsBinding.instance.addPostFrameCallback((_) {
            orderScreenKey.currentState?.openAddOrderDialog();
          });
        },
      ),
      OrderScreen(key: orderScreenKey),
      const ReportsScreen(),
      const SettingsScreen()
    ];

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          collapsed = constraints.maxWidth < 1100;

          return Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: collapsed ? 80 : 260,
                child: _Sidebar(
                  collapsed: collapsed,
                  selectedIndex: selectedIndex,
                  onItemSelected: (i) => setState(() => selectedIndex = i),
                ),
              ),
              Expanded(child: pages[selectedIndex]),
            ],
          );
        },
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  final bool collapsed;
  final int selectedIndex;
  final Function(int) onItemSelected;

  const _Sidebar({
    this.collapsed = false,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 20),

          if (!collapsed)
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1D4BC7), Color(0xFF2F2E98)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.local_laundry_service,
                color: Colors.white,
              ),
            )
          else
            const Icon(Icons.local_laundry_service, size: 32, color: Color(0xFF1D4BC7)),

          const SizedBox(height: 30),

          _navItem(0, Icons.dashboard, "Dashboard"),
          _navItem(1, Icons.shopping_bag_outlined, "Orders"),
          _navItem(2, Icons.bar_chart_outlined, "Reports"),
          _navItem(3, Icons.settings_outlined, "Settings"),

          const Spacer(),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String title) {
    final active = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemSelected(index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient: active
              ? const LinearGradient(
            colors: [Color(0xFF1D4BC7), Color(0xFF2F2E98)],
          )
              : null,
          color: active ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: collapsed
            ? Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(
            icon,
            color: active ? Colors.white : Colors.black54,
          ),
        )
            : ListTile(
          leading: Icon(
            icon,
            color: active ? Colors.white : Colors.black54,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: active ? Colors.white : Colors.black87,
              fontWeight: active ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  final Function(int) onNavigate;
  final VoidCallback onAddManualOrder;

  const _MainContent({
    required this.onNavigate,
    required this.onAddManualOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _TopBar(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                const _StatsGrid(),
                const SizedBox(height: 30),
                _QuickActions(
                  onNavigate: onNavigate,
                  onAddManualOrder: onAddManualOrder,
                ),
                const SizedBox(height: 30),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Recent Activity",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      _ActivityItem(
                        icon: Icons.shopping_bag_outlined,
                        title: "New order #1248 received from Tanvirul Islam",
                        subtitle: "2 minutes ago",
                      ),
                      Divider(),
                      _ActivityItem(
                        icon: Icons.shopping_bag_outlined,
                        title: "Order #1247 completed",
                        subtitle: "15 minutes ago",
                      ),
                      Divider(),
                      _ActivityItem(
                        icon: Icons.shopping_bag_outlined,
                        title: "Payment received for order #1246",
                        subtitle: "1 hour ago",
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.blue.withOpacity(0.5),
        ),
        child: Icon(
          icon,
          color: CupertinoColors.black,
        ),
      ),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              Text(
                "Welcome Back, Admin",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Icon(Icons.notifications_none),
            ],
          ),
          Text(
            "Here's what's happening with your laundry service today",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = 3;
        if (constraints.maxWidth < 1200) columns = 2;
        if (constraints.maxWidth < 700) columns = 1;

        return GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 130,
          ),
          children: const [
            _StatCard(
              "Total Orders",
              "12",
              "+12%",
              Colors.indigo,
              Icons.lock_outline,
            ),
            _StatCard(
              "Pending Orders",
              "2",
              "2 active",
              Colors.orange,
              Icons.access_time,
            ),
            _StatCard(
              "Received Orders",
              "3",
              "3 active",
              Colors.blue,
              Icons.inbox,
            ),
            _StatCard(
              "Completed Orders",
              "5",
              "+15%",
              Colors.green,
              Icons.check_circle,
            ),
            _StatCard(
              "Due Payments",
              "TK 12,450",
              "2 orders",
              Colors.red,
              Icons.payments,
            ),
            _StatCard(
              "Today Revenue",
              "TK 8,920",
              "+18%",
              Colors.teal,
              Icons.trending_up,
            ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatefulWidget {
  final String title, value, subtitle;
  final Color color;
  final IconData icon;

  const _StatCard(
      this.title, this.value, this.subtitle, this.color, this.icon);

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  double elevation = 0;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => elevation = 8),
      onExit: (_) => setState(() => elevation = 0),
      child: AnimatedPhysicalModel(
        duration: const Duration(milliseconds: 200),
        elevation: elevation,
        shadowColor: Colors.black,
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title,
                          style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 6),
                      Text(
                        widget.value,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(widget.icon, color: widget.color),
                  ),
                ],
              ),
              Text(
                widget.subtitle,
                style: TextStyle(color: widget.color, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  final Function(int) onNavigate;
  final VoidCallback onAddManualOrder;

  const _QuickActions({
    required this.onNavigate,
    required this.onAddManualOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quick Actions",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            int columns = 4;
            if (constraints.maxWidth < 1100) columns = 3;
            if (constraints.maxWidth < 800) columns = 2;
            if (constraints.maxWidth < 600) columns = 1;

            return GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                mainAxisExtent: 100,
              ),
              children: [
                _ActionCard(
                  Icons.list,
                  "View All Orders",
                  "Manage and track all orders",
                  onTap: () => onNavigate(1),
                ),
                _ActionCard(
                  Icons.add_circle,
                  "Add Manual Order",
                  "Create new order manually",
                  onTap: onAddManualOrder,
                  // Background color removed for this instance
                ),
                _ActionCard(
                  Icons.bar_chart,
                  "Reports",
                  "View analytics and insights",
                  onTap: () => onNavigate(2),
                ),
                _ActionCard(
                  Icons.settings,
                  "Settings",
                  "Configure system settings",
                  onTap: () => onNavigate(3),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ActionCard extends StatefulWidget {
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  final bool isPrimary;

  const _ActionCard(
      this.icon,
      this.title,
      this.subtitle, {
        required this.onTap,
        this.isPrimary = false,
      });

  @override
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard> {
  double elevation = 0;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => elevation = 8),
      onExit: (_) => setState(() => elevation = 0),
      child: AnimatedPhysicalModel(
        duration: const Duration(milliseconds: 200),
        elevation: elevation,
        shadowColor: Colors.black,
        color: widget.isPrimary ? Colors.transparent : Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: widget.isPrimary
              ? BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1D4BC7), Color(0xFF2F2E98)],
            ),
            borderRadius: BorderRadius.circular(14),
          )
              : null,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                child: Row(
                  children: [
                    Icon(
                      widget.icon,
                      size: 26,
                      color: widget.isPrimary ? Colors.white : const Color(0xFF1D4BC7),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: widget.isPrimary ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: widget.isPrimary ? Colors.white70 : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}