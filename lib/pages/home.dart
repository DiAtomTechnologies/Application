import 'dart:io';

import 'package:diatom/consts.dart';
import 'package:diatom/pages/AddDevice.dart';
import 'package:diatom/pages/chatbot/chat.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:diatom/models/article.dart';
import 'package:diatom/pages/Device.dart';
import 'package:diatom/pages/Profile.dart';
import 'package:diatom/pages/login_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Dio dio = Dio();
  List<Article> articles = [];

  @override
  void initState() {
    super.initState();
    _getNews();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 33, 59),
        centerTitle: true,
        title: Text(
          'Home',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // Change the drawer icon color to white
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 2, 33, 59), // Start color
                const Color.fromARGB(255, 2, 33, 59), // End color
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
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
        color: Colors.grey[300],
        child: ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];
            return GestureDetector(
              onTap: () => _launchUrl(Uri.parse(article.url ?? "")),
              child: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(126, 252, 157, 157),
                      Color.fromARGB(136, 14, 64, 105),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ListTile(
                    title: Text(
                      article.title ?? "",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    subtitle: Text(
                      article.publishedAt ?? "",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    leading: buildArticleImage(article),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildArticleImage(Article article) {
    return article.urlToImage != null
        ? Image.network(
            article.urlToImage!,
            height: 250,
            width: 100,
            fit: BoxFit.cover,
          )
        : Container(
            height: 250,
            width: 100,
            color: Colors.grey,
            child: const Icon(Icons.image_not_supported, color: Colors.white),
          );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _getNews() async {
    try {
      final response = await dio.get(
        'https://newsapi.org/v2/top-headlines?country=in&category=health&apiKey=${NEWS_API_KEY}',
      );

      final articlesJson = response.data["articles"] as List;
      setState(() {
        List<Article> newsArticle =
            articlesJson.map((a) => Article.fromJson(a)).toList();
        newsArticle = newsArticle.where((a) => a.title != "[Removed]").toList();
        articles = newsArticle;
      });
    } catch (e, stackTrace) {
      print("Error fetching news: $e");
      print("StackTrace: $stackTrace");
    }
  }
}
