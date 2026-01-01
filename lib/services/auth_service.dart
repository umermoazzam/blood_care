// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   // ✅ FIXED: GoogleSignIn instance ko class level par define kiya with serverClientId
//   // IMPORTANT: Ye Web Client ID aapki google-services.json file mein hai
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     scopes: ['email'],
//     // 🔥 CRITICAL: Ye Web client ID hai jo google-services.json mein "client_type": 3 ke under hai
//     serverClientId: '241745573264-gbdjk3pr983v94hg9nl5n4f2esa778vt.apps.googleusercontent.com',
//   );

//   // Get current user
//   User? get currentUser => _auth.currentUser;

//   // Auth state changes stream
//   Stream<User?> get authStateChanges => _auth.authStateChanges();

//   Future<User?> signInWithGoogle() async {
//     try {
//       if (kIsWeb) {
//         // ===== Web Sign-In =====
//         print("🌐 Starting Web Google Sign-In...");
//         GoogleAuthProvider googleProvider = GoogleAuthProvider();
//         googleProvider.addScope('email');
        
//         UserCredential userCredential = await _auth.signInWithPopup(googleProvider);
//         print("✅ Web Sign-In Successful: ${userCredential.user?.email}");
//         return userCredential.user;
//       } else {
//         // ===== Mobile Sign-In =====
//         print("📱 Starting Mobile Google Sign-In...");
        
//         // Sign out pehle existing session clear karne ke liye
//         await _googleSignIn.signOut();
        
//         final googleUser = await _googleSignIn.signIn();
        
//         if (googleUser == null) {
//           print("❌ User cancelled sign-in");
//           return null;
//         }

//         print("✅ Google User obtained: ${googleUser.email}");

//         final googleAuth = await googleUser.authentication;
        
//         print("🔑 Access Token exists: ${googleAuth.accessToken != null}");
//         print("🔑 ID Token exists: ${googleAuth.idToken != null}");

//         if (googleAuth.accessToken == null || googleAuth.idToken == null) {
//           print("❌ Missing authentication tokens");
//           return null;
//         }

//         final credential = GoogleAuthProvider.credential(
//           accessToken: googleAuth.accessToken,
//           idToken: googleAuth.idToken,
//         );

//         print("🔐 Signing in with Firebase credential...");
//         final userCredential = await _auth.signInWithCredential(credential);
        
//         print("✅ Firebase Sign-In Successful!");
//         print("👤 User: ${userCredential.user?.email}");
//         print("🆔 UID: ${userCredential.user?.uid}");
        
//         return userCredential.user;
//       }
//     } on FirebaseAuthException catch (e) {
//       print("❌ FirebaseAuthException occurred");
//       print("📝 Code: ${e.code}");
//       print("📝 Message: ${e.message}");
//       print("📝 Plugin: ${e.plugin}");
      
//       // Common error codes with solutions
//       if (e.code == 'network-request-failed') {
//         print("💡 Solution: Check internet connection");
//       } else if (e.code == 'invalid-credential') {
//         print("💡 Solution: Check SHA-1 keys in Firebase Console");
//       } else if (e.code == 'operation-not-allowed') {
//         print("💡 Solution: Enable Google Sign-In in Firebase Console");
//       }
      
//       return null;
//     } catch (e, stackTrace) {
//       print("❌ General Exception occurred");
//       print("📝 Error: $e");
//       print("📝 Type: ${e.runtimeType}");
//       print("📝 Stack Trace: $stackTrace");
//       return null;
//     }
//   }

//   // Email/Password Sign-In
//   Future<User?> signInWithEmailPassword(String email, String password) async {
//     try {
//       print("📧 Starting Email/Password Sign-In...");
//       final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       print("✅ Email Sign-In Successful: ${userCredential.user?.email}");
//       return userCredential.user;
//     } on FirebaseAuthException catch (e) {
//       print("❌ Email Sign-In Error: ${e.code} - ${e.message}");
//       return null;
//     }
//   }

//   // Email/Password Sign-Up
//   Future<User?> signUpWithEmailPassword(String email, String password) async {
//     try {
//       print("📝 Starting Email/Password Sign-Up...");
//       final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       print("✅ Sign-Up Successful: ${userCredential.user?.email}");
//       return userCredential.user;
//     } on FirebaseAuthException catch (e) {
//       print("❌ Sign-Up Error: ${e.code} - ${e.message}");
//       return null;
//     }
//   }

//   // Sign Out Function
//   Future<void> signOut() async {
//     try {
//       print("🚪 Signing out...");
//       await _googleSignIn.signOut();
//       await _auth.signOut();
//       print("✅ Sign-out successful");
//     } catch (e) {
//       print("❌ Error signing out: $e");
//     }
//   }

//   // Check if user is signed in
//   bool isSignedIn() {
//     final isSignedIn = _auth.currentUser != null;
//     print("🔍 User signed in: $isSignedIn");
//     return isSignedIn;
//   }

//   // Get user email
//   String? getUserEmail() {
//     return _auth.currentUser?.email;
//   }

//   // Get user display name
//   String? getUserName() {
//     return _auth.currentUser?.displayName;
//   }

//   // Get user photo URL
//   String? getUserPhotoUrl() {
//     return _auth.currentUser?.photoURL;
//   }
// }