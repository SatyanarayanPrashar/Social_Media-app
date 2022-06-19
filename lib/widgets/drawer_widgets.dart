import 'package:flutter/material.dart';

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
                ),
        ),
      ),
    );
  }
}
