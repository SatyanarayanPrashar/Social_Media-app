import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/constants/Colors.dart';
import 'package:social_media/models/UserModel.dart';
import '../widgets/MyProfile_top.dart';

class Profile_Page extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const Profile_Page(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<Profile_Page> createState() => _Profile_PageState();
}

class _Profile_PageState extends State<Profile_Page> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: ColorConstants.dark_BG_Color,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorConstants.dark_widget_Color,
        title: Text("Profile"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            MyProfile(
              userModel: widget.userModel,
              firebaseUser: widget.firebaseUser,
            ),
          ],
        ),
      ),
    );
  }
}
