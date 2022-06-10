import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/pages/Home_Page.dart';
import '../constants/Colors.dart';
import '../models/UserModel.dart';
import 'Signup_Page.dart';

class Login_page extends StatefulWidget {
  const Login_page({Key? key}) : super(key: key);

  @override
  State<Login_page> createState() => _Login_pageState();
}

class _Login_pageState extends State<Login_page> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void checkValues() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email == "" || password == "") {
      const snackBar = SnackBar(
        content: Text('Please fill all the details!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      logIn(email, password);
    }
  }

  void logIn(String email, String password) async {
    UserCredential? credential;

    try {
      credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(ex.code.toString())));
    }

    if (credential != null) {
      String uid = credential.user!.uid;

      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      UserModel userModel =
          UserModel.fromMap(userData.data() as Map<String, dynamic>);

      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Home_Page(userModel: userModel, firebaseUser: credential!.user!);
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: ColorConstants.dark_BG_Color,
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          children: [
//
            Container(
              height: size.height * 0.3,
              width: size.width,
//
              decoration: BoxDecoration(
                  color: ColorConstants.dark_widget_Color,
                  image: const DecorationImage(
                    image: AssetImage("assets/images/auth_bg_Col.png"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.elliptical(size.width, 90))),
            ),
//
//
            const SizedBox(height: 40),

            Container(
              height: 47.0,
              width: size.width * 0.87,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                  color: ColorConstants.dark_OnWIdget_Color.withOpacity(0.5)),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Email",
                    hintStyle: TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Container(
              height: 47.0,
              width: size.width * 0.87,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                  color: ColorConstants.dark_OnWIdget_Color.withOpacity(0.5)),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Password",
                    hintStyle: TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
//
//
            Row(
              children: [
                const SizedBox(
                  width: 30,
                ),
                InkWell(
                  onTap: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Signup_page()),
                    );
                  },
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text("Sign Up!",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

//
//
            Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: () {
                  checkValues();
                },
                child: Container(
                  height: 45,
                  width: 170,
                  decoration: BoxDecoration(
                      color: ColorConstants.dark_OnWIdget_Color,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      )),
                  child: Center(
                      child: Text(
                    "Login!",
                    style: TextStyle(
                        color: ColorConstants.dark_Text_Color, fontSize: 17),
                  )),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
