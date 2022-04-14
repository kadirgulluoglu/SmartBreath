import 'package:flutter/material.dart';
import 'package:smartbreath/DrawerPage.dart';
import 'package:smartbreath/chat_page.dart';

class MenuFrame extends StatefulWidget {
  @override
  _MenuFrameState createState() => _MenuFrameState();
}

class _MenuFrameState extends State<MenuFrame>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> scaleAnimation;
  Duration duration = Duration(milliseconds: 200);
  bool menuOpen = false;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: duration);
    scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.6).animate(_animationController);
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        DrawerPage(),
        AnimatedPositioned(
            duration: duration,
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: ChatPage(),
            )),
      ],
    );
  }
}
