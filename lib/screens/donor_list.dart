// donor_list.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonorListPage extends StatefulWidget {
  final VoidCallback onBack;

  const DonorListPage({
    Key? key,
    required this.onBack,
  }) : super(key: key);

  @override
  State<DonorListPage> createState() => _DonorListPageState();
}

class _DonorListPageState extends State<DonorListPage> {
  String selectedBloodType = "All";
  String selectedCity = "All Cities";
  String searchQuery = "";

  final List<String> bloodTypes = [
    "All", "A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"
  ];

  final List<String> cities = [
    "All Cities", "Faisalabad", "Lahore", "Karachi", "Islamabad", "Rawalpindi"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // Header
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
                            GestureDetector(
                              onTap: widget.onBack,
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white.withOpacity(0.2),
                                child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Find Donors",
                              style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => _showFilterSheet(),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: Icon(Icons.filter_list, color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value.toLowerCase();
                          });
                        },
                        style: GoogleFonts.poppins(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Search by name...",
                          hintStyle: GoogleFonts.poppins(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 13),
                          prefixIcon: Icon(Icons.search, color: Colors.white, size: 20),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Filter Chips
            Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Filters Applied:",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedBloodType = "All";
                            selectedCity = "All Cities";
                          });
                        },
                        child: Text(
                          "",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFEF4444),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _filterChip(
                          label: selectedBloodType,
                          icon: Icons.water_drop,
                          onTap: _showBloodTypeSheet,
                        ),
                        SizedBox(width: 8),
                        _filterChip(
                          label: selectedCity,
                          icon: Icons.location_city,
                          onTap: _showCitySheet,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Real-time Firestore Stream
            Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('donors').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) return Center(child: Text("Error loading data"));
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: Color(0xFFEF4444)));
                  }

                  // Client-side filtering
                  final filteredDocs = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    bool bloodMatch = selectedBloodType == "All" || data["bloodType"] == selectedBloodType;
                    bool cityMatch = selectedCity == "All Cities" || data["city"] == selectedCity;
                    bool nameMatch = data["name"].toString().toLowerCase().contains(searchQuery);
                    return bloodMatch && cityMatch && nameMatch;
                  }).toList();

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${filteredDocs.length} Donors Found",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 8, height: 8,
                                    decoration: BoxDecoration(color: Color(0xFF16A34A), shape: BoxShape.circle),
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    "Available",
                                    style: GoogleFonts.poppins(
                                      fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF16A34A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Expanded(
                        child: filteredDocs.isEmpty
                            ? SingleChildScrollView(
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.4,
                                  child: _emptyState(),
                                ),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                itemCount: filteredDocs.length,
                                itemBuilder: (context, index) {
                                  final donor = filteredDocs[index].data() as Map<String, dynamic>;
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 12),
                                    child: _donorCard(donor),
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip({required String label, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Color(0xFFEF4444),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.white),
            SizedBox(width: 6),
            Text(label, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white)),
            SizedBox(width: 4),
            Icon(Icons.arrow_drop_down, size: 18, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _donorCard(Map<String, dynamic> donor) {
    // UPDATED: Ensuring status is "Available" if 'available' field is true or missing
    bool isAvailable = donor["available"] ?? true; 

    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 60, 
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(0xFFFEE2E2), 
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Center(
                    child: Text(
                      donor["bloodType"] ?? "",
                      style: GoogleFonts.poppins(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold, 
                        color: Color(0xFFEF4444)
                      )
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              donor["name"] ?? "",
                              style: GoogleFonts.poppins(
                                fontSize: 16, 
                                fontWeight: FontWeight.w600
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              // GREEN for Available, GREY for Unavailable
                              color: isAvailable ? Color(0xFFDCFCE7) : Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              isAvailable ? "Available" : "Unavailable",
                              style: GoogleFonts.poppins(
                                fontSize: 10, 
                                fontWeight: FontWeight.w600,
                                color: isAvailable ? Color(0xFF16A34A) : Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 14, color: Colors.grey[500]),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              donor["city"] ?? "", 
                              style: GoogleFonts.poppins(
                                fontSize: 12, 
                                color: Colors.grey[600]
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 12),
                          Icon(Icons.favorite, size: 14, color: Colors.grey[500]),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              "${donor['totalDonations'] ?? 0} donations",
                              style: GoogleFonts.poppins(
                                fontSize: 12, 
                                color: Colors.grey[600]
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Last donation: ${donor['lastDonation'] ?? "N/A"}",
                        style: GoogleFonts.poppins(
                          fontSize: 11, 
                          color: Colors.grey[500]
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEF4444),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.phone, size: 16, color: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          "Call Now", 
                          style: GoogleFonts.poppins(
                            fontSize: 13, 
                            fontWeight: FontWeight.w600, 
                            color: Colors.white
                          )
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Color(0xFFEF4444)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person, size: 16, color: Color(0xFFEF4444)),
                        SizedBox(width: 6),
                        Text(
                          "View Profile", 
                          style: GoogleFonts.poppins(
                            fontSize: 13, 
                            fontWeight: FontWeight.w600, 
                            color: Color(0xFFEF4444)
                          )
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
            child: Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          ),
          SizedBox(height: 24),
          Text("No Donors Found", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[800])),
          SizedBox(height: 8),
          Text("Try adjusting your filters", style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600])),
        ],
      ),
    );
  }

  void _showBloodTypeSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Blood Type", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 16),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: bloodTypes.map((type) {
                return GestureDetector(
                  onTap: () {
                    setState(() => selectedBloodType = type);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: selectedBloodType == type ? Color(0xFFEF4444) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(type, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: selectedBloodType == type ? Colors.white : Colors.grey[800])),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showCitySheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select City", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 16),
            ...cities.map((city) {
              return GestureDetector(
                onTap: () {
                  setState(() => selectedCity = city);
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[200]!))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(city, style: GoogleFonts.poppins(fontSize: 14, fontWeight: selectedCity == city ? FontWeight.w600 : FontWeight.normal)),
                      if (selectedCity == city) Icon(Icons.check, color: Color(0xFFEF4444)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Filter Donors", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 20),
            _filterOption("Blood Type", selectedBloodType, _showBloodTypeSheet),
            SizedBox(height: 12),
            _filterOption("City", selectedCity, _showCitySheet),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFEF4444),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text("Apply Filters", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterOption(String title, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50], borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                SizedBox(height: 4),
                Text(value, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
              ],
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}