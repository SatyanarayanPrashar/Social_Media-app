import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/models/UIHelper.dart';
import 'package:social_media/pages/Home_Page.dart';
import '../models/UserModel.dart';

class EditProfile_Page extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const EditProfile_Page({
    super.key,
    required this.userModel,
    required this.firebaseUser,
  });

  @override
  State<EditProfile_Page> createState() => _EditProfile_PageState();
}

class _EditProfile_PageState extends State<EditProfile_Page> {
  TextEditingController bioController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

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
    String bio = bioController.text.trim();
    String username = usernameController.text.trim();

    UIHelper.showLoadingDialog(context, "Setting up..");

    if (username == "") {
      const snackBar = SnackBar(
        content: Text("Please fill a Username!"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (bio == "") {
      const snackBar = SnackBar(
        content: Text("Please fill a bio!"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (imageFile == null) {
      const snackBar = SnackBar(
        content: Text("Please choose a profile picture!"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      uploadData();
    }
  }

  void uploadData() async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("profilepictures")
        .child(widget.userModel.uid.toString())
        .putFile(imageFile!);

    TaskSnapshot snapshot = await uploadTask;

    String? imageUrl = await snapshot.ref.getDownloadURL();
    String? bio = bioController.text.trim();
    String? username = usernameController.text.trim();

    widget.userModel.bio = bio;
    widget.userModel.username = username;
    widget.userModel.profilepic = imageUrl;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap())
        .then((value) {
      //
      print("Changes saved");
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return Home_Page(
            userModel: widget.userModel,
            firebaseUser: widget.firebaseUser,
          );
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Profile"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CupertinoButton(
                      onPressed: () {
                        showPhotoOptions();
                      },
                      child: CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 155, 231, 157),
                        radius: 60,
                        backgroundImage: NetworkImage(
                            widget.userModel.profilepic.toString()),
                      )),
//

                  Container(
                    margin: const EdgeInsets.only(left: 18, top: 18, right: 18),
                    // color: ColorConstants.dark_widget_Color,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Flexible(
                        child: TextField(
                      controller: usernameController,
                      style: TextStyle(color: Colors.white),
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: "Username",
                        hintStyle:
                            TextStyle(fontSize: 14.0, color: Colors.white),
                        border: InputBorder.none,
                      ),
                    )),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 18, top: 18, right: 18),
                    // color: ColorConstants.dark_widget_Color,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Flexible(
                        child: TextField(
                      controller: bioController,
                      style: TextStyle(color: Colors.white),
                      maxLength: 150,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: "Bio",
                        hintStyle:
                            TextStyle(fontSize: 14.0, color: Colors.white),
                        border: InputBorder.none,
                      ),
                    )),
                  ),
//
                  InkWell(
                    onTap: () {
                      checkValues();
                    },
                    child: Container(
                      margin: const EdgeInsets.all(12),
                      height: 45,
                      width: size.width,
                      decoration: BoxDecoration(
                          // color: ColorConstants.dark_OnWIdget_Color
                          //     .withOpacity(0.4),
                          borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      )),
                      child: Center(
                          child: Text(
                        "Save Changes",
                        style: TextStyle(fontSize: 17),
                      )),
                    ),
                  ),
                  const Divider(
                    color: Colors.white,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
