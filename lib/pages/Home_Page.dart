import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media/models/PostModel.dart';
import 'package:social_media/pages/Create_Post.dart';
import '../constants/Colors.dart';
import '../models/UserModel.dart';
import '../widgets/Custom_Drawer.dart';
import '../widgets/Home_Pg_Post.dart';
import 'Search_Page.dart';

class Home_Page extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  // final PostModel postmodel;

  const Home_Page(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: ColorConstants.dark_BG_Color,
//
      appBar: AppBar(
        title: Text("Social Media"),
        elevation: 2,
        backgroundColor: ColorConstants.dark_BG_Color,
        actions: [
          CupertinoButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: ((context) {
                  return Search_Page(
                      userModel: widget.userModel,
                      firebaseUser: widget.firebaseUser);
                })));
              },
              child: const Icon(
                Icons.search,
                color: Colors.white,
                size: 27,
              )),
          const SizedBox(width: 15)
        ],
      ),
      drawer: CustomDrawer(
          userModel: widget.userModel, firebaseUser: widget.firebaseUser),
//
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Create_Post(
                userModel: widget.userModel, firebaseUser: widget.firebaseUser);
          }));
        },
        backgroundColor: ColorConstants.dark_OnWIdget_Color,
        label: Text("Create"),
        icon: Icon(Icons.add),
      ),
//
//
      // body: SafeArea(
      //   child: StreamBuilder(
      //     stream: FirebaseFirestore.instance.collection("posts").doc().collection("caption").,
      //   )
      // ),
    );
  }
}
