import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Only initialize GoogleSignIn for non-web platforms.
  // For web, we will use Firebase's native signInWithPopup to avoid popup_closed and invalid_client issues.
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Stream of auth state changes
  Stream<User?> get authStateChanges {
    return _auth.authStateChanges();
  }

  /// Sign in with email and password
  Future<UserCredential?> signInWithEmailPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  /// Register with email and password
  Future<UserCredential?> registerWithEmailPassword(String email, String password, String name) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      
      // Update the user's display name
      await userCredential.user?.updateDisplayName(name);
      // Reload to ensure the current user object has the updated name
      await userCredential.user?.reload();
      
      final updatedUser = _auth.currentUser;
      await _createUserInFirestore(updatedUser, 'email');
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw e; // Rethrow to let the UI parse specific Firebase errors
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  /// Sign in with Google (Platform Specific)
  Future<UserCredential?> signInWithGoogle() async {
    try {
      debugPrint('--- Starting Google Sign-In ---');
      debugPrint('Firebase Project ID: ${Firebase.app().options.projectId}');
      debugPrint('Firebase Auth Domain: ${Firebase.app().options.authDomain}');
      
      if (kIsWeb) {
        debugPrint('Platform: Web. Using FirebaseAuth signInWithPopup...');
        // Web Implementation: Bypasses google_sign_in plugin completely.
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.addScope('profile');
        googleProvider.setCustomParameters({'prompt': 'select_account'});
        
        final UserCredential userCredential = await _auth.signInWithPopup(googleProvider);
        debugPrint('Web Sign-In Successful for: ${userCredential.user?.email}');
        
        await _createUserInFirestore(userCredential.user, 'google');
        return userCredential;
      } else {
        debugPrint('Platform: Android/iOS. Using google_sign_in plugin...');
        // Mobile Implementation
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        
        if (googleUser == null) {
          debugPrint('Google Sign-In canceled by user.');
          return null; // The user canceled the sign-in
        }
        
        debugPrint('Google user obtained: ${googleUser.email}. Authenticating with Firebase...');
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        
        final UserCredential userCredential = await _auth.signInWithCredential(credential);
        debugPrint('Mobile Sign-In Successful for: ${userCredential.user?.email}');
        
        await _createUserInFirestore(userCredential.user, 'google');
        return userCredential;
      }
    } catch (e) {
      debugPrint('Google Sign-In Error Captured: $e');
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  /// Automatic Firestore user creation
  Future<void> _createUserInFirestore(User? user, String provider) async {
    if (user != null) {
      try {
        final userRef = _firestore.collection('users').doc(user.uid);
        final doc = await userRef.get();
        
        if (!doc.exists) {
          debugPrint('Creating new Firestore user document for UID: ${user.uid}');
          await userRef.set({
            'uid': user.uid,
            'name': user.displayName ?? '',
            'email': user.email ?? '',
            'photoUrl': user.photoURL ?? '',
            'provider': provider,
            'createdAt': FieldValue.serverTimestamp(),
          });
          debugPrint('Firestore document created successfully.');
        } else {
          debugPrint('Firestore user document already exists.');
        }
      } catch (e) {
        debugPrint('Error creating Firestore user: $e');
      }
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      debugPrint('Signing out from GoogleSignIn');
      await GoogleSignIn().signOut();
    } catch (e) {
      debugPrint('Google SignOut Error: $e');
    }
    
    try {
      debugPrint('Signing out of Firebase Auth');
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      debugPrint('Firebase Auth SignOut Error: $e');
    }
    debugPrint('Firebase Auth Signed Out.');
  }
}
