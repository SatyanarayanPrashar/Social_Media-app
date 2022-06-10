import 'package:flutter/material.dart';
import '../constants/Colors.dart';

class HmPg_Post extends StatelessWidget {
  const HmPg_Post({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(bottom: 7, top: 7),
      width: size.width * 0.97,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10, left: 10),
            height: 80.0,
            width: size.width * 0.9,
            child: Row(
              children: [
                CircleAvatar(
                  // backgroundImage: ,           USER PROFILE PICTURE HERE
                  child: Icon(Icons.person),
                  radius: 27,
                  backgroundColor: ColorConstants.dark_widget_Color,
                ),
                const SizedBox(width: 20),
                Text(
                  "Anupam Aaron",
                  style: TextStyle(
                      fontSize: 18, color: ColorConstants.dark_Text_Color),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "Requested Item :",
              style: TextStyle(
                  fontSize: 16, color: ColorConstants.dark_Text_Color),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "kfhvbahc;mclsoncnfdjnv;cnsvnnljwnkxnzafnknkncckcnsdcndnekcnskjcnkcnknvnnnnnvnnnvn",
              overflow: TextOverflow.clip,
              style: TextStyle(
                  fontSize: 20, color: ColorConstants.dark_Text_Color),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  //
                },
                child: Container(
                  height: 45,
                  width: 150,
                  decoration: BoxDecoration(
                      color:
                          ColorConstants.dark_OnWIdget_Color.withOpacity(0.4),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      )),
                  child: Center(
                      child: Text(
                    "View others",
                    style: TextStyle(
                        color: ColorConstants.dark_Text_Color, fontSize: 17),
                  )),
                ),
              ),
              const SizedBox(width: 10),
//
//
              InkWell(
                onTap: () {
                  //
                },
                child: Container(
                  height: 45,
                  width: 150,
                  decoration: BoxDecoration(
                      color: ColorConstants.dark_OnWIdget_Color,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      )),
                  child: Center(
                      child: Text(
                    "I can get it!",
                    style: TextStyle(
                        color: ColorConstants.dark_Text_Color, fontSize: 17),
                  )),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }
}
