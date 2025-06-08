import 'package:green_bin/models/record_model.dart';

class UserModel {
  final String uid;
  final String? email;
  final String? username;
  final int points;
  final List<RecordModel>? records;

  UserModel({
    required this.uid,
    this.email,
    this.username,
    required this.points,
    this.records
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'],
      username: data['username'],
      points: data['points'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'username': username,
      'points': points,
      'records': records,
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? username,
    int? points,
    List<RecordModel>? records,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      points: points ?? this.points,
      records: records ?? this.records,
    );
  }
}
