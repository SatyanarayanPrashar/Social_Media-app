import 'package:flutter/material.dart';
import '../constants/Colors.dart';

class Saves_page extends StatefulWidget {
  const Saves_page({Key? key}) : super(key: key);

  @override
  State<Saves_page> createState() => _Saves_pageState();
}

class _Saves_pageState extends State<Saves_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.dark_BG_Color,
      appBar: AppBar(
        title: Text("Saves"),
        backgroundColor: ColorConstants.dark_widget_Color,
      ),
      body: SafeArea(
        child: Align(
            alignment: Alignment.center,
            child: Column(
              children: [],
            )),
      ),
    );
  }
}
