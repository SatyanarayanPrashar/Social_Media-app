import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/models/UserModel.dart';
import '../models/PostModel.dart';
import '../widgets/Others_Profile_msg.dart';
import '../widgets/noResultsFound.dart';

class Others_Profile_Page extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  final UserModel searchedUser;

  const Others_Profile_Page({
    super.key,
    required this.userModel,
    required this.firebaseUser,
    required this.searchedUser,
  });

  @override
  State<Others_Profile_Page> createState() => _Others_Profile_PageState();
}

class _Others_Profile_PageState extends State<Others_Profile_Page> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
//
            Flexible(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(widget.searchedUser.uid)
                    .collection("posts")
                    .orderBy("createdon", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      //
                      QuerySnapshot postSnapshot =
                          snapshot.data as QuerySnapshot;

                      return ListView.builder(
                          itemCount: postSnapshot.docs.length,
                          itemBuilder: (context, index) {
                            PostModel currentPost = PostModel.fromMap(
                                postSnapshot.docs[index].data()
                                    as Map<String, dynamic>);

                            // return Text(currentPost.caption.toString());
                            return Column(
                              children: [
                                //
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    backgroundImage: NetworkImage(
                                        currentPost.userProfilePic.toString()),
                                  ),
                                  title: Text(
                                    currentPost.createdBy.toString(),
                                  ),
                                  subtitle: Text(
                                    currentPost.createdon.toString(),
                                  ),
                                ),
                                //
                                Container(
                                  height: size.width,
                                  width: size.width,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(currentPost
                                              .imageadded
                                              .toString()),
                                          fit: BoxFit.contain)),
                                ),
                                //
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(17.0),
                                    child: Text(
                                      currentPost.caption.toString(),
                                      overflow: TextOverflow.clip,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),

                                const Divider()
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
//
          ],
        ),
      ),
    );
  }
}
