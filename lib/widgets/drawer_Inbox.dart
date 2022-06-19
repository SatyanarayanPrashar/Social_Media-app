import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/ChatRoomModel.dart';
import '../models/UserModel.dart';
import '../models/firebaseHelper.dart';
import '../pages/Chatroom.dart';

class Drawer_Inbox_Widget extends StatefulWidget {
  final String iconImage;
  final String title;
  final bool isCollapsed;
  final VoidCallback routeLink;
//
  final UserModel userModel;
  final User firebaseUser;

  const Drawer_Inbox_Widget(
      {super.key,
      required this.iconImage,
      required this.isCollapsed,
      required this.title,
      required this.routeLink,
      required this.userModel,
      required this.firebaseUser});

  @override
  State<Drawer_Inbox_Widget> createState() => _Drawer_Inbox_WidgetState();
}

class _Drawer_Inbox_WidgetState extends State<Drawer_Inbox_Widget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: InkWell(
        onTap: widget.routeLink,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: 260.0,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: const BorderRadius.all(Radius.circular(11))),
          child: widget.isCollapsed
              ? Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Image.asset(
                          'assets/icons/${widget.iconImage}',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 20),

                      //
                      Expanded(
                        flex: 7,
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //
                            Container(
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              height: 190,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.5)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
//
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("chatrooms")
                                    .where(
                                        "participants.${widget.userModel.uid}",
                                        isEqualTo: true)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.active) {
                                    if (snapshot.hasData) {
                                      QuerySnapshot chatRoomSnapshot =
                                          snapshot.data as QuerySnapshot;

                                      return ListView.builder(
                                        itemCount: chatRoomSnapshot.docs.length,
                                        itemBuilder: (context, index) {
                                          ChatRoomModel chatRoomModel =
                                              ChatRoomModel.fromMap(
                                                  chatRoomSnapshot.docs[index]
                                                          .data()
                                                      as Map<String, dynamic>);

                                          Map<String, dynamic> participants =
                                              chatRoomModel.participants!;

                                          List<String> participantKeys =
                                              participants.keys.toList();
                                          participantKeys
                                              .remove(widget.userModel.uid);

                                          return FutureBuilder(
                                            future:
                                                FirebaseHelper.getUserModelById(
                                                    participantKeys[0]),
                                            builder: (context, userData) {
                                              if (userData.connectionState ==
                                                  ConnectionState.done) {
                                                if (userData.data != null) {
                                                  UserModel targetUser =
                                                      userData.data
                                                          as UserModel;

                                                  return ListTile(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                          return Chatroom_Page(
                                                            chatroom:
                                                                chatRoomModel,
                                                            firebaseUser: widget
                                                                .firebaseUser,
                                                            userModel: widget
                                                                .userModel,
                                                            targetUser:
                                                                targetUser,
                                                          );
                                                        }),
                                                      );
                                                    },
                                                    leading: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.white,
                                                      backgroundImage:
                                                          NetworkImage(
                                                              targetUser
                                                                  .profilepic
                                                                  .toString()),
                                                    ),
                                                    title: Text(
                                                      targetUser.username
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    subtitle: (chatRoomModel
                                                                .lastMessage
                                                                .toString() !=
                                                            "")
                                                        ? Text(
                                                            chatRoomModel
                                                                .lastMessage
                                                                .toString(),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          )
                                                        : Text(
                                                            "Say hi to your new friend!",
                                                            style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .secondary,
                                                            ),
                                                          ),
                                                  );
                                                } else {
                                                  return Container();
                                                }
                                              } else {
                                                return Container();
                                              }
                                            },
                                          );
                                        },
                                      );
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        child: Text(snapshot.error.toString()),
                                      );
                                    } else {
                                      return const Center(
                                          child: Text(
                                              "Search your friends using their email address."));
                                    }
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              ),
                            ),
                            Text(
                              widget.title,
                              style: TextStyle(
                                // color: ColorConstants.dark_Text_Color,
                                fontSize: 15,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: Image.asset(
                    'assets/icons/${widget.iconImage}',
                    fit: BoxFit.contain,
                  ),
                ),
        ),
      ),
    );
  }
}
