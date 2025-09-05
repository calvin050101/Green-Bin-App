import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/record_model.dart';
import '../models/waste_type_model.dart';
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

  /// --- Add Waste Record and update totals ---
  Future<void> addWasteRecord({required WasteTypeModel wasteType}) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception("No user is currently signed in to add a record.");
    }

    final userDocRef = _firestore.collection('users').doc(currentUser.uid);
    final recordsRef = userDocRef.collection('records').doc();

    final newRecord = RecordModel(
      id: recordsRef.id,
      timestamp: DateTime.now(),
      wasteType: wasteType.label,
    );

    await _firestore.runTransaction((transaction) async {
      final userDoc = await transaction.get(userDocRef);

      final currentPoints = userDoc.data()?['totalPoints'] ?? 0;
      final currentCarbon =
          (userDoc.data()?['totalCarbonSaved'] ?? 0.0).toDouble();

      // Add new record
      transaction.set(recordsRef, newRecord.toFirestore());

      // Update totals
      transaction.update(userDocRef, {
        'totalPoints': currentPoints + wasteType.points,
        'totalCarbonSaved': currentCarbon + wasteType.carbonFootprint,
      });
    });

    _ref.invalidate(currentUserProvider);
  }
}
