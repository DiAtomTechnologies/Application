import 'package:diatom/pages/AddDevice.dart';
import 'package:diatom/pages/chatbot/chat.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'login_page.dart';

class Profile extends StatelessWidget {
  Profile({Key? key}) : super(key: key);

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    Future<Map<String, dynamic>> _fetchUserData() async {
      Map<String, dynamic> userData = {};

      if (user != null) {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection("Users")
            .doc(user.uid)
            .get();
        userData = snapshot.data() as Map<String, dynamic>;
      }
      return userData;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 33, 59),
        centerTitle: true,
        title: Text(
          "Profile",
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .doc(user!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || !snapshot.data!.exists) {
                  // If user data doesn't exist, show default profile
                  return _buildDefaultProfile(user);
                } else {
                  Map<String, dynamic> userData =
                      snapshot.data?.data() as Map<String, dynamic>;
                  return _buildUserProfile(context, user, userData);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultProfile(User? user) {
    return Container(
      color: Colors.grey[300],
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.person,
                  size: 160,
                  color: Color.fromARGB(255, 14, 64, 105),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.person_outline),
                    Text(
                      user?.displayName ?? 'No Name',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                  ],
                ),
                SizedBox(height: 25),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.email),
                      Text(
                        'Email: ${user?.email}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 5),
                      ListTile(
                        leading: Icon(Icons.logout),
                        title: Text('Log Out'),
                        onTap: () => signUserOut(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfile(
      BuildContext context, User? user, Map<String, dynamic> userData) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(165, 14, 64, 105),
            Color.fromARGB(255, 252, 157, 157),
          ],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person,
                      size: 160,
                      color: Color.fromARGB(255, 14, 64, 105),
                    ),
                    SizedBox(height: 10),
                    Text(
                      user?.displayName ?? 'No Name',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Email: ${user?.email}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 20,
              thickness: 2,
              color: Colors.grey,
            ),
            ListTile(
              leading: Icon(Icons.email, color: Colors.white),
              title: Text(
                userData['Email'] ?? 'No Email',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              leading: Icon(Icons.phone, color: Colors.white),
              title: Text(
                userData['Phone'] ?? 'No Phone',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => _showPhoneDialog(context),
            ),
            ListTile(
              leading: Icon(Icons.notes, color: Colors.white),
              title: Text(
                userData['Bio'] ?? 'No Bio',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => _showBioDialog(context),
            ),
            /*ListTile(
              leading: Icon(Icons.delete_forever, color: Colors.white),
              title: Text(
                'Delete Account',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => _deleteAccount(context),
            ),*/
            ListTile(
              leading: Icon(Icons.logout, color: Colors.white),
              title: Text(
                'Log Out',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => signUserOut(),
            ),
            buildAboutContent(),
          ],
        ),
      ),
    );
  }

  void _showPhoneDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color.fromARGB(255, 90, 181, 255),
        title: Text(
          'Update Phone',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter new phone number:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                hintText: 'New phone number',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _updatePhone(_phoneController.text);
              Navigator.pop(context);
            },
            child: Text(
              'Update',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBioDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color.fromARGB(255, 90, 181, 255),
        title: Text(
          'Update Bio',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter new bio:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _bioController,
              decoration: InputDecoration(
                hintText: 'New bio',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _updateBio(_bioController.text);
              Navigator.pop(context);
            },
            child: Text(
              'Update',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updatePhone(String newPhone) {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection("Users").doc(user.uid).update({
        "Phone": newPhone,
      });
    }
  }

  void _updateBio(String newBio) {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection("Users").doc(user.uid).update({
        "Bio": newBio,
      });
    }
  }

  void _deleteAccount(BuildContext context) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color.fromARGB(255, 242, 178, 178),
          title: Text(
            'Confirm Account Deletion',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete your account? This action cannot be undone, and you will not be able to recover your data or access your account again.',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                _deleteUserAccount(user);
              },
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  void _deleteUserAccount(User user) async {
    try {
      final String uid = user.uid;

      // Delete the user document from Firestore
      await FirebaseFirestore.instance.collection("Users").doc(uid).delete();

      // Delete the user from Firebase Authentication
      await user.delete();

      // Sign out the user
      signUserOut();

      // Navigate to the login page
      Get.offAll(() => LoginPage());
    } catch (e) {
      print("Error deleting account: $e");
    }
  }
}

void signUserOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    await _googleSignIn.signOut();

    Get.offAll(() => LoginPage());
  } catch (e, stackTrace) {
    print("Error signing out: $e");
    print("StackTrace: $stackTrace");
  }
}

Widget buildAboutContent() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
// About page content
        SizedBox(height: 20.0),
        Image.asset(
          'assets/images/logo.png',
          height: 150.0,
        ),
        SizedBox(height: 20.0),
        Center(
          child: Text(
            'DiAtom Technologies Mission',
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Saving lives globally by addressing critical respiratory needs, we design, produce, and distribute innovative ventilators inspired by the challenges of the COVID-19 era.',
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 20.0),
        Center(
          child: Text(
            'DiAtom Technologies Vision',
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Pioneering industry envision a future where our advanced respiratory solutions ensure universal access to life-saving care, making a lasting impact on global healthcare resilience.',
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}

