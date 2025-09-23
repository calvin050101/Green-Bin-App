import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import '../services/user_service.dart';
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
    );
  }

  var userModel = UserModel.fromFirestore(docSnapshot.data()!, user.uid);
  final records = await wasteRecordsService.getUserRecords(user.uid);

  return userModel.copyWith(records: records);
});
