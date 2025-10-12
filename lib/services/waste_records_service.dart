import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/record_model.dart';
import '../models/waste_type_model.dart';

final wasteRecordsServiceProvider = Provider<WasteRecordsService>((ref) {
  return WasteRecordsService();
});

final userRecordsStreamProvider =
    StreamProvider.family<List<WasteRecord>, String>((ref, userId) {
      final wasteRecordsService = ref.watch(wasteRecordsServiceProvider);
      return wasteRecordsService.watchUserRecords(userId);
    });

class WasteRecordsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream of Waste Records
  Stream<List<WasteRecord>> watchUserRecords(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('records')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => WasteRecord.fromFirestore(doc))
                  .toList(),
        );
  }

  Future<void> addWasteRecord({
    required WasteTypeModel wasteType,
    required double weight, // in kg
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    final userDocRef = _firestore.collection('users').doc(user?.uid);
    final recordsRef = userDocRef.collection('records').doc();

    final newRecord = WasteRecord(
      id: recordsRef.id,
      timestamp: DateTime.now(),
      wasteType: wasteType.label,
      weight: weight,
    );

    await _firestore.runTransaction((transaction) async {
      final userDoc = await transaction.get(userDocRef);
      final data = userDoc.data() ?? {};

      final currentPoints = (data['totalPoints'] ?? 0) as int;
      final currentCarbon = (data['totalCarbonSaved'] ?? 0.0).toDouble();

      final earnedPoints = (wasteType.pointsPerKg * weight).round();
      final savedCarbon = wasteType.carbonPerKg * weight;

      // Add record
      transaction.set(recordsRef, newRecord.toFirestore());

      // Update totals
      transaction.update(userDocRef, {
        'totalPoints': currentPoints + earnedPoints,
        'totalCarbonSaved': currentCarbon + savedCarbon,
      });
    });
  }
}
