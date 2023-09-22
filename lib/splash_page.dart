

import 'package:easycoprombflutter/home_page.dart';
import 'package:easycoprombflutter/login_page.dart';
import 'package:flutter/material.dart';



class SplashScreenState extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreenState> {
  @override
  void initState() {

    String gelenbody = "";
    super.initState();
    // Add any initialization logic here
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => home_page(gelenbody: gelenbody, email: email, password: password)),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    // Add your splash screen UI here
    return Scaffold(

      body: Container(
        decoration: const BoxDecoration(
        gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Colors.blue,
          Colors.deepOrangeAccent,
        ],
      )
      ),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 200,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(1500.0),
                child: Container(
                  width: 300,
                  height: 300,
                  child: const Image(
                    image: AssetImage('assets/images/dcdee84e-cde4-4ac8-9a08-7e4d531879d6.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 200,
              ),
              Text("Developed By İbaysoft Developers", style: TextStyle(color: Colors.grey,fontSize: 25),)
            ],
          )
        ),
      ),
    );
  }
}