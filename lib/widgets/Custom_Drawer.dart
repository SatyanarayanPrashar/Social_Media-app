import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/models/UserModel.dart';
import 'package:social_media/widgets/drawer_Inbox.dart';

import '../constants/Colors.dart';

import '../pages/Inbox.dart';
import 'drawer_bottom_profile.dart';
import 'drawer_widgets.dart';

class CustomDrawer extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const CustomDrawer(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: AnimatedContainer(
      curve: Curves.easeInOutCubic,
      duration: const Duration(milliseconds: 500),
//
      width: _isCollapsed ? 250 : 70,
      // height: size.height * 0.8,
//
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        color: ColorConstants.dark_widget_Color,
      ),
//
//
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //
                //
                Drawer_Widget(
                  iconImage: 'icon.png',
                  isCollapsed: _isCollapsed,
                  title: 'Social Media',
                  routeLink: () {
                    //
                  },
                ),
                //
                //
                Divider(
                  color: ColorConstants.dark_Text_Color,
                ),

                //
                Drawer_Inbox_Widget(
                  iconImage: 'inbox.png',
                  isCollapsed: _isCollapsed,
                  title: 'View all',
                  routeLink: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) {
                      return Messages_page(
                        firebaseUser: widget.firebaseUser,
                        userModel: widget.userModel,
                      );
                    })));
                  },
                  firebaseUser: widget.firebaseUser,
                  userModel: widget.userModel,
                ),

                //
                Divider(
                  color: ColorConstants.dark_Text_Color,
                ),

                //
                //

                Drawer_bottom_profile(
                  isCollapsed: _isCollapsed,
                  userModel: widget.userModel,
                  firebaseUser: widget.firebaseUser,
                ),
                //
                //
                Align(
                  alignment: _isCollapsed
                      ? Alignment.bottomRight
                      : Alignment.bottomCenter,
                  child: IconButton(
                      splashColor: Colors.transparent,
                      onPressed: () {
                        setState(() {
                          _isCollapsed = !_isCollapsed;
                        });
                      },
                      icon: Icon(
                        _isCollapsed
                            ? Icons.arrow_back_ios
                            : Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 17,
                      )),
                ),
                const SizedBox(
                  height: 20,
                )
                //
                //
              ]),
        ),
      ),
    ));
  }
}
