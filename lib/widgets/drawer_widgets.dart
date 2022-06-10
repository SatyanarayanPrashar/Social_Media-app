import 'package:flutter/material.dart';

import '../constants/Colors.dart';

class Drawer_Widget extends StatelessWidget {
  final String iconImage;
  final String title;
  final bool isCollapsed;
  final VoidCallback routeLink;

  const Drawer_Widget(
      {super.key,
      required this.iconImage,
      required this.isCollapsed,
      required this.title,
      required this.routeLink});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: InkWell(
        onTap: routeLink,
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            height: 45.0,
            decoration: BoxDecoration(
                color: ColorConstants.dark_OnWIdget_Color,
                borderRadius: const BorderRadius.all(Radius.circular(11))),
            child: isCollapsed
                ? Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Image.asset(
                              'assets/icons/$iconImage',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),

                        //
                        Expanded(
                          flex: 7,
                          child: Text(
                            title,
                            style: TextStyle(
                              color: ColorConstants.dark_Text_Color,
                              fontSize: 15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                          ),
                        )
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: Image.asset(
                      'assets/icons/$iconImage',
                      fit: BoxFit.contain,
                    ),
                  )),
      ),
    );
  }
}
