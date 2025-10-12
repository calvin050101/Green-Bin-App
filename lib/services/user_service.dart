import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/record_model.dart';
import '../models/redeemed_vouchers_model.dart';
import '../models/user_model.dart';

final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
});

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> _getUser(String uid) async {
    try {
      final doc = await _firestore.collection("users").doc(uid).get();

      if (!doc.exists) {
        return null;
      }

      return UserModel.fromFirestore(doc, uid);
    } on FirebaseException catch (e) {
      throw UserServiceException('Failed to fetch user: ${e.message}');
    }
  }

  // Stream user profile
  Stream<UserModel?> _watchUser(String uid) {
    return _firestore
        .collection("users")
        .doc(uid)
        .snapshots()
        .map((doc) {
          if (!doc.exists) {
            return null;
          }
          return UserModel.fromFirestore(doc, uid);
        })
        .handleError((error) {
          throw UserServiceException('Failed to stream user: $error');
        });
  }

  // Get User Records
  Future<List<WasteRecord>> _getUserRecords(String uid) async {
    final snapshot =
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('records')
            .orderBy('timestamp', descending: true)
            .get();

    return snapshot.docs.map((doc) => WasteRecord.fromFirestore(doc)).toList();
  }

  Future<List<RedeemedVoucher>> _getRedeemedVouchers(String uid) async {
    final snapshot =
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('redeemedVouchers')
            .get();

    return snapshot.docs
        .map((doc) => RedeemedVoucher.fromFirestore(doc))
        .toList();
  }

  // Get full user data once
  Future<UserModel?> fetchFullUser() async {
    try {
      final uid = _auth.currentUser?.uid;
      final userModel = await _getUser(uid!);

      final records = await _getUserRecords(uid);
      final redeemedVouchers = await _getRedeemedVouchers(uid);

      return userModel?.copyWith(
        records: records,
        redeemedVouchers: redeemedVouchers,
      );
    } catch (e) {
      throw UserServiceException('Failed to fetch full user data: $e');
    }
  }

  // Stream full user data
  Stream<UserModel?> watchFullUser() async* {
    final user = await _auth.authStateChanges().firstWhere(
      (u) => u != null,
    );

    // Refresh ID token to ensure Firestore rules are valid
    await user!.getIdToken(true);

    final uid = user.uid;

    yield* _watchUser(uid).asyncMap((baseUser) async {
      if (baseUser == null) {
        // Return default user with empty records/vouchers if no profile exists
        return UserModel.defaultUser(uid: uid);
      }

      try {
        final records = await _getUserRecords(uid);
        final redeemedVouchers = await _getRedeemedVouchers(uid);

        return baseUser.copyWith(
          records: records,
          redeemedVouchers: redeemedVouchers,
        );
      } catch (e) {
        // Return base user without records/vouchers if aggregation fails
        return baseUser.copyWith(records: const [], redeemedVouchers: const []);
      }
    });
  }
}

class UserServiceException implements Exception {
  final String message;

  UserServiceException(this.message);

  @override
  String toString() => 'UserServiceException: $message';
}
