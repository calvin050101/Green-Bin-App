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

  CollectionReference get _collection => _firestore.collection("wasteTypes");

  /// Get waste types
  Stream<List<WasteTypeModel>> streamWasteTypes() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => WasteTypeModel.fromFirestore(doc))
          .toList();
    });
  }
}
