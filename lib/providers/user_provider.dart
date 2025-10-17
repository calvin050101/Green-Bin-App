import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_bin/services/user_service.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final userService = ref.watch(userServiceProvider);
  return userService.fetchFullUser();
});

// Real-time stream of user + records
final currentUserStreamProvider = StreamProvider<UserModel?>((ref) {
  final authState = ref.watch(authStateProvider).value;
  if (authState == null) return const Stream.empty();

  final userService = ref.watch(userServiceProvider);
  return userService.watchFullUser(authState.uid);
});