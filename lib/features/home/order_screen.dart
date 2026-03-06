import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => OrderScreenState();
}

class OrderScreenState extends State<OrderScreen> {
  String selectedStatus = "All";
  String selectedBranch = "All Branches";
  String searchQuery = "";

  final List<OrderModel> orders = [
    OrderModel("ORD-1248", "Mahmud Hassan", "Wash & Fold", "Dhanmondi", 450, "Pending", DateTime(2025, 1, 15)),
    OrderModel("ORD-1249", "Fatema Akter", "Dry Clean", "Gulshan", 800, "Completed", DateTime(2025, 1, 14)),
    OrderModel("ORD-1250", "Tanvir Rahman", "Ironing", "Mirpur", 300, "Received", DateTime(2025, 1, 13)),
    OrderModel("ORD-1251", "Ayesha Siddika", "Wash & Fold", "Gulshan", 520, "Completed", DateTime(2025, 1, 12)),
    OrderModel("ORD-1252", "Kamrul Islam", "Dry Clean", "Dhanmondi", 950, "Pending", DateTime(2025, 1, 15)),
    OrderModel("ORD-1253", "Nusrat Jahan", "Premium Wash", "Mirpur", 680, "Received", DateTime(2025, 1, 14)),
    OrderModel("ORD-1254", "Rafiqul Alam", "Ironing", "Gulshan", 250, "Due", DateTime(2025, 1, 10)),
    OrderModel("ORD-1255", "Sharmin Sultana", "Wash & Fold", "Dhanmondi", 480, "Completed", DateTime(2025, 1, 13)),
    OrderModel("ORD-1256", "Habibur Rahman", "Dry Clean", "Mirpur", 720, "Received", DateTime(2025, 1, 15)),
    OrderModel("ORD-1257", "Tasnuva Haque", "Premium Wash", "Gulshan", 890, "Pending", DateTime(2025, 1, 15)),
    OrderModel("ORD-1258", "Sabbir Ahmed", "Wash & Fold", "Dhanmondi", 420, "Completed", DateTime(2025, 1, 11)),
    OrderModel("ORD-1259", "Roksana Begum", "Ironing", "Mirpur", 350, "Received", DateTime(2025, 1, 14)),
    OrderModel("ORD-1260", "Md. Kamal Hossain", "Dry Clean", "Gulshan", 1200, "Due", DateTime(2025, 1, 8)),
    OrderModel("ORD-1261", "Nazma Khatun", "Wash & Fold", "Dhanmondi", 550, "Pending", DateTime(2025, 1, 15)),
    OrderModel("ORD-1262", "Jahangir Alam", "Premium Wash", "Mirpur", 780, "Completed", DateTime(2025, 1, 12)),
  ];

  List<String> statuses = ["All", "Pending", "Received", "Completed", "Due"];
  List<String> branches = ["All Branches", "Dhanmondi", "Gulshan", "Mirpur"];

  // Public method to open the dialog from outside
  void openAddOrderDialog() {
    _showAddOrderDialog();
  }

