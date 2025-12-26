import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'donor_list.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
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
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.person,
                                  color: Color(0xFFEF4444), size: 20),
                            ),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Welcome back",
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.9)),
                                ),
                                Text(
                                  "Umer",
                                  style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            _circleBtn(Icons.notifications_outlined, context),
                            SizedBox(width: 8),
                            _circleBtn(Icons.logout, context),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    Text(
                      "Save a Life Today",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Every donation counts. Be someone's hero.",
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: 28),
                  ],
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(0, -40),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        print("Emergency tapped");
                      },
                      child: _emergencyCard(),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // ✅ Correct navigation to DonorListPage
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DonorListPage(),
                                ),
                              );
                            },
                            child: _actionCard(
                                Icons.search, "Find Donor", "Search nearby"),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              print("Be a Donor tapped");
                            },
                            child: _actionCard(Icons.favorite_border,
                                "Be a Donor", "Register now"),
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
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RECENT ACTIVITY',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 12),
                    _recentItem(
                      icon: Icons.favorite,
                      iconColor: Color(0xFF16A34A),
                      bgColor: Color(0xFFDCFCE7),
                      title: 'Successful Donation',
                      time: '2 days ago',
                      badge: '+1',
                    ),
                    SizedBox(height: 14),
                    _recentItem(
                      icon: Icons.person,
                      iconColor: Color(0xFF2563EB),
                      bgColor: Color(0xFFDBEAFE),
                      title: 'Profile Updated',
                      time: '1 week ago',
                    ),
                    SizedBox(height: 80),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey[200]!)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                      onTap: () => print("Home tapped"),
                      child: _navItem(Icons.home, "Home", true)),
                  GestureDetector(
                      onTap: () => print("Donors tapped"),
                      child: _navItem(Icons.favorite_border, "Donors", false)),
                  GestureDetector(
                      onTap: () => print("Profile tapped"),
                      child: _navItem(Icons.person_outline, "Profile", false)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleBtn(IconData icon, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (icon == Icons.logout) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('', style: TextStyle(fontWeight: FontWeight.bold)),
              content: Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text('Logout', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
        } else {
          print('Icon tapped: $icon');
        }
      },
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.white.withOpacity(0.2),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _emergencyCard() {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF97316), Color(0xFFEF4444)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.all(20),
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
                  child: Icon(Icons.error_outline, color: Colors.white, size: 28),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Emergency",
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    SizedBox(height: 4),
                    Text("Need blood urgently?",
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.9))),
                  ],
                ),
              ],
            ),
            Icon(Icons.chevron_right, color: Colors.white),
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
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Color(0xFFEF4444), size: 22),
            ),
            SizedBox(height: 12),
            Text(title,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, fontSize: 15)),
            SizedBox(height: 4),
            Text(subtitle,
                style: GoogleFonts.poppins(
                    fontSize: 11, color: Colors.grey[500])),
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
      padding: EdgeInsets.all(16),
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
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, fontSize: 13)),
                  SizedBox(height: 2),
                  Text(time,
                      style: GoogleFonts.poppins(
                          fontSize: 11, color: Colors.grey[500])),
                ],
              ),
            ],
          ),
          if (badge != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge,
                style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: iconColor),
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
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: active ? Color(0xFFFEE2E2) : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon,
              size: 20,
              color: active ? Color(0xFFEF4444) : Colors.grey[400]),
        ),
        SizedBox(height: 6),
        Text(label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: active ? Color(0xFFEF4444) : Colors.grey[400],
            )),
      ],
    );
  }
}
