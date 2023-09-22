import 'package:easycoprombflutter/home_page.dart';
import 'package:easycoprombflutter/okutulanModel.dart';
import 'package:easycoprombflutter/share_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'config.dart' as config;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class BarcodeScannerPage extends StatefulWidget {
  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  String _barcode = '';

  Future<void> _scanBarcode() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE);

    setState(() {
      _barcode = barcodeScanRes;
      getOkutulanlar(_barcode);
      //gidip barco app çalıştırmanız gereken bölüm burası
      //print("okutulan"+_barcode);
    });
  }

  Future addSepet(sid, BuildContext contextB) async {
    var response = await http.post(
        //http://sb.saloonburger.com.tr/v1/ sonrasında buna çevir
        //Uri.parse(config.getApiUrl() + '/getBarcodeSearchMotorBurdaApp?headersubeselect=$secilendealer&gelendegerbarcode=535XLMATMAVIBEYAZ001'),
        Uri.parse(config.getApiUrl() +
            '/setSepetAdd?headersubeselect=$secilendealer&uname=$gelenemail&sid=$sid'),
        headers: <String, String>{
          'authorization': config.getbase64Authentication()
        });
    //var response = await http.get(  "http://sb.saloonburger.com.tr/v1/",headers: <String, String>{'authorization': basicAuth},

    if (response.statusCode == 200) {
      String gelenbody = response.body;
      if (gelenbody.contains("ok")) {
        shareFunction().showAlertSimple(
            contextB, 'Sepet', 'Ürün Başarıyla Sepete Eklendi', 'Tamam');
      } else {
        shareFunction().showAlertSimple(contextB, 'Hata', gelenbody, 'Tamam');
      }
    } else {}
  }

  Future<List<StokKarti>> getOkutulanlar(deger) async {
    List<StokKarti> persons = [];

    var response = await http.get(
        //http://sb.saloonburger.com.tr/v1/ sonrasında buna çevir
        Uri.parse(config.getApiUrl() +
            '/getBarcodeSearchMotorBurdaApp?headersubeselect=$secilendealer&gelendegerbarcode=$deger'), //535XLMATMAVIBEYAZ001
        headers: <String, String>{
          'authorization': config.getbase64Authentication(),
          'Content-Type': 'application/json'
        });
    //var response = await http.get(  "http://sb.saloonburger.com.tr/v1/",headers: <String, String>{'authorization': basicAuth},

    if (response.statusCode == 200) {
      List<dynamic> movies = jsonDecode(response.body);
      for (int i = 0; i < movies.length; i++) {
        persons.add(StokKarti(
            sid: movies[i]['sid'],
            sadi: movies[i]['sadi'],
            skodu: movies[i]['skodu'],
            sanagrup: movies[i]['sanagrup'],
            saltgrup: movies[i]['saltgrup'],
            sozelgrup: movies[i]['sozelgrup'],
            sdepokodu: movies[i]['sdepokodu'],
            smuhkod: movies[i]['smuhkod'],
            sbirimfiyati: movies[i]['sbirimfiyati']));
      }
    }

    return persons;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
        child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double maxWidth = constraints.maxWidth;
          final double maxHeight = constraints.maxHeight;
          final double cardHeight = maxHeight * 0.8;
          final double cardWidth = maxWidth * 0.8;

          return Center(
            child: FutureBuilder<List<StokKarti>>(
                future: getOkutulanlar(_barcode),
                builder: (BuildContext context, snapshot) {
                  return snapshot.data == null
                      ? const Center(
                    child: CircularProgressIndicator(),
                  )
                      : ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var item = snapshot.data![index];
                        return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Card(
                            child: ListTile(
                              title: Text(item.skodu.toString(),
                                  style:
                                  TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: maxHeight*0.04,
                                  ),
                                  Text(item.sadi,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: maxHeight*0.04,
                                  ),
                                  Text(
                                    "Ana Grup/ Alt Grup: " +
                                        item.sanagrup +
                                        "/" +
                                        item.saltgrup,
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: maxHeight*0.04,
                                  ),
                                  Text(
                                    "Marka/ Beden: " +
                                        item.sdepokodu +
                                        "/" +
                                        item.smuhkod,
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: maxHeight*0.04,
                                  ),
                                  Text(
                                    "Renk: " + item.sozelgrup,
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: maxHeight*0.04,
                                  ),
                                  Text(
                                    "Fiyat: " +
                                        item.sbirimfiyati.toString() +
                                        " TL",
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: maxHeight*0.04,
                                  ),
                                ],
                              ),
                              trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                ),
                                child: Icon(Icons.add_shopping_cart),
                                onPressed: () {
                                  addSepet(item.sid, context);
                                  //deleteetokutulan(item.sh_id.toString());
                                },
                              ),
                            ),
                          ),
                        );
                      });
                }),
          );

        }),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: FloatingActionButton.extended(
            onPressed: () {
              _scanBarcode();
            },
            icon: Icon(
              Icons.qr_code_scanner,
              color: Colors.white,
            ),
            backgroundColor: Colors.deepOrange,
            label: Text(
              'Tarama Başlat',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ));
  }
}
