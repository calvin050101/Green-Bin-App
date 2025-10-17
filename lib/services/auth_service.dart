import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_bin/services/user_service.dart';

import '../providers/common_providers.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return AuthService(auth: auth);
});

final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthService({FirebaseAuth? auth})
    : _auth = auth ?? FirebaseAuth.instance;

  // Auth
  User? get currentUser => _auth.currentUser;
  FirebaseAuth get auth => _auth;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

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
    if (user == null) throw AuthServiceException("Login failed.");

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
    if (user == null) throw AuthServiceException("User creation failed.");

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
    if (user == null) throw AuthServiceException("No user logged in");

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
    ref.invalidate(authServiceProvider);
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
    if (user == null) throw AuthServiceException("No user logged in.");
    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw AuthServiceException("No user logged in");

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
}

class AuthServiceException {
  final String message;
  AuthServiceException(this.message);

  @override
  String toString() => 'AuthServiceException: $message';
}
