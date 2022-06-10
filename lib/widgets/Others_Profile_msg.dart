import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media/models/MessageModel.dart';
import 'package:social_media/models/UserModel.dart';
import 'package:social_media/pages/Chatroom.dart';
import 'package:social_media/pages/EditProfile_Page.dart';

import '../constants/Colors.dart';
import '../main.dart';
import '../models/ChatRoomModel.dart';

class Others_Profile_msg extends StatefulWidget {
  final UserModel searchedUser;
  final UserModel userModel;
  final User firebaseUser;

  const Others_Profile_msg({
    super.key,
    required this.searchedUser,
    required this.firebaseUser,
    required this.userModel,
  });

  @override
  State<Others_Profile_msg> createState() => _Others_Profile_msgState();
}

class _Others_Profile_msgState extends State<Others_Profile_msg> {
  //
  Future<ChatRoomModel?> getChatroomModel(UserModel targetUser) async {
    ChatRoomModel? chatRoom;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${widget.userModel.uid}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.length > 0) {
      // Fetch the existing one
      var docData = snapshot.docs[0].data();

      ChatRoomModel existingChatroom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);

      chatRoom = existingChatroom;
    } else {
      // Create a new one

      ChatRoomModel newChatroom = ChatRoomModel(
        chatroomid: uuid.v1(),
        lastMessage: "",
        participants: {
          widget.userModel.uid.toString(): true,
          widget.searchedUser.uid.toString(): true,
        },
      );

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatroom.chatroomid)
          .set(newChatroom.toMap());

      chatRoom = newChatroom;

      log("New chatRoom created!");
    }

    return chatRoom;
  }

  //
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
                      NetworkImage(widget.searchedUser.profilepic.toString()),
                  radius: 50,
                ),
              ),
            ),
            //
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Text(
                widget.searchedUser.username.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 17.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Text(
                widget.searchedUser.email.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12.0),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 18.0, right: 18.0, top: 12.0),
              child: Text(
                widget.searchedUser.bio.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 17.0),
              ),
            ),
            //
            InkWell(
              onTap: () async {
                ChatRoomModel? chatroomModel =
                    await getChatroomModel(widget.searchedUser);

                if (chatroomModel != null) {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Chatroom_Page(
                        targetUser: widget.searchedUser,
                        firebaseUser: widget.firebaseUser,
                        chatroom: chatroomModel,
                        userModel: widget.userModel);
                  }));
                }
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
                  "Message",
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
