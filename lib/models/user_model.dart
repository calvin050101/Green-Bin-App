import 'package:green_bin/models/record_model.dart';

class UserModel {
  final String uid;
  final String? email;
  final String? username;
  final int? totalPoints;
  final double? totalCarbonSaved;
  final List<RecordModel>? records;

  UserModel({
    required this.uid,
    this.email,
    this.username,
    this.totalPoints,
    this.totalCarbonSaved,
    this.records
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'],
      username: data['username'],
      totalPoints: data['totalPoints'],
      totalCarbonSaved: data['totalCarbonSaved'].toDouble(),
    );
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? username,
    int? totalPoints,
    double? totalCarbonSaved,
    List<RecordModel>? records,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      totalPoints: totalPoints ?? this.totalPoints,
      totalCarbonSaved: totalCarbonSaved ?? this.totalCarbonSaved?.toDouble(),
      records: records ?? this.records,
    );
  }
}
