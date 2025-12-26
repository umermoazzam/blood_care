import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About")),
      body: const Padding(
        padding: EdgeInsets.all(25),
        child: Text(
          "Blood Care App helps people find blood donors quickly.\n\n"
          "Users can find donors, become donors, and send emergency requests.\n\n"
          "This app is designed for fast, easy, and lifesaving communication.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
