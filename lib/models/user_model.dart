import 'package:green_bin/models/record_model.dart';

class UserModel {
  final String uid;
  final String? email;
  final String? username;
  final List<RecordModel>? records;

  UserModel({
    required this.uid,
    this.email,
    this.username,
    this.records
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'],
      username: data['username'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'username': username,
      'records': records,
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? username,
    List<RecordModel>? records,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      records: records ?? this.records,
    );
  }
}