  // Method to update order status
  void _updateOrderStatus(OrderModel order, String newStatus) {
    setState(() {
      order.status = newStatus;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order ${order.id} moved to $newStatus'),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Modern slate-50 background
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 1000;

          return Padding(
            padding: EdgeInsets.all(isDesktop ? 40 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(isDesktop),
                const SizedBox(height: 24),
                _buildSearchBar(isDesktop),
                const SizedBox(height: 20),
                _buildStatusTabs(isDesktop),
                const SizedBox(height: 24),
                Expanded(child: _buildOrdersList()),
              ],
            ),
          );
        },
      ),
    );
  }

  // ================= HEADER =================

  Widget _buildHeader(bool isDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Orders Management",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF0F172A), letterSpacing: -0.5),
            ),
            const SizedBox(height: 4),
            Text(
              "Track and manage all laundry orders",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1D4BC7), Color(0xFF2F2E98)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: const Color(0xFF1D4BC7).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: _showAddOrderDialog,
            icon: const Icon(Icons.add, color: Colors.white, size: 20),
            label: const Text("Add New Order", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 24 : 16, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  // ================= SEARCH BAR =================

  Widget _buildSearchBar(bool isDesktop) {
    return Row(
      children: [
        Expanded(
          flex: isDesktop ? 3 : 2,
          child: TextField(
            onChanged: (value) => setState(() => searchQuery = value),
            decoration: InputDecoration(
              hintText: "Search by order ID, customer name, or branch...",
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1D4BC7))),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: DropdownButtonFormField(
            value: selectedBranch,
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade600),
            items: branches.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
            onChanged: (value) => setState(() => selectedBranch = value.toString()),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1D4BC7))),
            ),
          ),
        ),
      ],
    );
  }

  // ================= STATUS TABS =================

  Widget _buildStatusTabs(bool isDesktop) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: statuses.map((status) {
          bool selected = selectedStatus == status;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => setState(() => selectedStatus = status),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  gradient: selected
                      ? const LinearGradient(colors: [Color(0xFF1D4BC7), Color(0xFF2F2E98)])
                      : null,
                  color: selected ? null : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: selected ? null : Border.all(color: Colors.grey.shade200),
                  boxShadow: selected
                      ? [BoxShadow(color: const Color(0xFF1D4BC7).withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 3))]
                      : [],
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.grey.shade700,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ================= ORDER LIST =================

  Widget _buildOrdersList() {
    List<OrderModel> filtered = orders.where((order) {
      bool matchesStatus = selectedStatus == "All" || order.status == selectedStatus;
      bool matchesBranch = selectedBranch == "All Branches" || order.branch == selectedBranch;
      bool matchesSearch = order.id.toLowerCase().contains(searchQuery.toLowerCase()) ||
          order.customer.toLowerCase().contains(searchQuery.toLowerCase());

      return matchesStatus && matchesBranch && matchesSearch;
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_rounded, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text("No orders found", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, i) => _OrderCard(
        filtered[i],
        onStatusChange: _updateOrderStatus,
      ),
    );
  }

  // ================= ADD ORDER DIALOG =================

  void _showAddOrderDialog() {
    showDialog(
      context: context,
      builder: (_) => AddOrderDialog(
        onOrderAdded: (newOrder) {
          setState(() {
            orders.insert(0, newOrder);
          });
        },
      ),
    );
  }
}

// ================= ADD ORDER DIALOG =================

class AddOrderDialog extends StatefulWidget {
  final Function(OrderModel) onOrderAdded;

  const AddOrderDialog({super.key, required this.onOrderAdded});

  @override
  State<AddOrderDialog> createState() => _AddOrderDialogState();
}

class _AddOrderDialogState extends State<AddOrderDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _quantityController = TextEditingController(text: "1");
  final _priceController = TextEditingController();
  final _notesController = TextEditingController();

  String selectedBranch = "Dhanmondi";
  String selectedService = "Wash & Fold";
  DateTime selectedDate = DateTime.now();

  final List<String> branches = ["Dhanmondi", "Gulshan", "Mirpur"];
  final List<String> services = ["Wash & Fold", "Dry Clean", "Ironing", "Premium Wash"];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _generateOrderId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return "ORD-${timestamp.toString().substring(7)}";
  }

  void _submitOrder() {
    if (_formKey.currentState!.validate()) {
      final newOrder = OrderModel(
        _generateOrderId(),
        _nameController.text.trim(),
        selectedService,
        selectedBranch,
        double.parse(_priceController.text),
        "Pending",
        selectedDate,
      );

      widget.onOrderAdded(newOrder);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Order added successfully!'),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade200)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade200)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF1D4BC7))),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 750),
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: const Color(0xFF1D4BC7).withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.add_shopping_cart_rounded, color: Color(0xFF1D4BC7)),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text("Add New Order", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.grey),
                    splashRadius: 24,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Customer Name *", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF334155))),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        decoration: _inputDecoration("Enter customer name"),
                        validator: (value) => value == null || value.trim().isEmpty ? 'Customer name is required' : null,
                      ),
                      const SizedBox(height: 20),

                      const Text("Phone Number *", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF334155))),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: _inputDecoration("Enter phone number"),
                        validator: (value) => value == null || value.trim().isEmpty ? 'Phone number is required' : null,
                      ),
                      const SizedBox(height: 20),

                      const Text("Address", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF334155))),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _addressController,
                        maxLines: 2,
                        decoration: _inputDecoration("Enter delivery address"),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Branch *", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF334155))),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  value: selectedBranch,
                                  icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade600),
                                  items: branches.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
                                  onChanged: (value) => setState(() => selectedBranch = value!),
                                  decoration: _inputDecoration(""),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Service *", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF334155))),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  value: selectedService,
                                  icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade600),
                                  items: services.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
                                  onChanged: (value) => setState(() => selectedService = value!),
                                  decoration: _inputDecoration(""),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Quantity (kg) *", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF334155))),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _quantityController,
                                  keyboardType: TextInputType.number,
                                  decoration: _inputDecoration("Enter quantity"),
                                  validator: (value) => value == null || value.trim().isEmpty ? 'Required' : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Price (TK) *", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF334155))),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _priceController,
                                  keyboardType: TextInputType.number,
                                  decoration: _inputDecoration("Enter price"),
                                  validator: (value) => value == null || value.trim().isEmpty ? 'Required' : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      const Text("Pickup Date *", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF334155))),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(primary: Color(0xFF1D4BC7)),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (date != null) setState(() => selectedDate = date);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${selectedDate.day}/${selectedDate.month}/${selectedDate.year}", style: const TextStyle(fontSize: 15, color: Color(0xFF334155))),
                              const Icon(Icons.calendar_today_rounded, color: Color(0xFF1D4BC7), size: 20),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text("Notes", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF334155))),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _notesController,
                        maxLines: 3,
                        decoration: _inputDecoration("Add any special instructions..."),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Cancel", style: TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF1D4BC7), Color(0xFF2F2E98)]),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: const Color(0xFF1D4BC7).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
                      ),
                      child: ElevatedButton(
                        onPressed: _submitOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Add Order", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= MODEL =================

class OrderModel {
  final String id;
  final String customer;
  final String service;
  final String branch;
  final double price;
  String status;
  final DateTime date;

  OrderModel(this.id, this.customer, this.service, this.branch, this.price, this.status, this.date);
}

// ================= CARD =================

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final Function(OrderModel, String) onStatusChange;

  const _OrderCard(this.order, {required this.onStatusChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFF1D4BC7).withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.shopping_bag_outlined, size: 28, color: Color(0xFF1D4BC7)),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(order.id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A))),
                        const SizedBox(width: 12),
                        _StatusBadge(order.status),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(order.customer, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xFF334155))),
                    const SizedBox(height: 4),
                    Text("${order.service} • ${order.branch}", style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("TK ${order.price.toStringAsFixed(0)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  const SizedBox(height: 6),
                  Text("${order.date.day}/${order.date.month}/${order.date.year}", style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                ],
              ),
            ],
          ),

          // Action Buttons based on status
          if (order.status == "Pending" || order.status == "Received") ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            _buildActionButtons(),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    if (order.status == "Pending") {
      return Row(
        children: [
          Expanded(child: _StatusButton(label: "Received", color: const Color(0xFF3B82F6), onPressed: () => onStatusChange(order, "Received"))),
          const SizedBox(width: 12),
          Expanded(child: _StatusButton(label: "Completed", color: const Color(0xFF10B981), onPressed: () => onStatusChange(order, "Completed"))),
          const SizedBox(width: 12),
          Expanded(child: _StatusButton(label: "Due", color: const Color(0xFFEF4444), onPressed: () => onStatusChange(order, "Due"))),
        ],
      );
    } else if (order.status == "Received") {
      return Row(
        children: [
          Expanded(child: _StatusButton(label: "Completed", color: const Color(0xFF10B981), onPressed: () => onStatusChange(order, "Completed"))),
          const SizedBox(width: 12),
          Expanded(child: _StatusButton(label: "Due", color: const Color(0xFFEF4444), onPressed: () => onStatusChange(order, "Due"))),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}

// ================= STATUS BUTTON =================

class _StatusButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _StatusButton({required this.label, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
    );
  }
}

// ================= STATUS BADGE =================

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge(this.status);

  @override
  Widget build(BuildContext context) {
    Color color;
    Color bgColor;

    switch (status) {
      case "Pending":
        color = const Color(0xFFD97706); // Amber
        bgColor = const Color(0xFFFEF3C7);
        break;
      case "Completed":
        color = const Color(0xFF059669); // Emerald
        bgColor = const Color(0xFFD1FAE5);
        break;
      case "Received":
        color = const Color(0xFF2563EB); // Blue
        bgColor = const Color(0xFFDBEAFE);
        break;
      default:
        color = const Color(0xFFDC2626); // Red
        bgColor = const Color(0xFFFEE2E2);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Text(status, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}