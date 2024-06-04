import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'chatbot/chat.dart';
import 'AddDevice.dart';
import 'services/notification_controller.dart';

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  final TextEditingController _inputController = TextEditingController();
  List<BarChartGroupData> _barChartData = [];

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
    );
    _fetchDataPoints();
  }

  Future<void> _fetchDataPoints() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(user.uid)
          .collection("DataPoints")
          .orderBy("timestamp", descending: true)
          .limit(10)
          .get();

      List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      List<BarChartGroupData> barChartData = [];
      for (int i = 0; i < documents.length; i++) {
        double dataPoint = documents[i]['value'];
        barChartData.add(
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: dataPoint,
                color: dataPoint <= 5 ? Colors.red : Colors.blue,
                width: 16,
              ),
            ],
          ),
        );

        // Trigger notification if the data point is below 5
        if (dataPoint < 5) {
          AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: 1,
              channelKey: "basic_channel",
              title: "Health Notification",
              body: "Health threshold is going down",
            ),
          );
        }
      }

      setState(() {
        _barChartData = barChartData;
      });
    }
  }

  Future<void> _addDataPoint() async {
    final text = _inputController.text;
    if (text.isNotEmpty) {
      final data = double.tryParse(text);
      User? user = FirebaseAuth.instance.currentUser;
      if (data != null && user != null) {
        // Trigger notification immediately if the input value is less than or equal to 5
        if (data <= 5) {
          AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: 1,
              channelKey: "basic_channel",
              title: "Health Notification",
              body: "Health threshold is going down",
            ),
          );
        }

        CollectionReference dataPointsRef = FirebaseFirestore.instance
            .collection("Users")
            .doc(user.uid)
            .collection("DataPoints");

        await dataPointsRef.add({
          'value': data,
          'timestamp': FieldValue.serverTimestamp(),
        });

        _inputController.clear();
        _fetchDataPoints();
      }
    }
  }

  Future<void> _deleteAllDataPoints() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(user.uid)
          .collection("DataPoints")
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      setState(() {
        _barChartData = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 33, 59),
        centerTitle: true,
        title: Text(
          "Analytics",
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(165, 14, 64, 105),
              Color.fromARGB(255, 252, 157, 157),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                'Health Notification',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 4, 77, 8),
                  shadows: [
                    Shadow(
                      blurRadius: 4.0,
                      color: Colors.grey.withOpacity(0.5),
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _inputController,
                decoration: InputDecoration(
                  labelText: 'Enter Data Point',
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _addDataPoint(),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _addDataPoint,
                    child: Text(
                      'Add Data Point',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 12.0),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _deleteAllDataPoints,
                    child: Text(
                      'Delete All Data Points',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 12.0),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: BarChart(
                  BarChartData(
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              (value.toInt() + 1).toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      drawHorizontalLine: true,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.black,
                          strokeWidth: 0.5,
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: Colors.black,
                          strokeWidth: 0.5,
                        );
                      },
                    ),
                    barGroups: _barChartData,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health Analytics',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Analytics(),
    );
  }
}
