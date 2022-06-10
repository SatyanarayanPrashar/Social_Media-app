class UserModel {
  String? uid;
  String? username;
  String? email;
  String? profilepic;
  String? bio;

  UserModel({this.uid, this.username, this.email, this.profilepic, this.bio});

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    username = map["username"];
    email = map["email"];
    profilepic = map["profilepic"];
    bio = map["bio"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "username": username,
      "email": email,
      "profilepic": profilepic,
      "bio": bio,
    };
  }
}
