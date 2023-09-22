import 'package:easycoprombflutter/login_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add any initialization logic here
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage(title: "easycoPro Giriş Sayfası")),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Add your splash screen UI here
    return Scaffold(
      body: Container(
        child: Center(
            child: Column(
          children: [
            SizedBox(
              height: 200,
            ),
            Container(
              width: 200,
              height: 200,
              child: const Image(
                image: AssetImage('assets/images/easylogo.png'),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 325,
            ),
            Text(
              "Developed By İbaysoft",
              style: TextStyle(color: Colors.grey.shade700, fontSize: 20),
            )
          ],
        )),
      ),
    );
  }
}
