import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Yeh important hai auto-configuration ke liye
import 'screens/splash_screen.dart';  

void main() async {
  // 1. Flutter engine ko initialize karna zaroori hai
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Firebase ko initialize karein (Aapka current method best hai)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const BloodCareApp());
}

class BloodCareApp extends StatelessWidget {
  const BloodCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blood Care',
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Inter',
      ),
      // Splash screen unchanged rahegi, logic iske baad wali screen par aayega
      home: const SplashScreen(), 
    );
  }
}