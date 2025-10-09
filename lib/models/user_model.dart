import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green_bin/models/record_model.dart';
import 'package:green_bin/models/redeemed_vouchers_model.dart';

class UserModel {
  final String uid;
  final String? email;
  final String? username;
  final int? totalPoints;
  final double? totalCarbonSaved;
  final List<WasteRecord>? records;
  final List<RedeemedVoucher>? redeemedVouchers;

  UserModel({
    required this.uid,
    this.email,
    this.username,
    this.totalPoints,
    this.totalCarbonSaved,
    this.records,
    this.redeemedVouchers
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc, String uid) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: uid,
      email: data['email'],
      username: data['username'],
      totalPoints: data['totalPoints'],
      totalCarbonSaved: data['totalCarbonSaved'].toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'totalPoints': totalPoints,
      'totalCarbonSaved': totalCarbonSaved,
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? username,
    int? totalPoints,
    double? totalCarbonSaved,
    List<WasteRecord>? records,
    List<RedeemedVoucher>? redeemedVouchers,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      totalPoints: totalPoints ?? this.totalPoints,
      totalCarbonSaved: totalCarbonSaved ?? this.totalCarbonSaved?.toDouble(),
      records: records ?? this.records,
      redeemedVouchers: redeemedVouchers ?? this.redeemedVouchers,
    );
  }
}
