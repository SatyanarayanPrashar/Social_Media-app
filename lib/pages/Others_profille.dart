import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/constants/Colors.dart';
import 'package:social_media/models/UserModel.dart';
import '../widgets/MyProfile_top.dart';
import '../widgets/Others_Profile_msg.dart';

class Others_Profile_Page extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  final UserModel searchedUser;

  const Others_Profile_Page(
      {super.key,
      required this.userModel,
      required this.firebaseUser,
      required this.searchedUser});

  @override
  State<Others_Profile_Page> createState() => _Others_Profile_PageState();
}

class _Others_Profile_PageState extends State<Others_Profile_Page> {
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
            Others_Profile_msg(
              userModel: widget.userModel,
              firebaseUser: widget.firebaseUser,
              searchedUser: widget.searchedUser,
            ),
          ],
        ),
      ),
    );
  }
}
