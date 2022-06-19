import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:social_media/models/ChatRoomModel.dart';
import 'package:social_media/models/MessageModel.dart';
import 'package:social_media/models/UserModel.dart';
import 'package:social_media/widgets/noResultsFound.dart';

import '../main.dart';
import 'Others_profille.dart';

class Chatroom_Page extends StatefulWidget {
  final UserModel targetUser;
  final User firebaseUser;
  final ChatRoomModel chatroom;
  final UserModel userModel;

  const Chatroom_Page(
      {super.key,
      required this.targetUser,
      required this.firebaseUser,
      required this.chatroom,
      required this.userModel});

  @override
  State<Chatroom_Page> createState() => _Chatroom_PageState();
}

class _Chatroom_PageState extends State<Chatroom_Page> {
  TextEditingController messageController = TextEditingController();

  void sendMessage() async {
    String msg = messageController.text.trim();
    messageController.clear();

    if (msg != "") {
      // Send Message
      MessageModel newMessage = MessageModel(
        messageid: uuid.v1(),
        sender: widget.userModel.uid,
        createdon: DateTime.now(),
        text: msg,
        seen: false,
      );

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatroomid)
          .collection("messages")
          .doc(newMessage.messageid)
          .set(newMessage.toMap());

      widget.chatroom.lastMessage = msg;
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatroomid)
          .set(widget.chatroom.toMap());

      log("message sent!");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);

                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Others_Profile_Page(
                      userModel: widget.userModel,
                      firebaseUser: widget.firebaseUser,
                      searchedUser: widget.targetUser);
                }));
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage:
                    NetworkImage(widget.targetUser.profilepic.toString()),
              ),
            ),
            const SizedBox(width: 10),
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Others_Profile_Page(
                      userModel: widget.userModel,
                      firebaseUser: widget.firebaseUser,
                      searchedUser: widget.targetUser);
                }));
              },
              child: Text(
                widget.targetUser.username.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(children: [
          Expanded(
              child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("chatrooms")
                .doc(widget.chatroom.chatroomid)
                .collection("messages")
                .orderBy("createdon", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;

                  return ListView.builder(
                    reverse: true,
                    itemCount: dataSnapshot.docs.length,
                    itemBuilder: (context, index) {
                      MessageModel currentMessage = MessageModel.fromMap(
                          dataSnapshot.docs[index].data()
                              as Map<String, dynamic>);

                      return Row(
                        mainAxisAlignment:
                            (currentMessage.sender == widget.userModel.uid)
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                        children: [
                          Container(
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: (currentMessage.sender ==
                                        widget.userModel.uid)
                                    ? const BorderRadius.only(
                                        topLeft: Radius.circular(14),
                                        topRight: Radius.circular(14),
                                        bottomLeft: Radius.circular(14))
                                    : const BorderRadius.only(
                                        topLeft: Radius.circular(14),
                                        topRight: Radius.circular(14),
                                        bottomRight: Radius.circular(14)),
                                color: (currentMessage.sender ==
                                        widget.userModel.uid)
                                    ? const Color.fromARGB(255, 209, 247, 210)
                                    : const Color.fromARGB(255, 155, 231, 157),
                              ),
                              child: Text(
                                currentMessage.text.toString(),
                                style: const TextStyle(fontSize: 16),
                              )),
                        ],
                      );
                    },
                  );
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
          )),
//
          Container(
            color: Colors.grey,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: messageController,
                    maxLines: null,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        hintText: "Enter message",
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      sendMessage();
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ))
              ],
            ),
          )
        ]),
      ),
    );
  }
}
