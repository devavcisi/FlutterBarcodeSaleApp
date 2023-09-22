import 'dart:convert';

import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';

import 'package:easycoprombflutter/login_page.dart';
import 'package:easycoprombflutter/scan_page.dart';
import 'package:easycoprombflutter/shopping_cart_page.dart';
import 'sepet_onay.dart';
import 'package:flutter/material.dart';
import 'config.dart' as config;
import 'package:http/http.dart' as http;
import 'notification_page.dart';

String gelenbodybilgi = "";
String gelenbodybilgifirma = "";
String gelenemail = "";
String gelenpassword = "";
String secilendealer = "";
List<dynamic> bodyjson = [];
List<String> bodyjsonBayiIsimleri = [];
List<String> bodyjsonBayiDealer = [];

class home_page extends StatelessWidget {
  home_page({
    super.key,
    required this.gelenbody,
    required this.email,
    required this.password,
  });

  final String gelenbody;
  final String email;
  final String password;

  @override
  Widget build(BuildContext context) {
    gelenbodybilgi = gelenbody;
    gelenemail = email;
    gelenpassword = password;

    List<String> splitted = gelenbodybilgi.split(',');
    gelenbodybilgifirma = splitted[0];
    secilendealer = splitted[1];
    gelenBayiListesi();
    return Scaffold(
      body: DynamicChange(),
    );
  }
}

class DynamicChange extends StatefulWidget {
  @override
  StateDynamic createState() => StateDynamic();
}

Future gelenBayiListesi() async {
  bodyjsonBayiIsimleri = [];
  bodyjsonBayiDealer = [];
  var response = await http.get(
      Uri.parse(config.getApiUrl() +
          '/ListSubebyusername?uname=' +
          gelenemail +
          '&upass=' +
          gelenpassword),
      headers: <String, String>{
        'authorization': config.getbase64Authentication()
      });

  bodyjson = jsonDecode(response.body);
  for (int i = 0; i < bodyjson.length; i++) {
    bodyjsonBayiIsimleri.add(bodyjson[i]['usubelistsubename']);
    bodyjsonBayiDealer.add(bodyjson[i]['usubelistsubedealer']);
    //print(bodyjsonBayiDealer[i]);
  }
}

class StateDynamic extends State<DynamicChange> {
  int currentIndex = 1;
  final screens = [
    NotificationPage(),
    BarcodeScannerPage(),
    ShoppingCartPage(),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: Text(gelenbodybilgifirma),
        foregroundColor: Colors.deepOrange,
        //automaticallyImplyLeading: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.exit_to_app,
                size: 35,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),

        shadowColor: Colors.deepOrange,
        actions: <Widget>[
          //Center(child: Text("Bayi")),
          PopupMenuButton(
            // add icon, by default "3 dot" icon

            icon: Icon(Icons.store_outlined),
            itemBuilder: (context) {
              return List.generate(
                bodyjsonBayiIsimleri.length,
                (index) => PopupMenuItem(
                  value: bodyjsonBayiDealer[index] + "#" + index.toString(),
                  child: Text(bodyjsonBayiIsimleri[index]),
                ),
              );
            },
            onSelected: (Text) {
              setState(() {
                List<String> getirbilgi = Text.split('#');
                gelenbodybilgifirma =
                    bodyjsonBayiIsimleri[int.parse(getirbilgi[1])];
                secilendealer = getirbilgi[0];
              });
              // print(Text);
            },
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white60,
        color: Colors.deepOrange,
        animationDuration: const Duration(milliseconds: 400),
        index: currentIndex,
        items: [
          CurvedNavigationBarItem(
            child: Icon(
              Icons.supervised_user_circle,
              color: Colors.white,
              size: 35,
            ),
            label: 'Görüşme',
            labelStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.qr_code_scanner, color: Colors.white, size: 35),
            label: 'Tara',
            labelStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.shopping_cart_outlined,
                color: Colors.white, size: 35),
            label: 'Sepetim',
            labelStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ],
        onTap: (index) => setState(() => currentIndex = index),
      ),
      body: screens[currentIndex],
    );
  }
}
