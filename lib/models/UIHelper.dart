import 'package:flutter/material.dart';
import 'package:social_media/constants/Colors.dart';
import 'package:social_media/pages/Login_Page.dart';

class UIHelper {
  static void showLoadingDialog(BuildContext context, String title) {
    AlertDialog loadingDialog = AlertDialog(
      backgroundColor: ColorConstants.dark_OnWIdget_Color,
      content: Container(
        color: ColorConstants.dark_OnWIdget_Color,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
//
            const SizedBox(height: 27),
//
            Text(title, style: TextStyle(color: Colors.white))
          ],
        ),
      ),
    );

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return loadingDialog;
        });
  }

  static void showAlerDialog(
      BuildContext context, String title, String content) {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: ColorConstants.dark_OnWIdget_Color,
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      content: Text(content, style: TextStyle(color: Colors.white)),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Login_page()));
            },
            child: Text("Yes", style: TextStyle(color: Colors.white)))
      ],
    );

    showDialog(
        context: context,
        builder: (context) {
          return alertDialog;
        });
  }
}
