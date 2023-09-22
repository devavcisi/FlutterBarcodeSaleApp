import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class deneme_page extends StatefulWidget {
  const deneme_page({Key? key}) : super(key: key);

  @override
  State<deneme_page> createState() => _deneme_page();
}

class _deneme_page extends State<deneme_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('EasycoPro'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(onPressed: (){}, icon: const Icon(Icons.exit_to_app))
        ],

      ),
      body: const Center(
        child: Text(
          'Deneme ekranı',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
