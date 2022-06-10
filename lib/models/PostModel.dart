import 'package:social_media/models/MessageModel.dart';

class PostModel {
  String? postid;
  String? createdBy;
  String? userProfilePic;
  String? caption;
  String? imageadded;
  DateTime? createdon;

  PostModel(
      {this.postid,
      this.createdBy,
      this.userProfilePic,
      this.caption,
      this.imageadded,
      this.createdon});

  PostModel.fromMap(Map<String, dynamic> map) {
    postid = map["postid"];
    createdBy = map["createdBy"];
    userProfilePic = map["userProfilePic"];
    caption = map["caption"];
    imageadded = map["imageadded"];
    createdon = map["createdon"].toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      "postid": postid,
      "createdBy": createdBy,
      "userProfilePic": userProfilePic,
      "caption": caption,
      "imageadded": imageadded,
      "createdon": createdon,
    };
  }
}
