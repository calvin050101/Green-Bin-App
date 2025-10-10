import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_bin/services/voucher_service.dart';
import 'package:green_bin/services/waste_records_service.dart';

import '../models/user_model.dart';
import '../providers/common_providers.dart';

final userServiceProvider = Provider<UserService>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return UserService(auth: auth, ref: ref);
});

class UserService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Ref _ref;

  UserService({FirebaseAuth? auth, required Ref ref})
    : _auth = auth ?? FirebaseAuth.instance,
      _ref = ref;

  // Auth
  User? get currentUser => _auth.currentUser;

  FirebaseAuth get auth => _auth;

  // Login
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) throw Exception("Login failed.");

    return credential;
  }

  // Create Account
  Future<UserCredential> createAccount({
    required String email,
    required String password,
    required String username,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) throw Exception("User creation failed.");

    // Create Firestore profile
    await _firestore.collection("users").doc(user.uid).set({
      "username": username,
      "email": email,
      "totalPoints": 0,
      "totalCarbonSaved": 0,
    });

    await user.updateDisplayName(username);
    await user.reload();

    return credential;
  }

  // Update Username
  Future<void> updateUsername(String newUsername) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No user logged in");

    // Update Firestore profile
    await _firestore.collection("users").doc(user.uid).update({
      "username": newUsername,
    });

    // Optionally update FirebaseAuth displayName
    await user.updateDisplayName(newUsername);
    await user.reload();
  }

  Future<void> signOut(WidgetRef ref) async {
    await _auth.signOut();
    ref.invalidate(userServiceProvider);
  }

  Future<void> resetPassword({
    required String currentPassword,
    required String newPassword,
    required String email,
  }) async {
    final credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );
    final user = currentUser;
    if (user == null) throw Exception("No user logged in.");
    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No user logged in");

    // Reauthenticate before deleting
    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await user.reauthenticateWithCredential(credential);

    // Delete user document from Firestore
    await _firestore.collection("users").doc(user.uid).delete();

    // Delete from FirebaseAuth
    await user.delete();
  }

  // Returns one-time user data merged with records & vouchers
  Future<UserModel?> fetchFullUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection("users").doc(user.uid).get();
    final wasteRecordsService = _ref.watch(wasteRecordsServiceProvider);
    final voucherService = _ref.watch(voucherServiceProvider);

    final baseUser =
        doc.exists
            ? UserModel.fromFirestore(doc, user.uid)
            : UserModel(
              uid: user.uid,
              email: user.email,
              totalPoints: 0,
              totalCarbonSaved: 0,
              records: [],
              redeemedVouchers: [],
            );

    final records = await wasteRecordsService.getUserRecords(user.uid);
    final redeemedVouchers = await voucherService.getRedeemedVouchers(user.uid);

    return baseUser.copyWith(
      records: records,
      redeemedVouchers: redeemedVouchers,
    );
  }

  // Returns a stream of user data merged with records & vouchers
  Stream<UserModel?> watchFullUser() async* {
    // Wait until FirebaseAuth emits a valid (non-null) user
    final user = await _auth.authStateChanges().firstWhere(
      (u) => u != null && u.emailVerified,
    );

    // Refresh ID token to ensure Firestore rules are valid
    await user!.getIdToken(true);

    final userDocStream =
        _firestore.collection("users").doc(user.uid).snapshots();

    final wasteRecordsService = _ref.watch(wasteRecordsServiceProvider);
    final voucherService = _ref.watch(voucherServiceProvider);

    yield* userDocStream.asyncMap((doc) async {
      final baseUser =
          doc.exists
              ? UserModel.fromFirestore(doc, user.uid)
              : UserModel(
                uid: user.uid,
                email: user.email,
                totalPoints: 0,
                totalCarbonSaved: 0,
                records: [],
                redeemedVouchers: [],
              );

      final records = await wasteRecordsService.getUserRecords(user.uid);
      final redeemedVouchers = await voucherService.getRedeemedVouchers(
        user.uid,
      );

      return baseUser.copyWith(
        records: records,
        redeemedVouchers: redeemedVouchers,
      );
    });
  }
}
