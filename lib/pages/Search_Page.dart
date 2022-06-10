import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media/models/UserModel.dart';
import 'package:social_media/pages/Others_profille.dart';
import 'package:social_media/widgets/noResultsFound.dart';

import '../constants/Colors.dart';
import '../models/ChatRoomModel.dart';
import '../models/MessageModel.dart';

class Search_Page extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const Search_Page({
    super.key,
    required this.userModel,
    required this.firebaseUser,
  });

  @override
  State<Search_Page> createState() => _Search_PageState();
}

class _Search_PageState extends State<Search_Page> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: ColorConstants.dark_BG_Color,
      appBar: AppBar(
        backgroundColor: ColorConstants.dark_widget_Color,
        actions: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 8.0),
                margin: const EdgeInsets.only(left: 4, top: 4, bottom: 4),
                width: size.width * 0.7,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                    color: ColorConstants.dark_OnWIdget_Color.withOpacity(0.5)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextField(
                    controller: searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search",
                        hintStyle:
                            TextStyle(fontSize: 14.0, color: Colors.white),
                        fillColor: Colors.white),
                  ),
                ),
              ),
              CupertinoButton(
                onPressed: () {
                  setState(() {});
                },
                child: const Icon(Icons.search, color: Colors.white),
              )
            ],
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 10),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where("email", isEqualTo: searchController.text)
                  .where("email", isNotEqualTo: widget.userModel.email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    //
                    QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;

                    if (dataSnapshot.docs.length > 0) {
                      Map<String, dynamic> userMap =
                          dataSnapshot.docs[0].data() as Map<String, dynamic>;

                      UserModel searchedUser = UserModel.fromMap(userMap);

                      //

                      return ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Others_Profile_Page(
                              userModel: widget.userModel,
                              firebaseUser: widget.firebaseUser,
                              searchedUser: searchedUser,
                            );
                          }));
                        },
                        leading: CircleAvatar(
                          backgroundColor: ColorConstants.dark_OnWIdget_Color,
                          backgroundImage: NetworkImage(searchedUser.username!),
                        ),
                        title: Text(
                          searchedUser.username!,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 17),
                        ),
                        subtitle: Text(
                          searchedUser.email!,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      );
                    } else {
                      return const NoResultsFound(title: "No results found!");
                    }
                    //
                  } else if (snapshot.hasError) {
                    return const NoResultsFound(title: "An error occured!");
                  } else {
                    return const NoResultsFound(title: "No results found!");
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
