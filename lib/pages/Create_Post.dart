import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/constants/Colors.dart';
import 'package:social_media/models/PostModel.dart';
import 'package:social_media/pages/Home_Page.dart';

import '../models/UserModel.dart';

class Create_Post extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const Create_Post(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<Create_Post> createState() => _Create_PostState();
}

class _Create_PostState extends State<Create_Post> {
  TextEditingController captionController = TextEditingController();

  File? imageFile;

  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  void cropImage(XFile file) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 10);

    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }

  void showPhotoOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Upload Profile Picture"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.gallery);
                  },
                  leading: const Icon(Icons.photo_album),
                  title: const Text("Select from Gallery"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.camera);
                  },
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Take a photo"),
                )
              ],
            ),
          );
        });
  }

  void checkValues() {
    String caption = captionController.text.trim();

    if (caption == "" && imageFile == null) {
      const snackBar = SnackBar(
        content: Text("Please create a post!"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    // else
    // if (imageFile == null) {
    //   const snackBar = SnackBar(
    //     content: Text("Please choose a picture!"),
    //   );
    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // }
    else {
      // Create Post
      createPost();
    }
  }

  void createPost() async {
    String? caption = captionController.text.trim();

    PostModel newPost = PostModel(
        userUid: widget.userModel.uid,
        userProfilePic: widget.userModel.profilepic,
        caption: caption,
        imageadded: "",
        createdon: DateTime.now());

    await FirebaseFirestore.instance
        .collection("posts")
        .doc()
        .set(newPost.toMap())
        .then((value) {
      print("New Post Created");
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Home_Page(
            userModel: widget.userModel, firebaseUser: widget.firebaseUser);
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: ColorConstants.dark_BG_Color,
        appBar: AppBar(
          backgroundColor: ColorConstants.dark_widget_Color,
          title: Text(
            "Post",
            style:
                TextStyle(fontSize: 20, color: ColorConstants.dark_Text_Color),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 18, top: 18, right: 18),
                  color: ColorConstants.dark_widget_Color,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          splashRadius: 1,
                          onPressed: () {
                            showPhotoOptions();
                          },
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: Colors.white,
                          )),
                      Container(
                        height: 225,
                        width: 225,
                        decoration: BoxDecoration(
                          color: ColorConstants.dark_widget_Color,
                        ),
                        child: (imageFile == null)
                            ? const Icon(
                                Icons.person,
                                size: 60,
                              )
                            : Image(image: FileImage(imageFile!)),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 18, top: 18, right: 18),
                  color: ColorConstants.dark_widget_Color,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Flexible(
                      child: TextField(
                    controller: captionController,
                    style: const TextStyle(color: Colors.white),
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: "Caption",
                      hintStyle: TextStyle(fontSize: 14.0, color: Colors.white),
                      border: InputBorder.none,
                    ),
                  )),
                ),
                TextButton(
                    onPressed: () {
                      checkValues();
                      // createPost();
                    },
                    child: Text("okay"))
              ],
            ),
          ),
        ));
  }
}
