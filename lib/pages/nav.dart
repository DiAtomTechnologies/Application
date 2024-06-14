import 'package:diatom/controller/bottom_nav_bar_controller.dart';
import 'package:diatom/pages/AddDevice.dart';
import 'package:diatom/pages/Device.dart';
import 'package:diatom/pages/Profile.dart';
import 'package:diatom/pages/analytics.dart';
import 'package:diatom/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class nav extends StatefulWidget {
  const nav({Key? key}) : super(key: key);

  @override
  _navState createState() => _navState();
}

class _navState extends State<nav> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BottomNavigationBarController controller =
        Get.put(BottomNavigationBarController());

    return Scaffold(
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 0, 0, 0),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: const Color.fromARGB(255, 0, 0, 0),
            child: SafeArea(
              child: Obx(() => GNav(
                    tabBackgroundGradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(255, 14, 64, 105),
                        Color.fromARGB(255, 252, 157, 157),
                      ],
                    ),
                    padding: const EdgeInsets.all(16.0),
                    tabMargin: const EdgeInsets.symmetric(vertical: 10),
                    gap: 8,
                    onTabChange: (value) {
                      controller.index.value = value;
                      _pageController.jumpToPage(value);
                    },
                    selectedIndex: controller.index.value,
                    tabs: const [
                      GButton(
                        icon: Icons.home,
                        text: "Home",
                        iconColor: Colors.white,
                      ),
                      GButton(
                        icon: Icons.folder,
                        text: "Analytics",
                        iconColor: Colors.white,
                      ),
                      GButton(
                        icon: Icons.device_hub_rounded,
                        text: "Products",
                        iconColor: Colors.white,
                      ),
                      GButton(
                        icon: Icons.person_2,
                        text: "Profile",
                        iconColor: Colors.white,
                      ),
                    ],
                    iconSize: 20,
                    activeColor: const Color.fromARGB(255, 189, 226, 255),
                  )),
            ),
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const PageScrollPhysics(),
        onPageChanged: (index) {
          controller.index.value = index;
        },
        children: [
          Home(),
          Analytics(),
          Device(),
          Profile(),
        ],
      ),
    );
  }
}
