import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media/models/PostModel.dart';
import 'package:social_media/pages/Create_Post.dart';
import '../models/UserModel.dart';
import '../widgets/Custom_Drawer.dart';
import '../widgets/noResultsFound.dart';
import 'Search_Page.dart';

class Home_Page extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  // final PostModel postmodel;

  const Home_Page({
    super.key,
    required this.userModel,
    required this.firebaseUser,
  });

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
//
      appBar: AppBar(
        title: const Text("Social Media"),
        actions: [
          CupertinoButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) {
                    return Search_Page(
                      userModel: widget.userModel,
                      firebaseUser: widget.firebaseUser,
                    );
                  }),
                ),
              );
            },
            child: const Icon(
              Icons.search,
              // color: Colors.white,
              size: 27,
            ),
          ),
          const SizedBox(width: 15)
        ],
      ),
      drawer: CustomDrawer(
          userModel: widget.userModel, firebaseUser: widget.firebaseUser),
//
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Create_Post(
                    userModel: widget.userModel,
                    firebaseUser: widget.firebaseUser);
              },
            ),
          );
        },
        // backgroundColor: ColorConstants.dark_OnWIdget_Color,
        label: const Text("Create"),
        icon: const Icon(Icons.add),
      ),
//
//
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
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
                      //
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
                                    image: NetworkImage(
                                        currentPost.imageadded.toString()),
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
                return const NoResultsFound(title: "Say Hi! to your friend");
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
