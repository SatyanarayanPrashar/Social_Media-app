import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/models/UserModel.dart';
import 'package:social_media/pages/Login_Page.dart';
import 'package:social_media/pages/Profile_Page.dart';

class Drawer_bottom_profile extends StatefulWidget {
  final bool isCollapsed;
  final UserModel userModel;
  final User firebaseUser;

  const Drawer_bottom_profile(
      {super.key,
      required this.isCollapsed,
      required this.userModel,
      required this.firebaseUser});

  @override
  State<Drawer_bottom_profile> createState() => _Drawer_bottom_profileState();
}

class _Drawer_bottom_profileState extends State<Drawer_bottom_profile> {
  void confirmLogout(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      // backgroundColor: ColorConstants.dark_OnWIdget_Color,
      title: Text(
        "Log Out",
      ),
      content: Text("Are you sure?"),
      actions: [
        TextButton(
          onPressed: () {
            // Navigator.popUntil(context, (route) => route.isFirst);
            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (context) => Login_page()));
            logOut();
          },
          child: Text("Yes"),
        )
      ],
    );

    showDialog(
        context: context,
        builder: (context) {
          return alertDialog;
        });
  }

  void logOut() async {
    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login_page()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 110,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: widget.isCollapsed
              ? Center(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              widget.userModel.profilepic.toString(),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Profile_Page(
                                  userModel: widget.userModel,
                                  firebaseUser: widget.firebaseUser);
                            }));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    //
                                    widget.userModel.username.toString(),
                                    //
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ),
                              //
                              Expanded(
                                child: Text(
                                  widget.userModel.email.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: IconButton(
                            onPressed: () {
                              confirmLogout(context);
                            },
                            icon: const Icon(
                              Icons.logout,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          // child: const Icon(Icons.person),
                          child: Image.network(
                            widget.userModel.profilepic.toString(),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          confirmLogout(context);
                        },
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
        ));
  }
}
