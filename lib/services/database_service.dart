import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_service.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? currentUser = authService.value.currentUser;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
    return await _firestore.collection("users").doc(currentUser!.uid).get();
  }

  Future<void> createUser({
    required UserCredential? userCredential,
    required String username,
    required String email,
  }) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({"username": username, "email": email, "points": 0});
    }
  }

  Future<void> updateUsername(String newUsername) async {
    await _firestore.collection("users").doc(currentUser!.uid).update({
      "username": newUsername,
    });
  }
}
