import 'package:flutter/material.dart';
import 'dart:math';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final List<MonthlyData> revenueData = [
    MonthlyData("Jan", 45000, 145),
    MonthlyData("Feb", 52000, 168),
    MonthlyData("Mar", 48000, 152),
    MonthlyData("Apr", 61000, 189),
    MonthlyData("May", 55000, 176),
    MonthlyData("Jun", 67000, 203),
  ];

  @override
  Widget build(BuildContext context) {
    double totalRevenue = revenueData.fold(0, (sum, e) => sum + e.revenue);
    int totalOrders = revenueData.fold(0, (sum, e) => sum + e.orders);
    double avgOrderValue = totalRevenue / totalOrders;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int statCrossAxisCount = constraints.maxWidth > 1200
              ? 4
              : constraints.maxWidth > 800
              ? 2
              : 1;

          bool sideBySideCharts = constraints.maxWidth > 1000;

          return Padding(
            padding: EdgeInsets.all(constraints.maxWidth > 1000 ? 40 : 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ================= HEADER =================
                  const Text(
                    "Reports & Analytics",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "View your business performance and insights",
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 30),

                  // ================= STAT CARDS =================
                  GridView.count(
                    crossAxisCount: statCrossAxisCount,
                    shrinkWrap: true,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 2.8,
                    children: [
                      _StatCard(
                        "Total Revenue",
                        "TK ${_format(totalRevenue)}",
                        Icons.attach_money,
                        Colors.green,
                      ),
                      _StatCard(
                        "Total Orders",
                        totalOrders.toString(),
                        Icons.shopping_bag_outlined,
                        const Color(0xFF1D4BC7),
                      ),
                      _StatCard(
                        "Avg Order Value",
                        "TK ${avgOrderValue.toStringAsFixed(0)}",
                        Icons.bar_chart,
                        Colors.blue,
                      ),
                      _StatCard(
                        "Customer Retention",
                        "87%",
                        Icons.person_outline,
                        Colors.teal,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // ================= CHARTS =================
                  sideBySideCharts
                      ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(fit: FlexFit.loose, child: _RevenueChart(revenueData)),
                      const SizedBox(width: 20),
                      Flexible(fit: FlexFit.loose, child: _OrdersChart(revenueData)),
                    ],
                  )
                      : Column(
                    children: [
                      _RevenueChart(revenueData),
                      const SizedBox(height: 20),
                      _OrdersChart(revenueData),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // ================= SERVICE PERFORMANCE =================
                  _ServicePerformanceCard(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _format(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ",");
  }
}

// ================= MODEL =================
class MonthlyData {
  final String month;
  final double revenue;
  final int orders;

  MonthlyData(this.month, this.revenue, this.orders);
}

// ================= STAT CARD =================
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard(this.title, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ================= REVENUE CHART =================
class _RevenueChart extends StatelessWidget {
  final List<MonthlyData> data;

  const _RevenueChart(this.data);

  @override
  Widget build(BuildContext context) {
    double maxValue = data.map((e) => e.revenue).reduce(max);

    return _ChartContainer(
      title: "Monthly Revenue",
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: data.map((e) {
          double percent = e.revenue / maxValue;
          return Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(e.month), Text("TK ${e.revenue.toInt()}")],
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: percent,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade200,
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ================= ORDERS CHART =================
class _OrdersChart extends StatelessWidget {
  final List<MonthlyData> data;

  const _OrdersChart(this.data);

  @override
  Widget build(BuildContext context) {
    double maxValue = data.map((e) => e.orders.toDouble()).reduce(max);

    return _ChartContainer(
      title: "Monthly Orders",
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: data.map((e) {
          double percent = e.orders / maxValue;
          return Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(e.month), Text("${e.orders} orders")],
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: percent,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade200,
                  color: const Color(0xFF1D4BC7),
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ================= CHART WRAPPER =================
class _ChartContainer extends StatelessWidget {
  final String title;
  final Widget child;

  const _ChartContainer({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

// ================= SERVICE PERFORMANCE =================
class _ServicePerformanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _ChartContainer(
      title: "Service Performance",
      child: Column(
        children: [
          _ServiceTile(
            name: "Wash & Fold",
            monthlyOrders: {
              "Jan": 40, "Feb": 55, "Mar": 38, "Apr": 60, "May": 52, "Jun": 65,
            },
          ),
          _ServiceTile(
            name: "Dry Clean",
            monthlyOrders: {
              "Jan": 30, "Feb": 35, "Mar": 28, "Apr": 45, "May": 40, "Jun": 50,
            },
          ),
          _ServiceTile(
            name: "Iron Only",
            monthlyOrders: {
              "Jan": 20, "Feb": 25, "Mar": 22, "Apr": 30, "May": 27, "Jun": 35,
            },
          ),
          _ServiceTile(
            name: "Express Service",
            monthlyOrders: {
              "Jan": 15, "Feb": 20, "Mar": 18, "Apr": 25, "May": 22, "Jun": 30,
            },
          ),
        ],
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final String name;
  final Map<String, int> monthlyOrders;

  const _ServiceTile({required this.name, required this.monthlyOrders});

  @override
  Widget build(BuildContext context) {
    int totalOrders = monthlyOrders.values.reduce((a, b) => a + b);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text("$totalOrders total orders", style: TextStyle(color: Colors.grey.shade600)),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
          child: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black54),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => _ServiceDetailDialog(serviceName: name, monthlyOrders: monthlyOrders),
          );
        },
      ),
    );
  }
}

// ================= DETAIL DIALOG (PROFESSIONAL DESIGN) =================
class _ServiceDetailDialog extends StatelessWidget {
  final String serviceName;
  final Map<String, int> monthlyOrders;

  const _ServiceDetailDialog({required this.serviceName, required this.monthlyOrders});

  @override
  Widget build(BuildContext context) {
    int totalOrders = monthlyOrders.values.reduce((a, b) => a + b);
    int maxOrders = monthlyOrders.values.reduce(max);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 450),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Icon and Title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1D4BC7).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.analytics_outlined, color: Color(0xFF1D4BC7), size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(serviceName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                          const SizedBox(height: 4),
                          Text("$totalOrders Total Orders • Last 6 Months", style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.grey),
                      splashRadius: 24,
                    )
                  ],
                ),
                const SizedBox(height: 24),

                // Section Title
                const Text("MONTHLY BREAKDOWN", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
                const SizedBox(height: 12),

                // Analytics Cards
                ...monthlyOrders.entries.map((entry) {
                  double percent = entry.value / maxOrders;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
                            Text("${entry.value} orders", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1D4BC7))),
                          ],
                        ),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: percent,
                          minHeight: 6,
                          backgroundColor: Colors.grey.shade200,
                          color: const Color(0xFF1D4BC7),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 16),

                // Action Button with custom Gradient
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1D4BC7), Color(0xFF2F2E98)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Done", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}