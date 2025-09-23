import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/record_model.dart';
import '../models/waste_type_model.dart';
import '../providers/user_provider.dart';

/// UserService wrapper
final userServiceProvider = Provider<UserService>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return UserService(auth: auth, ref: ref);
});

class UserService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final Ref? _ref;

  UserService({FirebaseAuth? auth, FirebaseFirestore? firestore, Ref? ref})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance,
      _ref = ref;

  /// ---------------- AUTH ----------------

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> login({
    required String email,
    required String password,
  }) => _auth.signInWithEmailAndPassword(email: email, password: password);

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

  /// ---------------- FIRESTORE PROFILE ----------------

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() {
    final user = currentUser;
    if (user == null) throw Exception("No user logged in.");
    return _firestore.collection("users").doc(user.uid).get();
  }

  /// ---------------- RECORDS ----------------

  Future<List<RecordModel>> getUserRecords(String uid) async {
    final snapshot =
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('records')
            .orderBy('timestamp', descending: true)
            .get();

    return snapshot.docs
        .map((doc) => RecordModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  Future<void> addWasteRecord({
    required WasteTypeModel wasteType,
    required double weight, // in kg
  }) async {
    final user = currentUser;
    if (user == null) throw Exception("No user is currently signed in.");

    final userDocRef = _firestore.collection('users').doc(user.uid);
    final recordsRef = userDocRef.collection('records').doc();

    final newRecord = RecordModel(
      id: recordsRef.id,
      timestamp: DateTime.now(),
      wasteType: wasteType.label,
      weight: weight,
    );

    await _firestore.runTransaction((transaction) async {
      final userDoc = await transaction.get(userDocRef);
      final data = userDoc.data() ?? {};

      final currentPoints = (data['totalPoints'] ?? 0) as int;
      final currentCarbon = (data['totalCarbonSaved'] ?? 0.0).toDouble();

      final earnedPoints = (wasteType.pointsPerKg * weight).round();
      final savedCarbon = wasteType.carbonPerKg * weight;

      // Add record
      transaction.set(recordsRef, newRecord.toFirestore());

      // Update totals
      transaction.update(userDocRef, {
        'totalPoints': currentPoints + earnedPoints,
        'totalCarbonSaved': currentCarbon + savedCarbon,
      });
    });

    _ref?.invalidate(currentUserProvider);
  }
}
