// home_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'donor_list.dart';
import 'login_screen.dart';
import 'be_donor_screen.dart';
// ✅ STEP 1: Emergency screen import add kiya gaya
import 'emergency_request.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0; // 0 = Home, 1 = Donors, 2 = Profile

  Future<String> _getUserName() async {
    await FirebaseAuth.instance.currentUser!.reload();
    return FirebaseAuth.instance.currentUser?.displayName ?? "User";
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text("", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: Text("Are you sure you want to logout?", style: GoogleFonts.poppins()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: GoogleFonts.poppins(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (!mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: Text(
                "Logout",
                style: GoogleFonts.poppins(
                    color: const Color(0xFFEF4444), fontWeight: FontWeight.w500),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getUserName(),
      builder: (context, snapshot) {
        String userName = snapshot.data ?? "User";
        String userEmail = FirebaseAuth.instance.currentUser?.email ?? "Email not found";

        Widget body;
        if (currentIndex == 0) {
          body = _homeContent(userName);
        } else if (currentIndex == 1) {
          body = DonorListPage(
            onBack: () {
              setState(() {
                currentIndex = 0;
              });
            },
          );
        } else {
          body = _profileContent(userName, userEmail);
        }

        return Scaffold(
          backgroundColor: Colors.grey[50],
          body: body,
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                    onTap: () => setState(() => currentIndex = 0),
                    child: _navItem(Icons.home, "Home", currentIndex == 0)),
                GestureDetector(
                    onTap: () => setState(() => currentIndex = 1),
                    child: _navItem(Icons.favorite_border, "Donors", currentIndex == 1)),
                GestureDetector(
                    onTap: () => setState(() => currentIndex = 2),
                    child: _navItem(Icons.person_outline, "Profile", currentIndex == 2)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _profileContent(String userName, String userEmail) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        child: const Icon(Icons.person, size: 60, color: Colors.white),
                      ),
                      const Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.edit, size: 16, color: Color(0xFFEF4444)),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(userName,
                      style: GoogleFonts.poppins(
                          fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(userEmail,
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: Colors.white.withOpacity(0.9))),
                ],
              ),
            ),
            const SizedBox(height: 40),
            _profileMenuTile(Icons.history, "Donation History"),
            _profileMenuTile(Icons.settings_outlined, "Settings"),
            _profileMenuTile(Icons.help_outline, "Help & Support"),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () => _showLogoutDialog(context),
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: Text("Logout",
                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileMenuTile(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.white, size: 22),
          title: Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white)),
          trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.white),
          onTap: () {},
        ),
      ),
    );
  }

  Widget _homeContent(String userName) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person,
                                color: Color(0xFFEF4444), size: 20),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Welcome back",
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.9))),
                              Text(userName,
                                  style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => _showLogoutDialog(context),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: const Icon(Icons.logout, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text("Save a Life Today",
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("Every donation counts. Be someone's hero.",
                      style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.9), fontSize: 13)),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -40),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  // ✅ STEP 2: Emergency card ka onTap update kiya gaya
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EmergencyRequestPage(),
                        ),
                      );
                    },
                    child: _emergencyCard(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => currentIndex = 1),
                          child: _actionCard(Icons.search, "Find Donor", "Search nearby"),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const BeDonorScreen()),
                            );
                          },
                          child: _actionCard(Icons.favorite_border, "Be a Donor", "Register now"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('RECENT ACTIVITY',
                      style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1)),
                  const SizedBox(height: 12),
                  _recentItem(
                      icon: Icons.favorite,
                      iconColor: const Color(0xFF16A34A),
                      bgColor: const Color(0xFFDCFCE7),
                      title: 'Successful Donation',
                      time: '2 days ago',
                      badge: '+1'),
                  const SizedBox(height: 14),
                  _recentItem(
                      icon: Icons.person,
                      iconColor: const Color(0xFF2563EB),
                      bgColor: const Color(0xFFDBEAFE),
                      title: 'Profile Updated',
                      time: '1 week ago'),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emergencyCard() {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF97316), Color(0xFFEF4444)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.error_outline, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Emergency",
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 4),
                    Text("Need blood urgently?",
                        style: GoogleFonts.poppins(
                            fontSize: 13, color: Colors.white.withOpacity(0.9))),
                  ],
                ),
              ],
            ),
            const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _actionCard(IconData icon, String title, String subtitle) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFFEF4444), size: 22),
            ),
            const SizedBox(height: 12),
            Text(title,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15)),
            const SizedBox(height: 4),
            Text(subtitle,
                style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }

  Widget _recentItem({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String time,
    String? badge,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: bgColor,
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, fontSize: 13)),
                  const SizedBox(height: 2),
                  Text(time,
                      style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[500])),
                ],
              ),
            ],
          ),
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge,
                style: GoogleFonts.poppins(
                    fontSize: 11, fontWeight: FontWeight.w600, color: iconColor),
              ),
            ),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool active) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: active ? const Color(0xFFFEE2E2) : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon,
              size: 20, color: active ? const Color(0xFFEF4444) : Colors.grey[400]),
        ),
        const SizedBox(height: 6),
        Text(label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: active ? const Color(0xFFEF4444) : Colors.grey[400],
            )),
      ],
    );
  }
}