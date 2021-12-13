class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? lastName;
  String? profileImagePath;
  String? status;

  UserModel({
    this.uid,
    this.email,
    this.firstName,
    this.lastName,
    this.profileImagePath,
    this.status,
  });

  // ! Receiving Data From Server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      profileImagePath: map['profileImagePath'],
      status: map['status'],
    );
  }

  // ! Sending Data to Server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'profileImagePath': profileImagePath,
      'status': status,
    };
  }
}
