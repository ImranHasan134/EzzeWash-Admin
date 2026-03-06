import 'package:flutter/material.dart';
import 'package:ezeewash_admin/features/auth/admin_login_screen.dart';

// ================= SETTINGS SCREEN =================
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int selectedTab = 0;

  // Custom colors for the new theme
  final Color primaryBrandColor = const Color(0xFF1D4BC7);
  final Gradient primaryGradient = const LinearGradient(
    colors: [Color(0xFF1D4BC7), Color(0xFF2F2E98)],
  );

  // --- State Variables for Dynamic Updates ---

  // Security
  String currentEmail = "admin@bangladesh.com";
  bool twoFactorEnabled = true;
  bool emailNotification = true;
  bool smsNotification = true;

  // Profile Controllers
  late final TextEditingController _adminNameController;
  late final TextEditingController _adminPhoneController;

  // Business Controllers
  late final TextEditingController _bizNameController;
  late final TextEditingController _bizPhoneController;
  late final TextEditingController _bizAddressController;
  late final TextEditingController _bizGstController;

  // Team members
  List<Map<String, dynamic>> teamMembers = [
    {"name": "Admin User", "email": "admin@bangladesh.com", "role": "Super Admin", "color": Colors.green},
    {"name": "Rahim Uddin", "email": "rahim@bangladesh.com", "role": "Manager", "color": Colors.teal},
    {"name": "Fatema Khatun", "email": "fatema@bangladesh.com", "role": "Staff", "color": Colors.grey},
  ];

  @override
  void initState() {
    super.initState();
    // Initialize controllers with default values
    _adminNameController = TextEditingController(text: "Admin User");
    _adminPhoneController = TextEditingController(text: "+880 1712 345678");

    _bizNameController = TextEditingController(text: "Ezee Wash BD");
    _bizPhoneController = TextEditingController(text: "+880 1712 345678");
    _bizAddressController = TextEditingController(text: "Dhaka, Bangladesh");
    _bizGstController = TextEditingController(text: "N/A");
  }

  @override
  void dispose() {
    _adminNameController.dispose();
    _adminPhoneController.dispose();
    _bizNameController.dispose();
    _bizPhoneController.dispose();
    _bizAddressController.dispose();
    _bizGstController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Settings",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Manage your account, team, and business preferences",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                _buildTabs(),
                const SizedBox(height: 24),
                _buildSelectedScreen(width),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= TABS =================
  Widget _buildTabs() {
    final tabs = ["Profile", "Security", "Team", "Business", "Notifications"];
    final icons = [
      Icons.person_outline, Icons.lock_outline, Icons.group_outlined,
      Icons.store_outlined, Icons.notifications_none,
    ];

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.02))],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isSelected = selectedTab == index;
            return GestureDetector(
              onTap: () => setState(() => selectedTab = index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  gradient: isSelected ? primaryGradient : null,
                  color: isSelected ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(icons[index], size: 18, color: isSelected ? Colors.white : Colors.black87),
                    const SizedBox(width: 6),
                    Text(
                      tabs[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ================= SCREEN SWITCHER =================
  Widget _buildSelectedScreen(double width) {
    switch (selectedTab) {
      case 0: return _profileScreen();
      case 1: return _securityScreen();
      case 2: return _teamScreen();
      case 3: return _businessScreen();
      case 4: return _notificationScreen();
      default: return const SizedBox();
    }
  }

  // ================= PROFILE SECTION =================
  Widget _profileScreen() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(blurRadius: 12, color: Colors.black.withOpacity(.03))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Profile Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      "https://ui-avatars.com/api/?name=${_adminNameController.text.replaceAll(' ', '+')}&background=random"),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      gradient: primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 24),
          _textField("Full Name", _adminNameController),
          const SizedBox(height: 16),
          _textField("Phone Number", _adminPhoneController),
          const SizedBox(height: 32),
          _primaryButton("Update Profile", () {
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Profile updated successfully!")),
            );
          }),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _confirmLogout,
              child: const Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle),
                  child: const Icon(Icons.logout_rounded, color: Colors.red, size: 32),
                ),
                const SizedBox(height: 16),
                const Text("Confirm Logout", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text(
                  "Are you sure you want to log out of your admin account? You will need to enter your credentials to access it again.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel", style: TextStyle(color: Colors.black87)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminLoginScreen()));
                        },
                        child: const Text("Logout", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= SECURITY =================
  Widget _securityScreen() {
    return Column(
      children: [
        _cardWrapper(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Security", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 24),
              _securityTile("Change Password", "Update your account password", _showChangePasswordDialog),
              const Divider(),
              _securityTile("Change Email Address", "Current: $currentEmail", _showChangeEmailDialog),
              const SizedBox(height: 20),
              SwitchListTile(
                value: twoFactorEnabled,
                title: const Text("Enable Two-Factor Authentication"),
                subtitle: const Text("Require phone & password for sensitive actions"),
                onChanged: (val) => setState(() => twoFactorEnabled = val),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _dangerZone(),
      ],
    );
  }

  Widget _securityTile(String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      trailing: TextButton(onPressed: onTap, child: const Text("Change")),
    );
  }

  void _showChangeEmailDialog() {
    final emailCtrl = TextEditingController(text: currentEmail);
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Change Email", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _dialogTextField("New Email Address", emailCtrl, icon: Icons.email_outlined),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        gradient: primaryGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          setState(() => currentEmail = emailCtrl.text);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email address updated!")));
                        },
                        child: const Text("Save", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    final passCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Change Password", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _dialogTextField("New Password", passCtrl, icon: Icons.lock_outline, obscureText: true),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        gradient: primaryGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password updated securely!")));
                        },
                        child: const Text("Update", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= TEAM =================
  Widget _teamScreen() {
    return Column(
      children: [
        _cardWrapper(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text("Team Members", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      gradient: primaryGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _showInviteMemberDialog,
                      icon: const Icon(Icons.person_add_alt, color: Colors.white),
                      label: const Text("Invite Member", style: TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24),
              ...teamMembers.map((member) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _teamTile(member["name"], member["email"], member["role"], member["color"]),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _teamTile(String name, String email, String role, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color,
            child: Text(name[0], style: const TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(email, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Text(role, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showInviteMemberDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    String localSelectedRole = "Staff";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: StatefulBuilder(
              builder: (context, setStateDialog) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: primaryBrandColor.withOpacity(0.1), shape: BoxShape.circle),
                              child: Icon(Icons.person_add_alt_1, color: primaryBrandColor),
                            ),
                            const SizedBox(width: 16),
                            const Text("Invite New Member", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _dialogTextField("Full Name", nameController, icon: Icons.person_outline),
                        const SizedBox(height: 16),
                        _dialogTextField("Email Address", emailController, icon: Icons.email_outlined),
                        const SizedBox(height: 16),
                        _dialogTextField("Phone Number", phoneController, icon: Icons.phone_outlined),
                        const SizedBox(height: 16),
                        const Text("Role", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.black87)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: localSelectedRole,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            prefixIcon: const Icon(Icons.badge_outlined, color: Colors.grey),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                          items: ["Super Admin", "Manager", "Staff"].map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setStateDialog(() => localSelectedRole = val);
                            }
                          },
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel", style: TextStyle(color: Colors.black54)),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              decoration: BoxDecoration(
                                gradient: primaryGradient,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: () {
                                  if (nameController.text.isEmpty || emailController.text.isEmpty || phoneController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
                                    return;
                                  }
                                  setState(() { // Main state update
                                    Color roleColor = localSelectedRole == "Super Admin" ? Colors.green : localSelectedRole == "Manager" ? Colors.teal : Colors.grey;
                                    teamMembers.add({"name": nameController.text, "email": emailController.text, "role": localSelectedRole, "color": roleColor});
                                  });
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Team member invited!")));
                                },
                                child: const Text("Send Invite", style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  // ================= BUSINESS =================
  Widget _businessScreen() {
    return Column(
      children: [
        _cardWrapper(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Business Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 24),
              _textField("Business Name", _bizNameController),
              const SizedBox(height: 20),
              _textField("Business Phone", _bizPhoneController),
              const SizedBox(height: 20),
              _textField("Business Address", _bizAddressController),
              const SizedBox(height: 20),
              _textField("TIN / GST Number", _bizGstController),
              const SizedBox(height: 24),
              _primaryButton("Save Business Info", () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Business Information Saved Successfully!")),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  // ================= NOTIFICATIONS =================
  Widget _notificationScreen() {
    return Column(
      children: [
        _cardWrapper(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Notification Settings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 24),
              SwitchListTile(
                value: emailNotification,
                title: const Text("Email Notifications"),
                subtitle: const Text("Receive order updates via email"),
                onChanged: (val) => setState(() => emailNotification = val),
              ),
              SwitchListTile(
                value: smsNotification,
                title: const Text("SMS Notifications"),
                subtitle: const Text("Receive important alerts via SMS"),
                onChanged: (val) => setState(() => smsNotification = val),
              ),
              const SizedBox(height: 24),
              _primaryButton("Save Preferences", () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Notification Preferences Saved!")));
              }),
            ],
          ),
        ),
      ],
    );
  }

  // ================= COMMON WIDGETS =================
  Widget _cardWrapper(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(blurRadius: 12, color: Colors.black.withOpacity(.03))],
      ),
      child: child,
    );
  }

  // Helper for main screen inputs
  Widget _textField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade200)),
          ),
        ),
      ],
    );
  }

  // Helper for dialog inputs
  Widget _dialogTextField(String label, TextEditingController controller, {IconData? icon, bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.black87)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _primaryButton(String label, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: primaryGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // ================= DANGER ZONE =================
  Widget _dangerZone() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              "Delete Account\nPermanently delete your account and all associated data",
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: _deleteAccountDialog,
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deleteAccountDialog() {
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle),
                        child: const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Text("Delete Account", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Are you sure you want to permanently delete your account? This action cannot be undone.",
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 24),
                  _dialogTextField("Confirm Phone Number", phoneController, icon: Icons.phone_outlined),
                  const SizedBox(height: 16),
                  _dialogTextField("Confirm Password", passwordController, icon: Icons.lock_outline, obscureText: true),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey.shade300),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text("Cancel", style: TextStyle(color: Colors.black87)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Account Deleted")));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text("Delete", style: TextStyle(color: Colors.white)),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}