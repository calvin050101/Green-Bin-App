import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_bin/models/waste_type_model.dart';
import 'package:green_bin/services/waste_type_service.dart';

/// Provides a stream of waste types
final wasteTypesStreamProvider = StreamProvider<List<WasteTypeModel>>((ref) {
  final service = ref.watch(wasteTypeServiceProvider);
  return service.streamWasteTypes();
});
