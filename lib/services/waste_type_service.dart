import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_bin/models/waste_type_model.dart';

// Provides the WasteTypeService instance
final wasteTypeServiceProvider = Provider<WasteTypeService>((ref) {
  return WasteTypeService();
});

// Provides a stream of waste types
final wasteTypesStreamProvider = StreamProvider<List<WasteTypeModel>>((ref) {
  final service = ref.watch(wasteTypeServiceProvider);
  return service.streamWasteTypes();
});

class WasteTypeService {
  final FirebaseFirestore _firestore;

  WasteTypeService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get waste types
  Stream<List<WasteTypeModel>> streamWasteTypes() {
    return _firestore.collection("wasteTypes").snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => WasteTypeModel.fromFirestore(doc))
          .toList();
    });
  }
}
