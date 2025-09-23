import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_bin/providers/user_provider.dart';
import 'package:green_bin/services/user_service.dart';

import '../models/record_model.dart';
import '../models/waste_type_model.dart';

final wasteRecordsServiceProvider = Provider<WasteRecordsService>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return WasteRecordsService(firestore: firestore, ref: ref);
});

class WasteRecordsService {
  final FirebaseFirestore _firestore;
  final Ref _ref;

  WasteRecordsService({FirebaseFirestore? firestore, required Ref ref})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _ref = ref;

  Future<List<RecordModel>> getUserRecords(String uid) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('records')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => RecordModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  Stream<List<RecordModel>> watchUserRecords(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('records')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
          snapshot.docs
              .map((doc) => RecordModel.fromFirestore(doc.data(), doc.id))
              .toList(),
    );
  }

  Future<void> addWasteRecord({
    required WasteTypeModel wasteType,
    required double weight, // in kg
  }) async {
    final user = _ref.watch(userServiceProvider);

    final userDocRef = _firestore.collection('users').doc(user.currentUser?.uid);
    final recordsRef = userDocRef.collection('records').doc();

    final newRecord = RecordModel(
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