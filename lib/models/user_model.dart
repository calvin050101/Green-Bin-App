class UserModel {
  final String uid;
  final String? email;
  final String? username;
  final int points;

  UserModel({
    required this.uid,
    this.email,
    this.username,
    required this.points,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'],
      username: data['username'],
      points: data['points']
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'username': username,
      'points': points,
    };
  }
}
