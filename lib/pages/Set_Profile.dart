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

class Set_Profile_Page extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const Set_Profile_Page(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<Set_Profile_Page> createState() => _Set_Profile_PageState();
}

class _Set_Profile_PageState extends State<Set_Profile_Page> {
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
    UIHelper.showLoadingDialog(context, "Uploading..");

    UploadTask uploadTask = FirebaseStorage.instance
        .ref("profilepictures")
        .child(widget.userModel.uid.toString())
        .putFile(imageFile!);

    TaskSnapshot snapshot = await uploadTask;

    String? imageUrl = await snapshot.ref.getDownloadURL();
    String? bio = bioController.text.trim();
    String? username = usernameController.text.trim();

    widget.userModel.username = username;
    widget.userModel.bio = bio;
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
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
                      backgroundColor: Colors.grey,
                      radius: 60,
                      backgroundImage:
                          (imageFile != null) ? FileImage(imageFile!) : null,
                      child: (imageFile == null)
                          ? const Icon(
                              Icons.person,
                              size: 60,
                            )
                          : null,
                    ),
                  ),
//

                  Container(
                    margin: const EdgeInsets.only(left: 18, top: 18, right: 18),
                    color: Colors.grey,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Flexible(
                        child: TextField(
                      controller: usernameController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: "Username",
                        hintStyle: TextStyle(fontSize: 14.0),
                        border: InputBorder.none,
                      ),
                    )),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 18, top: 18, right: 18),
                    color: Colors.grey,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Flexible(
                        child: TextField(
                      controller: bioController,
                      style: const TextStyle(color: Colors.white),
                      maxLength: 150,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: "Bio",
                        hintStyle: TextStyle(fontSize: 14.0),
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
                          color: Colors.blue.withOpacity(0.4),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          )),
                      child: Center(
                          child: Text(
                        "Save",
                        style: TextStyle(fontSize: 17),
                      )),
                    ),
                  ),
                  const Divider()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
