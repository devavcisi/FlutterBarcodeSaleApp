import 'package:easycoprombflutter/login_page.dart';
import 'package:easycoprombflutter/splash_page.dart';
import 'package:easycoprombflutter/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

bool _wrongEmail = false;
bool _wrongPassword = false;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'easycoPro Report App',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: SplashScreen(),
    );
  }
}
