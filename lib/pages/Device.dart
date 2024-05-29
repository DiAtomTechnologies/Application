import 'package:flutter/material.dart';

class Device extends StatelessWidget {
  const Device({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 33, 59),
        title: Text(
          'Device',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/logo.png',
            height: 40.0,
            width: 40.0,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
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
