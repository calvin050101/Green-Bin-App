import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import '../services/user_service.dart';
import '../services/voucher_service.dart';
import '../services/waste_records_service.dart';

/// Firebase singletons
final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);
final firebaseFirestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

/// Current user with profile + records
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final userService = ref.watch(userServiceProvider);
  final wasteRecordsService = ref.watch(wasteRecordsServiceProvider);

  final user = userService.currentUser;
  if (user == null) return null;

  final docSnapshot = await userService.getUserData();
  if (!docSnapshot.exists) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      totalPoints: 0,
      totalCarbonSaved: 0,
      records: [],
      redeemedVouchers: [],
    );
  }

  var userModel = UserModel.fromFirestore(docSnapshot, user.uid);
  final records = await wasteRecordsService.getUserRecords(user.uid);

  return userModel.copyWith(records: records);
});

/// Real-time stream of user + records
final currentUserStreamProvider = StreamProvider<UserModel?>((ref) {
  final profile = ref.watch(userServiceProvider);
  final recordsService = ref.watch(wasteRecordsServiceProvider);
  final vouchersService = ref.watch(voucherServiceProvider);

  final user = profile.currentUser;
  if (user == null) return Stream.value(null);

  final userDocStream = profile.watchUserData(user.uid);

  return userDocStream.asyncMap((docSnapshot) async {
    if (!docSnapshot.exists) {
      return UserModel(
        uid: user.uid,
        email: user.email,
        totalPoints: 0,
        totalCarbonSaved: 0,
        records: [],
        redeemedVouchers: [],
      );
    }

    var userModel = UserModel.fromFirestore(docSnapshot, user.uid);

    final records = await recordsService.getUserRecords(user.uid);
    final redeemedVouchers = await vouchersService.getRedeemedVouchers(user.uid);

    return userModel.copyWith(
      records: records,
      redeemedVouchers: redeemedVouchers,
    );
  });
});


