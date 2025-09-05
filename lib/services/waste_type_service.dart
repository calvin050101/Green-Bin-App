import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_bin/models/waste_type_model.dart';

/// Provides the WasteTypeService instance
final wasteTypeServiceProvider = Provider<WasteTypeService>((ref) {
  return WasteTypeService();
});

class WasteTypeService {
  final FirebaseFirestore _firestore;

  WasteTypeService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _collection =>
      _firestore.collection("wasteTypes");

  /// Get all waste types once
  Future<List<WasteTypeModel>> fetchWasteTypes() async {
    final snapshot = await _collection.get();
    return snapshot.docs
        .map((doc) => WasteTypeModel.fromFirestore(doc))
        .toList();
  }

  /// Get waste types as a stream (for real-time updates)
  Stream<List<WasteTypeModel>> streamWasteTypes() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => WasteTypeModel.fromFirestore(doc))
          .toList();
    });
  }

  /// Get a single waste type by ID
  Future<WasteTypeModel?> getWasteTypeById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return WasteTypeModel.fromFirestore(doc);
  }
}
