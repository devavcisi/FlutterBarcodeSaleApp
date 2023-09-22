import 'package:flutter/cupertino.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';

class shareFunction extends StatefulWidget {
  @override
  void showAlertSimple(
      BuildContext contextB, String title, String info, String buttonText) {
    SimpleAlertBox(
        context: contextB,
        title: title,
        infoMessage: info,
        buttonText: buttonText);
  }

  State<StatefulWidget> createState() {
    throw UnimplementedError();
  }
}
