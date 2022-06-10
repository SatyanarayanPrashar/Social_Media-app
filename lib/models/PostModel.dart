import 'package:social_media/models/MessageModel.dart';

class PostModel {
  String? userUid;
  String? userProfilePic;
  String? caption;
  String? imageadded;
  DateTime? createdon;

  PostModel(
      {this.userUid,
      this.userProfilePic,
      this.caption,
      this.imageadded,
      this.createdon});

  PostModel.fromMap(Map<String, dynamic> map) {
    userUid = map["userUid"];
    userProfilePic = map["userProfilePic"];
    caption = map["caption"];
    imageadded = map["imageadded"];
    createdon = map["createdon"];
  }

  Map<String, dynamic> toMap() {
    return {
      "userUid": userUid,
      "userProfilePic": userProfilePic,
      "caption": caption,
      "imageadded": imageadded,
      "createdon": createdon,
    };
  }
}
