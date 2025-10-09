import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import '../services/voucher_service.dart';
import '../services/waste_records_service.dart';
import 'common_providers.dart';

final userServiceProvider = Provider<UserService>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final firestore = ref.watch(firebaseFirestoreProvider);
  final wasteRecordsService = ref.watch(wasteRecordsServiceProvider);
  final voucherService = ref.watch(voucherServiceProvider);

  return UserService(
    auth: auth,
    firestore: firestore,
    wasteRecordsService: wasteRecordsService,
    voucherService: voucherService,
  );
});

final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final userService = ref.watch(userServiceProvider);
  return userService.fetchFullUser();
});

final currentUserStreamProvider = StreamProvider<UserModel?>((ref) {
  final userService = ref.watch(userServiceProvider);
  return userService.watchFullUser();
});
