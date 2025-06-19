import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/record_model.dart';
import '../providers/user_provider.dart';

class UserProfileService {
  final Ref _ref;

  UserProfileService(this._ref);

  FirebaseAuth get _auth => _ref.read(firebaseAuthProvider);

  FirebaseFirestore get _firestore => _ref.read(firebaseFirestoreProvider);

  // --- Main Update Function ---
  Future<void> updateUserData({
    String? newUsername,
    int? points,
    List<RecordModel>? records,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception("No user is currently signed in to update.");
    }

    if (newUsername != null) {
      await currentUser.updateProfile(displayName: newUsername);
      await currentUser.reload();
    }

    Map<String, dynamic> firestoreUpdates = {};
    if (newUsername != null) {
      firestoreUpdates['username'] = newUsername;
    }

    if (firestoreUpdates.isNotEmpty) {
      await _firestore
          .collection("users")
          .doc(currentUser.uid)
          .update(firestoreUpdates);
    }

    _ref.invalidate(currentUserProvider);
  }

  // New method to add a waste record
  Future<void> addWasteRecord({required String wasteType}) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception("No user is currently signed in to add a record.");
    }

    final newRecord = RecordModel(
      id:
          _firestore
              .collection('users')
              .doc(currentUser.uid)
              .collection('records')
              .doc()
              .id,
      timestamp: DateTime.now(),
      wasteType: wasteType,
    );

    await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('records')
        .doc(newRecord.id)
        .set(newRecord.toFirestore());

    _ref.invalidate(currentUserProvider);
  }
}
