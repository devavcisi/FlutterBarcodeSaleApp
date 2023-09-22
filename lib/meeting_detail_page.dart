import 'dart:convert';
import 'config.dart' as config;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


import 'detayModel.dart';
import 'notification_page.dart';

String GTSecilenValue = "Telefon";
String inputGorusmeBaslik = "";
final df = new DateFormat('dd-MM-yyyy hh:mm a');
late int gid;

String dtyTipi = "";
String dtyAnaGrup = "";
String dtyAltGrup = "";
String dtyMarka = "";
String dtyModel = "";
String dtyMusteri = "";
String dtyTel = "";
String dtyAciklama = "";
String dtyDealer = "";
String dtyUsername = "";
double fiyat = 0;

List<DetayKart> dtyListe = [];

class MeetingDetail extends StatefulWidget {
  final int gelenid;
  @override
  _MeetingDetail createState() => _MeetingDetail();

  MeetingDetail(this.gelenid) {
    gid = this.gelenid;
  }
}

Future<List<DetayKart>> getDtyList(gid) async {
  var response = await http.post(
      Uri.parse(config.getApiUrl() + '/getGorusmebygid?gid=$gid'),
      headers: <String, String>{
        'authorization': config.getbase64Authentication(),
        'Content-Type': 'application/json'
      });
  //var response = await http.get(  "http://sb.saloonburger.com.tr/v1/",headers: <String, String>{'authorization': basicAuth},
  print(response.statusCode);
  print(response.body);
  print('/getGorusmebyid?gid=$gid');
  List<DetayKart> dtyListe = [];
  if (response.statusCode == 200) {

    List<dynamic> movies = jsonDecode(response.body);
    //   List<Map<String, dynamic>> movies = jsonDecode(response.body);

    //print(movies.length);
    for (int i = 0; i < movies.length; i++) {
      dtyListe.add(DetayKart(
        dtyid: int.parse(movies[i]['gid']),
        dtytipi: movies[i]['gtipi'],
        dtyanagrup: movies[i]['ganagrup'],
        dtyaltgrup: movies[i]['galtgrup'],
        dtymarka: movies[i]['gmarka'],
        dtymodel: movies[i]['gmodel'],
        dtytel: movies[i]['gtel'],
        dtyfiyat: movies[i]['gfiyat'].toString(),
        dtymusteri: movies[i]['gmusteri'],
        dtyaciklama: movies[i]['gaciklama'],
        dtydealer: movies[i]['gdealer'],
        dtyusername: movies[i]['gusername'].toString(),
        dtytarih: movies[i]['gtarih'],

      ));
    }

  }
  return dtyListe;

}

class _MeetingDetail extends State<MeetingDetail> {
  late Future<List<DetayKart>> _futureDtyList;
  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: Colors.deepOrange,
          title: Text("Görüşme Detayı",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        body: SafeArea(child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          final double maxWidth = constraints.maxWidth;
          final double maxHeight = constraints.maxHeight;
          final double cardHeight = maxHeight * 0.8;
          final double cardWidth = maxWidth * 0.8;

          return Center(
              child: Center(
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FutureBuilder<List<DetayKart>>(
                        future:  getDtyList(gid),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text(
                                    'An error occurred: ${snapshot.error}'));
                          } else if (!snapshot.hasData) {
                            return Center(child: Text('No data found.'));
                          } else {
                            final dtyListe = snapshot.data!;
                            return Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.deepOrange),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            Text("Görüşme Tipi:",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            SizedBox(
                                              width: maxWidth * 0.01,
                                            ),
                                            Text(dtyListe[0].dtytipi,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                )),
                                          ],
                                        ),
                                        SizedBox(
                                          height: maxHeight * 0.03,
                                        ),
                                        Text(
                                          "Müşteri İsmi: ",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: maxHeight * 0.01,
                                        ),
                                        Text(
                                          dtyListe[0].dtymusteri,
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(
                                          height: maxHeight * 0.03,
                                        ),
                                        Text(
                                          "Telefon Numarası: ",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: maxHeight * 0.01,
                                        ),
                                        Text(
                                          dtyListe[0].dtytel,
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(
                                          height: maxHeight * 0.03,
                                        ),
                                        Text(
                                          "Verilen Fiyat: ",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: maxHeight * 0.01,
                                        ),
                                        Text(
                                          dtyListe[0].dtyfiyat,
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),

                                        ),
                                        SizedBox(
                                          height: maxHeight * 0.01,
                                        ),
                                        Text(
                                          "Tarih: ",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),

                                        SizedBox(
                                          height: maxHeight * 0.01,
                                        ),
                                        Text(
                                          df.format(new DateTime.fromMillisecondsSinceEpoch(dtyListe[0].dtytarih )),

                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(
                                          height: maxHeight * 0.01,
                                        ),
                                        Text(
                                          "Açıklama: ",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: maxHeight * 0.01,
                                        ),
                                        Text(
                                          dtyListe[0].dtyaciklama,
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(
                                          height: maxHeight * 0.03,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              border: Border.all(
                                                  color: Colors.deepOrange),
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text("Ana Grup:",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        SizedBox(
                                                          width:
                                                              maxWidth * 0.02,
                                                          height:
                                                              maxHeight * 0.02,
                                                        ),
                                                        Text(
                                                            dtyListe[0]
                                                                .dtyanagrup,
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                            )),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: maxWidth * 0.1,
                                                    ),
                                                    Column(
                                                      children: [
                                                        Text("Alt Grup:",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        SizedBox(
                                                          width:
                                                              maxWidth * 0.02,
                                                          height:
                                                              maxHeight * 0.02,
                                                        ),
                                                        Text(
                                                            dtyListe[0]
                                                                .dtyaltgrup,
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                            )),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: maxHeight * 0.033,
                                                ),
                                                Row(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text("Marka:",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        SizedBox(
                                                          width:
                                                              maxWidth * 0.03,
                                                          height:
                                                              maxHeight * 0.03,
                                                        ),
                                                        Text(
                                                            dtyListe[0]
                                                                .dtymarka,
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                            )),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: maxWidth * 0.17,
                                                    ),
                                                    Column(
                                                      children: [
                                                        Text("Model:",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        SizedBox(
                                                          width:
                                                              maxWidth * 0.02,
                                                          height:
                                                              maxHeight * 0.02,
                                                        ),
                                                        Text(
                                                            dtyListe[0]
                                                                .dtymodel,
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                            )),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: maxHeight * 0.06,
                                        ),
                                        SizedBox(
                                          height: maxHeight * 0.06,
                                        )
                                      ]),
                                ));
                          }
                        }))),
          ));
        })));
  }
}
