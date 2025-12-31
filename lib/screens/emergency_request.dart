// emergency_request_page.dart
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class EmergencyRequestPage extends StatefulWidget {
  const EmergencyRequestPage({Key? key}) : super(key: key);

  @override
  _EmergencyRequestPageState createState() => _EmergencyRequestPageState();
}

class _EmergencyRequestPageState extends State<EmergencyRequestPage> {
  final _formKey = GlobalKey<FormState>();
  String patientName = '';
  String bloodGroup = '';
  String contactNumber = '';
  String location = '';
  String message = '';
  bool submitted = false;

  final List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  void handleSubmit() {
    if (_formKey.currentState!.validate() && bloodGroup.isNotEmpty) {
      setState(() {
        submitted = true;
      });
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          submitted = false;
          patientName = '';
          bloodGroup = '';
          contactNumber = '';
          location = '';
          message = '';
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 400, minHeight: 600),
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red.shade500, Colors.red.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(LucideIcons.arrowLeft, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Emergency Request',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Send urgent blood request to nearby donors',
                      style: TextStyle(color: Colors.red.shade100, fontSize: 14),
                    ),
                  ],
                ),
              ),

              // Alert Banner
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.orange.shade200)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(LucideIcons.alertCircle, color: Colors.orange.shade500),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Important Notice',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orange.shade800),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Your request will be sent to all matching donors in your area. Please ensure all details are accurate.',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.orange.shade700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Form / Success Message
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: submitted
                      ? _successMessage()
                      : Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                _buildTextField(
                                    label: 'Patient Name',
                                    icon: LucideIcons.user,
                                    value: patientName,
                                    onChanged: (val) => patientName = val,
                                    validator: (val) =>
                                        val!.isEmpty ? 'Required' : null),
                                SizedBox(height: 12),
                                _buildBloodGroupSelector(),
                                SizedBox(height: 12),
                                _buildTextField(
                                    label: 'Contact Number',
                                    icon: LucideIcons.phone,
                                    value: contactNumber,
                                    onChanged: (val) => contactNumber = val,
                                    keyboardType: TextInputType.phone,
                                    validator: (val) =>
                                        val!.isEmpty ? 'Required' : null),
                                SizedBox(height: 12),
                                _buildTextField(
                                    label: 'Hospital/Location',
                                    icon: LucideIcons.mapPin,
                                    value: location,
                                    onChanged: (val) => location = val,
                                    validator: (val) =>
                                        val!.isEmpty ? 'Required' : null),
                                SizedBox(height: 12),
                                _buildTextField(
                                  label: 'Additional Message',
                                  icon: LucideIcons.droplet,
                                  value: message,
                                  onChanged: (val) => message = val,
                                  maxLines: 4,
                                  validator: (_) => null,
                                ),
                                SizedBox(height: 16),
                                ElevatedButton.icon(
                                  icon: Icon(LucideIcons.send),
                                  label: Text('Send Emergency Request'),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: handleSubmit,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'By sending this request, you confirm that all information provided is accurate.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey[600]),
                                ),
                                SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                ),
              ),

              // Footer Stats
              if (!submitted)
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.grey.shade200)),
                      color: Colors.grey.shade50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text('24/7',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          Text('Service Available',
                              style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      Column(
                        children: [
                          Text('<10min',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          Text('Avg Response Time',
                              style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required String value,
    required Function(String) onChanged,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700])),
        SizedBox(height: 4),
        TextFormField(
          initialValue: value,
          onChanged: onChanged,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBloodGroupSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Required Blood Group',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700])),
        SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: bloodGroups.map((group) {
            bool selected = bloodGroup == group;
            return ChoiceChip(
              label: Text(group,
                  style: TextStyle(
                      color: selected ? Colors.white : Colors.grey[700],
                      fontWeight: FontWeight.w600)),
              selected: selected,
              selectedColor: Colors.red,
              backgroundColor: Colors.grey[50],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade200)),
              onSelected: (_) {
                setState(() {
                  bloodGroup = group;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _successMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  color: Colors.green.shade100, shape: BoxShape.circle),
              child: Icon(Icons.check, size: 40, color: Colors.green.shade500),
            ),
            SizedBox(height: 16),
            Text('Request Sent!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              'Your emergency request has been sent to nearby donors with $bloodGroup blood type.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700]),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Next Steps:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade800)),
                  SizedBox(height: 6),
                  Text('• Donors will be notified immediately', style: TextStyle(color: Colors.green.shade700)),
                  Text('• Keep your phone accessible', style: TextStyle(color: Colors.green.shade700)),
                  Text('• Donors will contact you directly', style: TextStyle(color: Colors.green.shade700)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
