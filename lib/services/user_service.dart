import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Fetches the user profile data from Firestore
  Future<Map<String, dynamic>?> getUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return doc.data();
      }
    } catch (e) {
      // In production, consider logging to a service
      debugPrint('Error fetching user profile: $e');
    }
    return null;
  }

  /// Returns the current Firebase Authentication User
  User? getCurrentAuthUser() {
    return _auth.currentUser;
  }
}
