import 'package:flutter/material.dart';

class NoResultsFound extends StatelessWidget {
  final String title;

  const NoResultsFound({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.3,
      width: size.width * 0.87,
      child: Column(
        children: [
          Image.asset(
            "assets/images/noResults.png",
            height: size.height * 0.25,
          ),
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
        ],
      ),
    );
  }
}
