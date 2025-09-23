import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_bin/providers/user_provider.dart';

import '../models/record_model.dart';
import '../services/waste_records_service.dart';

final wasteRecordsServiceProvider = Provider<WasteRecordsService>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return WasteRecordsService(firestore: firestore, ref: ref);
});

/// Real-time stream of user’s records
final userRecordsStreamProvider =
StreamProvider.family<List<RecordModel>, String>((ref, userId) {
  final wasteRecordsService = ref.watch(wasteRecordsServiceProvider);
  return wasteRecordsService.watchUserRecords(userId);
});