import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmergencyRequestPage extends StatefulWidget {
  const EmergencyRequestPage({Key? key}) : super(key: key);

  @override
  State<EmergencyRequestPage> createState() => _EmergencyRequestPageState();
}

class _EmergencyRequestPageState extends State<EmergencyRequestPage> {
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _hospitalController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String selectedBloodType = "";
  String selectedUrgency = "High";
  bool isLoading = false;

  final List<String> bloodTypes = ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"];
  final List<String> urgencyLevels = ["High", "Medium", "Critical"];

  @override
  void dispose() {
    _patientNameController.dispose();
    _hospitalController.dispose();
    _contactController.dispose();
    _messageController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _showMessage(String message, {bool isError = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: isError ? Colors.red : Colors.green,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: GoogleFonts.poppins(
                color: const Color(0xFFFF5252),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitRequest() async {
    // Validation
    if (selectedBloodType.isEmpty) {
      _showMessage("Please select a blood type!", isError: true);
      return;
    }

    if (_patientNameController.text.trim().isEmpty) {
      _showMessage("Please enter patient name!", isError: true);
      return;
    }

    if (_hospitalController.text.trim().isEmpty) {
      _showMessage("Please enter hospital name!", isError: true);
      return;
    }

    if (_contactController.text.trim().isEmpty) {
      _showMessage("Please enter contact number!", isError: true);
      return;
    }

    if (_contactController.text.trim().length < 11) {
      _showMessage("Please enter a valid contact number!", isError: true);
      return;
    }

    if (_locationController.text.trim().isEmpty) {
      _showMessage("Please enter location!", isError: true);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Save to Firestore
      await FirebaseFirestore.instance.collection('emergency_requests').add({
        'patientName': _patientNameController.text.trim(),
        'bloodType': selectedBloodType,
        'hospital': _hospitalController.text.trim(),
        'contact': _contactController.text.trim(),
        'location': _locationController.text.trim(),
        'urgency': selectedUrgency,
        'message': _messageController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending',
        'createdAt': DateTime.now().toIso8601String(),
      });

      setState(() {
        isLoading = false;
      });

      _showMessage("Emergency request sent successfully!");

      // Clear form
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showMessage("Failed to send request. Please try again!", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder roundedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header updated with requested colors
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFEF4444), // Bright red
                    Color(0xFFDC2626), // Dark red
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Emergency Request',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Fill the form below to send an emergency blood request',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.9),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Blood Type Selection
                    Text(
                      'Blood Type Required',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: bloodTypes.map((type) {
                        bool isSelected = selectedBloodType == type;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedBloodType = type;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFFF5252)
                                  : const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFFF5252)
                                    : Colors.grey[300]!,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              type,
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Patient Name
                    Text(
                      'Patient Name',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _patientNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter patient name',
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: Color(0xFFFF5252),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        border: roundedBorder,
                        enabledBorder: roundedBorder,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFFF5252),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Hospital Name
                    Text(
                      'Hospital Name',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _hospitalController,
                      decoration: InputDecoration(
                        hintText: 'Enter hospital name',
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.local_hospital_outlined,
                          color: Color(0xFFFF5252),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        border: roundedBorder,
                        enabledBorder: roundedBorder,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFFF5252),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Location
                    Text(
                      'Location',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        hintText: 'Enter city/area',
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.location_on_outlined,
                          color: Color(0xFFFF5252),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        border: roundedBorder,
                        enabledBorder: roundedBorder,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFFF5252),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Contact Number
                    Text(
                      'Contact Number',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _contactController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: '03XX XXXXXXX',
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.phone_outlined,
                          color: Color(0xFFFF5252),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        border: roundedBorder,
                        enabledBorder: roundedBorder,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFFF5252),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Urgency Level
                    Text(
                      'Urgency Level',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: urgencyLevels.map((level) {
                        bool isSelected = selectedUrgency == level;
                        Color getColor() {
                          if (level == "Critical") return Colors.red[700]!;
                          if (level == "High") return const Color(0xFFFF5252);
                          return Colors.orange;
                        }

                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedUrgency = level;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? getColor()
                                      : const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected
                                        ? getColor()
                                        : Colors.grey[300]!,
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    level,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          isSelected ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Additional Message
                    Text(
                      'Additional Message (Optional)',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _messageController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Any additional details...',
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        border: roundedBorder,
                        enabledBorder: roundedBorder,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFFF5252),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submitRequest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF5252),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                          disabledBackgroundColor: Colors.grey[400],
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.send, color: Colors.white, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Send Emergency Request',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Info Box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFFFB74D),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Color(0xFFFF9800),
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Your emergency request will be visible to all registered donors in your area. Please ensure all information is accurate.',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: const Color(0xFFE65100),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}