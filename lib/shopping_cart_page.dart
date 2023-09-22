import 'dart:convert';

import 'package:easycoprombflutter/sepetModel.dart';
import 'package:easycoprombflutter/sepet_onay.dart';
import 'package:easycoprombflutter/share_function.dart';
import 'package:flutter/material.dart';
import 'config.dart' as config;
import 'package:http/http.dart' as http;

import 'home_page.dart';

double tTutar = 0.0;
bool isLoading = false;
bool isLoadProducts = false;
double indirimMik = 0;
int counter = 0;

class ShoppingCartPage extends StatefulWidget {
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  @override
  void initState() {
    toplamTutar();
  }

  var response;
  void toplamTutar() async {
    response = await http.post(
        //http://sb.saloonburger.com.tr/v1/ sonrasında buna çevir
        Uri.parse(config.getApiUrl() +
            '/GetirSepetListesiApp?headersubeselect=$secilendealer&uname=$gelenemail'), //535XLMATMAVIBEYAZ001
        headers: <String, String>{
          'authorization': config.getbase64Authentication(),
          'Content-Type': 'application/json'
        });
    if (response.statusCode == 200) {
      //print(response.body);
      List<dynamic> movies = jsonDecode(response.body);
      tTutar = 0;
      counter = 0;
      for (int i = 0; i < movies.length; i++) {
        counter += 1;
        tTutar += (movies[i]['spfiyat'] - movies[i]['spindirim']);
      }
      setState(() {
        tTutar;
        counter;
      });
    }
  }

  Future<List<SepetKart>> getOkutulanlar() async {
    List<SepetKart> persons = [];

    //var response = await http.get(  "http://sb.saloonburger.com.tr/v1/",headers: <String, String>{'authorization': basicAuth},
    //  print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      List<dynamic> movies = jsonDecode(response.body);
      tTutar = 0;

      for (int i = 0; i < movies.length; i++) {
        persons.add(SepetKart(
            spid: movies[i]['spid'],
            spkodu: movies[i]['spkodu'],
            spkadi: movies[i]['spkadi'],
            spstokid: movies[i]['spstokid'],
            spsasi: movies[i]['spsasi'],
            spfiyat: movies[i]['spfiyat'],
            spindirim: movies[i]['spindirim'],
            spuser: movies[i]['spuser'],
            spdealer: movies[i]['spdealer'],
            spcikisid: movies[i]['spcikisid'],
            spyedekint: movies[i]['spyedekint'],
            spyedekstring: movies[i]['spyedekstring'],
            spyedekfloat: movies[i]['spyedekfloat']));
        tTutar += movies[i]['spfiyat'];
      }
    }

    return persons;
  }

  Future deleteetokutulan(spid) async {
    // print(spid.toString()+"gelen");
    var response = await http.post(
        //http://sb.saloonburger.com.tr/v1/ sonrasında buna çevir
        Uri.parse(config.getApiUrl() +
            '/setSepetDeleteApp?headersubeselect=$secilendealer&spid=$spid'), //535XLMATMAVIBEYAZ001
        headers: <String, String>{
          'authorization': config.getbase64Authentication(),
          'Content-Type': 'application/json'
        });
    //var response = await http.get(  "http://sb.saloonburger.com.tr/v1/",headers: <String, String>{'authorization': basicAuth},
    // print(response.statusCode);
    if (response.statusCode == 200) {
      //print(response.body);
      setState(() {
        toplamTutar();
        getOkutulanlar();
        isLoading = false;
        //gidip barco app çalıştırmanız gereken bölüm burası
        //print("okutulan"+_barcode);
      });
    }
  }

  Future indirimekle(spid, newfiyat, contextB) async {
    // print(spid.toString()+"gelen");
    var response = await http.post(
        //http://sb.saloonburger.com.tr/v1/ sonrasında buna çevir
        Uri.parse(config.getApiUrl() +
            '/SetStokSatisFiyatlariCekUpdateSepet?dealer=$secilendealer&uname=$gelenemail&spid=$spid&newfiyat=$newfiyat'), //535XLMATMAVIBEYAZ001
        headers: <String, String>{
          'authorization': config.getbase64Authentication(),
          'Content-Type': 'application/json'
        });
    //var response = await http.get(  "http://sb.saloonburger.com.tr/v1/",headers: <String, String>{'authorization': basicAuth},
    // print(response.statusCode);
    if (response.statusCode == 200) {
      // shareFunction().showAlertSimple(contextB,'Bilgi', response.body, 'Tamam');
      if (response.body.contains("ok")) {
        setState(() {
          toplamTutar();
          getOkutulanlar();
          isLoading = false;
          //gidip barco app çalıştırmanız gereken bölüm burası
          //print("okutulan"+_barcode);
        });
      } else {
        shareFunction()
            .showAlertSimple(contextB, 'Hata', response.body, 'Tamam');
      }
      //print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          automaticallyImplyLeading: false,
          title: Text(
            "Toplam Tutar: $tTutar",
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                setState(() {
                  toplamTutar();
                });
              },
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: SafeArea(

          child: LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      final double maxWidth = constraints.maxWidth;
      final double maxHeight = constraints.maxHeight;
      final double cardHeight = maxHeight * 0.8;
      final double cardWidth = maxWidth * 0.8;

      return Center(
        child: FutureBuilder<List<SepetKart>>(
            future: getOkutulanlar(),
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
                          title: Text(item.spkodu.toString(),
                              style:
                              TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: maxHeight*0.04,
                              ),
                              Text(item.spkadi,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: maxHeight*0.04,
                              ),
                              Text(
                                "Şasi/ Danışman: " +
                                    item.spsasi +
                                    "/" +
                                    item.spuser,
                                style:
                                TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: maxHeight*0.02,
                              ),
                              Container(
                                width: cardWidth,
                                child: Card(
                                  color: Colors.grey.shade50,
                                  child: TextField(
                                    decoration: InputDecoration(
                                        hintText: "İndirim Tutarı Giriniz"),
                                    onChanged: (value) {
                                      indirimMik = double.parse(value);
                                    },
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.lightGreen.shade800,
                                ),
                                child: Text(
                                  "Güncelle",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  indirimekle(
                                      item.spid, indirimMik, context);
                                },
                              ),
                              SizedBox(
                                height: maxHeight*0.04,
                              ),
                              Text(
                                "Fiyat: " +
                                    (item.spfiyat - item.spindirim)
                                        .toString() +
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
                              primary: Colors.red,
                            ),
                            child: isLoading
                                ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                                : Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              //  addSepet(item.sid, context);
                              setState(() {
                                isLoading = true;
                              });
                              deleteetokutulan(item.spid);
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
              if (counter > 0) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => sepetOnay()));
              } else {
                shareFunction().showAlertSimple(context, "Uyarı", "Sepetinize ürün ekleyiniz veya sayfayı yenileyiniz", "Tamam");
              }
            },
            icon: Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
            backgroundColor: Colors.deepOrange,
            label: Text(
              "Sepeti Onayla",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ));
  }
}
