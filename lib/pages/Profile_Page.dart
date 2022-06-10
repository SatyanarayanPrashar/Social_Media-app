import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/constants/Colors.dart';
import 'package:social_media/models/PostModel.dart';
import 'package:social_media/models/UserModel.dart';
import 'package:social_media/widgets/noResultsFound.dart';
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
          Flexible(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(widget.userModel.uid)
                  .collection("posts")
                  .orderBy("createdon", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    //
                    QuerySnapshot postSnapshot = snapshot.data as QuerySnapshot;

                    return ListView.builder(
                        itemCount: postSnapshot.docs.length,
                        itemBuilder: (context, index) {
                          PostModel currentPost = PostModel.fromMap(
                              postSnapshot.docs[index].data()
                                  as Map<String, dynamic>);

                          // return Text(currentPost.caption.toString());
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //
                              //
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      ColorConstants.dark_OnWIdget_Color,
                                  backgroundImage: NetworkImage(
                                      currentPost.userProfilePic.toString()),
                                ),
                                title: Text(
                                  widget.userModel.username.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  currentPost.createdon.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              //
                              Container(
                                height: size.width,
                                width: size.width,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            currentPost.imageadded.toString()),
                                        fit: BoxFit.contain)),
                              ),
                              //
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  currentPost.caption.toString(),
                                  overflow: TextOverflow.clip,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              )
                              //
                            ],
                          );
                        });
                    //
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: NoResultsFound(title: "An error occured :("),
                    );
                  } else {
                    return const NoResultsFound(
                        title: "Say Hi! to your friend");
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      )
          // ],
          ),
    );
    // );
  }
}
