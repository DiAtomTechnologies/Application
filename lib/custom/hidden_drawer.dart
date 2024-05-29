import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:diatom/pages/AddDevice.dart';
import 'package:diatom/pages/chatbot/chat.dart';
import 'package:diatom/pages/home.dart';
import 'package:diatom/pages/services/Analytics.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({Key? key}) : super(key: key);

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  late List<ScreenHiddenDrawer> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: "Home",
          baseStyle: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
          selectedStyle: TextStyle(
            color: Colors.red,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
          colorLineSelected: Colors.red,
        ),
        Home(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: "AddDevice",
          baseStyle: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
          selectedStyle: TextStyle(
            color: Colors.red,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
          colorLineSelected: Colors.red,
        ),
        AddDevice(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: "ChatBot",
          baseStyle: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
          selectedStyle: TextStyle(
            color: Colors.red,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
          colorLineSelected: Colors.red,
        ),
        ChatPage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: "Analytics",
          baseStyle: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
          selectedStyle: TextStyle(
            color: Colors.red,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
          colorLineSelected: Colors.red,
        ),
        Analytics(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: const Color.fromARGB(255, 2, 33, 59),
      screens: _pages,
      initPositionSelected: 0,
      leadingAppBar: Padding(
        padding: const EdgeInsets.only(left: 5.0),
        child: Image.asset(
          'assets/images/logo.png',
          height: 50.0,
          width: 50.0,
        ),
      ),
      tittleAppBar: Text(
        "DiAtom Technologies",
        style: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
          color: Colors.white,
        ),
      ),
      isTitleCentered: true,
      backgroundColorAppBar: const Color.fromARGB(255, 2, 33, 59),
    );
  }
}
