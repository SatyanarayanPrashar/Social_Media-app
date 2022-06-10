import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media/models/UserModel.dart';
import 'package:social_media/pages/EditProfile_Page.dart';

import '../constants/Colors.dart';

class MyProfile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const MyProfile(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: SizedBox(
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(11.0),
              child: Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  backgroundColor: ColorConstants.dark_widget_Color,
                  backgroundImage:
                      NetworkImage(widget.userModel.profilepic.toString()),
                  radius: 50,
                ),
              ),
            ),
            //
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Text(
                widget.userModel.username.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 17.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Text(
                widget.userModel.email.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12.0),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 18.0, right: 18.0, top: 12.0),
              child: Text(
                widget.userModel.bio.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 17.0),
              ),
            ),
            //
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return EditProfile_Page(
                      userModel: widget.userModel,
                      firebaseUser: widget.firebaseUser);
                }));
              },
              child: Container(
                margin: const EdgeInsets.all(12),
                height: 45,
                width: size.width,
                decoration: BoxDecoration(
                    color: ColorConstants.dark_OnWIdget_Color.withOpacity(0.4),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    )),
                child: Center(
                    child: Text(
                  "Edit Profile",
                  style: TextStyle(
                      color: ColorConstants.dark_Text_Color, fontSize: 17),
                )),
              ),
            ),
            const Divider(
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
