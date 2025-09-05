import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/record_model.dart';
import '../models/user_model.dart';
import '../services/user_profile_service.dart';

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);
final firebaseFirestoreProvider = Provider((ref) => FirebaseFirestore.instance);

final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final auth = ref.watch(firebaseAuthProvider);
  final firestore = ref.watch(firebaseFirestoreProvider);

  final user = auth.currentUser;
  if (user == null) {
    return null;
  }

  final docSnapshot = await firestore.collection('users').doc(user.uid).get();

  if (!docSnapshot.exists) {
    return UserModel(
        uid: user.uid,
        email: user.email,
        totalPoints: 0,
        totalCarbonSaved: 0,
        records: []
    );
  }

  UserModel userModel = UserModel.fromFirestore(docSnapshot.data()!, user.uid);

  // --- Fetch the 'records' subcollection ---
  final recordsSnapshot =
      await firestore
          .collection('users')
          .doc(user.uid)
          .collection('records')
          .orderBy('timestamp', descending: true)
          .get();

  List<RecordModel> records =
      recordsSnapshot.docs
          .map((doc) => RecordModel.fromFirestore(doc.data(), doc.id))
          .toList();
  userModel = userModel.copyWith(records: records);

  return userModel;
});

final userRecordsStreamProvider =
    StreamProvider.family<List<RecordModel>, String>((ref, userId) {
      final firestore = ref.watch(firebaseFirestoreProvider);
      return firestore
          .collection('users')
          .doc(userId)
          .collection('records')
          .orderBy('timestamp', descending: true) // Order as desired
          .snapshots() // Get real-time updates
          .map(
            (snapshot) =>
                snapshot.docs
                    .map((doc) => RecordModel.fromFirestore(doc.data(), doc.id))
                    .toList(),
          );
    });

final userProfileServiceProvider = Provider((ref) {
  return UserProfileService(ref);
});
