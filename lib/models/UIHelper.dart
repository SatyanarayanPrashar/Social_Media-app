import 'package:flutter/material.dart';
import 'package:social_media/constants/Colors.dart';

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
}
