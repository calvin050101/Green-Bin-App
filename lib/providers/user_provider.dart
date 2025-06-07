import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);
final firebaseFirestoreProvider = Provider((ref) => FirebaseFirestore.instance);

final userStreamProvider = StreamProvider<UserModel?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final firestore = ref.watch(firebaseFirestoreProvider);

  return auth.authStateChanges().asyncMap((user) async {
    if (user == null) {
      return null;
    }

    final docSnapshot = await firestore.collection('users').doc(user.uid).get();

    if (docSnapshot.exists) {
      return UserModel.fromFirestore(docSnapshot.data()!, user.uid);
    } else {
      print('User document not found for UID: ${user.uid}');
      return UserModel(uid: user.uid, email: user.email, points: 0);
    }
  });
});

final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final auth = ref.watch(firebaseAuthProvider);
  final firestore = ref.watch(firebaseFirestoreProvider);

  final user = auth.currentUser;
  if (user == null) {
    return null;
  }

  final docSnapshot = await firestore.collection('users').doc(user.uid).get();

  if (docSnapshot.exists) {
    return UserModel.fromFirestore(docSnapshot.data()!, user.uid);
  } else {
    print('User document not found for UID: ${user.uid}');
    return UserModel(uid: user.uid, email: user.email, points: 0);
  }
});

final userProfileServiceProvider = Provider((ref) {
  return UserProfileService(ref);
});

class UserProfileService {
  final Ref _ref;
  UserProfileService(this._ref);

  FirebaseAuth get _auth => _ref.read(firebaseAuthProvider);
  FirebaseFirestore get _firestore => _ref.read(firebaseFirestoreProvider);

  // --- Main Update Function ---
  Future<void> updateUserData({
    String? newUsername,
    String? newEmail,
    int? points
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception("No user is currently signed in to update.");
    }

    // --- 1. Update Firebase Authentication Profile ---
    if (newUsername != null) {
      await currentUser.updateProfile(
        displayName: newUsername,
      );
      await currentUser.reload();
    }

    // --- 2. Update Firestore User Document ---
    Map<String, dynamic> firestoreUpdates = {};
    if (newUsername != null) {
      firestoreUpdates['username'] = newUsername;
    }

    if (firestoreUpdates.isNotEmpty) {
      await _firestore.collection("users").doc(currentUser.uid).update(firestoreUpdates);
    }

    // --- 3. Update Subcollections (if needed) ---
    // if (postId != null && postDataToUpdate != null) {
    //   await _firestore
    //       .collection('users')
    //       .doc(currentUser.uid)
    //       .collection('posts')
    //       .doc(postId)
    //       .update(postDataToUpdate);
    // }

    // --- 4. Refresh Riverpod Provider ---
    // This is the CRUCIAL step to update the UI
    // Invalidate the provider that fetches the user data.
    // This forces Riverpod to re-fetch the data from Firestore,
    // and all widgets watching this provider will rebuild with the new data.
    _ref.invalidate(currentUserProvider);
  }
}