import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final userService = ref.watch(userServiceProvider);
  return userService.fetchFullUser();
});

// Real-time stream of user + records
final currentUserStreamProvider = StreamProvider<UserModel?>((ref) {
  final userService = ref.watch(userServiceProvider);
  return userService.watchFullUser();
});
