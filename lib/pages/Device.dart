import 'package:diatom/pages/AddDevice.dart';
import 'package:diatom/pages/chatbot/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Device extends StatelessWidget {
  const Device({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 33, 59),
        centerTitle: true,
        title: Text(
          "Device",
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/logo.png',
              height: 30.0,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 252, 157, 157), // Start color
                Color.fromARGB(165, 14, 64, 105), // End color
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  user?.displayName ?? 'User',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(
                  user?.email ?? 'No Email',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(165, 14, 64, 105), // Start color
                      Color.fromARGB(255, 252, 157, 157), // End color
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              ListTile(
                leading:
                    Icon(Icons.chat, color: Colors.white), // Set the color here
                title: Text(
                  'ChatBot',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatPage()),
                  );
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.add, color: Colors.white), // Set the color here
                title: Text(
                  'AddDevice',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddDevice()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          _buildCard(
            context,
            'VENTILATORS',
            'Ensuring Optimal Oxygen Delivery for Critical Care',
            'We are dedicated to advancing respiratory care with our state-of-the-art ventilators, designed to deliver oxygen with unparalleled precision. Our aim is to support healthcare professionals in providing the highest standard of care to patients in need of respiratory support.',
          ),
          _buildCard(
            context,
            'BIO-PRINTERS',
            'Revolutionizing the Future of Healthcare',
            'Our cutting-edge bioprinters, designed to revolutionize the field of tissue engineering and regenerative medicine. Our commitment to technological excellence drives us to create solutions that push the boundaries of what\'s possible in healthcare.',
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
      BuildContext context, String title, String subtitle, String description) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 14, 64, 105),
              Color.fromARGB(255, 252, 157, 157),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 20,
              blurRadius: 50,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 100,
                    height: 100,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                description,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
