import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/record_model.dart';
import '../services/waste_records_service.dart';

/// Real-time stream of user’s records
final userRecordsStreamProvider =
    StreamProvider.family<List<RecordModel>, String>((ref, userId) {
      final wasteRecordsService = ref.watch(wasteRecordsServiceProvider);
      return wasteRecordsService.watchUserRecords(userId);
    });
