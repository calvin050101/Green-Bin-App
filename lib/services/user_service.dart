import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_bin/services/voucher_service.dart';
import 'package:green_bin/services/waste_records_service.dart';

import '../models/user_model.dart';

class UserService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final WasteRecordsService _wasteRecordsService;
  final VoucherService _voucherService;

  UserService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    required wasteRecordsService,
    required voucherService,
  }) : _auth = auth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _wasteRecordsService = wasteRecordsService,
       _voucherService = voucherService;

  // Auth
  User? get currentUser => _auth.currentUser;

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

    // Check if email is verified
    if (!user.emailVerified) {
      await _auth.signOut(); // prevent unverified login session
      throw FirebaseAuthException(
        code: "email-not-verified",
        message: "Please verify your email before logging in.",
      );
    }

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

    await user.sendEmailVerification();

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

  Future<void> signOut() => _auth.signOut();

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

  Future<UserModel?> fetchFullUser() async {
    final user = currentUser;
    if (user == null) return null;

    final docSnapshot = await getUserData();
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
    final records = await _wasteRecordsService.getUserRecords(user.uid);
    final redeemedVouchers = await _voucherService.getRedeemedVouchers(
      user.uid,
    );

    return userModel.copyWith(
      records: records,
      redeemedVouchers: redeemedVouchers,
    );
  }

  Stream<UserModel?> watchFullUser() {
    final user = currentUser;
    if (user == null) return Stream.value(null);

    return watchUserData(user.uid).asyncMap((docSnapshot) async {
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
      final records = await _wasteRecordsService.getUserRecords(user.uid);
      final redeemedVouchers = await _voucherService.getRedeemedVouchers(
        user.uid,
      );

      return userModel.copyWith(
        records: records,
        redeemedVouchers: redeemedVouchers,
      );
    });
  }

  // Firestore Profile
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() {
    final user = currentUser;
    if (user == null) throw Exception("No user logged in.");
    return _firestore.collection("users").doc(user.uid).get();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchUserData(String uid) {
    return _firestore.collection("users").doc(uid).snapshots();
  }
}
