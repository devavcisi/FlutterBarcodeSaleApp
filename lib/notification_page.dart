import 'package:easycoprombflutter/meeting_detail_page.dart';
import 'package:easycoprombflutter/share_function.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:date_field/date_field.dart';
import 'easy_search_bar.dart';
import 'gorusmeModel.dart';
import 'new_meeting.dart';
import 'config.dart' as config;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:easycoprombflutter/sepetModel.dart';
import 'home_page.dart';

String arayincaGetir = '';
String searchValue = '';
String bastar = "2022-01-01";
String bittar = "2024-01-01";
double tTutar = 0.0;
bool isLoading = false;
bool isLoadProducts = false;
double indirimMik = 0;
int counter = 0;
int tip = 0;
int butonaTikMi = 0;
DateTime Gbittar = DateTime.now();
DateTime Gbastar = DateTime.now().subtract(Duration(days: 3));

const List<String> list = <String>['Ziyaret', 'Telefon'];
DateTime? _startDate;
DateTime? _endDate;

class NotificationPage extends StatefulWidget {
  _NotificationPage createState() => _NotificationPage();
}

class _NotificationPage extends State<NotificationPage> {
  bool _isVisible = true;
  @override
  void changeVisibility(bool visible) {
    setState(() {
      _isVisible = visible;
    });
  }

  Future<List<GorusmeKart>> getozelgelenlerbilgi(
      bastar, bittar, uname, udealer, tip, deger) async {
    // List<GorusmeKart> persons = [];

    var response = await http.post(
        //http://sb.saloonburger.com.tr/v1/ sonrasında buna çevir
        Uri.parse(config.getApiUrl() +
            '/getGorusmeList?bastar=$bastar&bittar=$bittar&uname=$uname&udealer=$secilendealer&tip=$tip&deger=$deger'), //535XLMATMAVIBEYAZ001
        headers: <String, String>{
          'authorization': config.getbase64Authentication(),
          'Content-Type': 'application/json'
        });
    List<GorusmeKart> personaas = [];
    //var response = await http.get(  "http://sb.saloonburger.com.tr/v1/",headers: <String, String>{'authorization': basicAuth},
    //  print(response.statusCode);
    if (response.statusCode == 200) {
      //  List<GorusmeKart> persons = [];
      List<dynamic> movies = jsonDecode(response.body);
      //   List<Map<String, dynamic>> movies = jsonDecode(response.body);

      //print(movies.length);
      for (int i = 0; i < movies.length; i++) {
        personaas.add(GorusmeKart(
            gid: int.parse(movies[i]['gid']),
            gtipi: movies[i]['gtipi'],
            ganagrup: movies[i]['ganagrup'],
            galtgrup: movies[i]['galtgrup'],
            gmarka: movies[i]['gmarka'],
            gmodel: movies[i]['gmodel'],
            gtel: movies[i]['gtel'],
            gtarih: movies[i]['gtarih'],
            gfiyat: movies[i]['gfiyat'].toString(),
            gmusteri: movies[i]['gmusteri']));
      }
    }

    // print(persons);
    return personaas;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: EasySearchBar(
        backgroundColor: Colors.deepOrange,
        searchHintText: 'İsim/Tel No giriniz...',
        iconTheme: const IconThemeData(color: Colors.white),
        searchBackIconTheme: IconThemeData(color: Colors.deepOrange),
        title: const Text(
          'Görüşmelerim',
          style: TextStyle(color: Colors.white),
        ),
        onSearch: (value) {
          if (value == '') {
            setState(() {
              changeVisibility(_isVisible = true);
            });
          } else {
            setState(() {
              changeVisibility(_isVisible = false);
              searchValue = value;
              print(searchValue);
            });
          }
        },
        actions: <Widget>[
          IconButton(
            onPressed: () {
              shareFunction().showAlertSimple(
                  context,
                  "Görüşme Ekranı Nedir",
                  "Başlangıç ve bitiş tarihlerini seçerek o tarihler arasında yapmış olduğunuz görüşmeleri görütüleyebilirsiniz.",
                  "Tamam");
            },
            icon: const Icon(
              Icons.info_outline_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NewMeetings()));
          },
          icon: Icon(
            Icons.supervised_user_circle,
            color: Colors.white,
          ),
          backgroundColor: Colors.deepOrange,
          label: Text(
            "Yeni Görüşme",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: SafeArea(child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        final double maxWidth = constraints.maxWidth;
        final double maxHeight = constraints.maxHeight;
        final double cardHeight = maxHeight * 0.8;
        final double cardWidth = maxWidth * 0.8;

        return Center(
            child: SingleChildScrollView(
          child: Container(
            child: Column(children: <Widget>[
              SizedBox(
                height: maxHeight * 0.02,
              ),
              Container(
                margin: const EdgeInsets.only(
                    left: 10, bottom: 0, right: 0, top: 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: maxWidth * 0.46,
                          height: maxHeight * 0.1,
                          child: DateTimeFormField(
                            initialValue:
                                DateTime.now().subtract(Duration(days: 3)),
                            decoration: const InputDecoration(
                              hintStyle: TextStyle(color: Colors.black45),
                              errorStyle: TextStyle(color: Colors.redAccent),
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.event_note),
                              labelText: 'Başlangıç. tarihi',
                            ),
                            mode: DateTimeFieldPickerMode.date,
                            autovalidateMode: AutovalidateMode.always,
                            onDateSelected: (DateTime value) {
                              bastar = value.year.toString() +
                                  "-" +
                                  value.month.toString() +
                                  "-" +
                                  value.day.toString();
                              Gbastar = value;
                              print(value);
                            },
                          ),
                        ),
                        SizedBox(
                          width: maxWidth * 0.02,
                        ),
                        Container(
                          width: maxWidth * 0.46,
                          height: maxHeight * 0.1,
                          child: DateTimeFormField(
                            initialValue: DateTime.now(),
                            decoration: const InputDecoration(
                              hintStyle: TextStyle(color: Colors.black45),
                              errorStyle: TextStyle(color: Colors.redAccent),
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.event_note),
                              labelText: 'Bitiş Tarihi',
                            ),
                            mode: DateTimeFieldPickerMode.date,
                            autovalidateMode: AutovalidateMode.always,
                            onDateSelected: (DateTime value) {
                              bittar = value.year.toString() +
                                  "-" +
                                  value.month.toString() +
                                  "-" +
                                  value.day.toString();
                              Gbittar = value;
                              print(value);
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Visibility(
                          visible: _isVisible,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.deepOrange),
                            ),
                            onPressed: () {
                              arayincaGetir = searchValue;
                              if ((bittar != null &&
                                      Gbittar.isAfter(DateTime.now())) ||
                                  Gbastar.isAfter(Gbittar)) {
                                shareFunction().showAlertSimple(
                                    context,
                                    'Uyarı',
                                    'İleri tarih girilemez\nLütfen geçerli bir tarih aralığı giriniz',
                                    'Tamam');
                              } else {
                                print("Baslangıç: " +
                                    bastar +
                                    ", bittar $bittar");
                                setState(() {
                                  tip = 0;
                                  getozelgelenlerbilgi(
                                      bastar,
                                      bittar,
                                      gelenemail,
                                      secilendealer,
                                      tip,
                                      arayincaGetir);
                                });
                              }
                            },
                            child: const Text('Görüşme Getir',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        Visibility(
                          visible: !_isVisible,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.deepOrange),
                            ),
                            onPressed: () {
                              arayincaGetir = searchValue;
                              if ((bittar != null &&
                                      Gbittar.isAfter(DateTime.now())) ||
                                  Gbastar.isAfter(Gbittar)) {
                                shareFunction().showAlertSimple(
                                    context,
                                    'Uyarı',
                                    'İleri tarih girilemez\nLütfen geçerli bir tarih aralığı giriniz',
                                    'Tamam');
                              } else {
                                print("Baslangıç: " +
                                    bastar +
                                    ", bittar $bittar");
                                setState(() {
                                  tip = 1;
                                  getozelgelenlerbilgi(
                                      bastar,
                                      bittar,
                                      gelenemail,
                                      secilendealer,
                                      tip,
                                      arayincaGetir);
                                });
                              }
                            },
                            child: const Text('Görüşme Getir',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        SizedBox(
                          height: maxHeight * 0.02,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: maxHeight * 0.7,
                width: maxWidth * 0.95,
                child: Card(
                  color: Colors.grey.shade200,
                  elevation: 20,
                  shadowColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                  ),
                  child: FutureBuilder<List<GorusmeKart>>(
                      future: getozelgelenlerbilgi(bastar, bittar, gelenemail,
                          secilendealer, tip, arayincaGetir),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 3.0),
                                    child: Card(
                                      child: ListTile(
                                        title: Text(
                                            'Müşteri Adı: ' + item.gmusteri,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        subtitle: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: maxHeight * 0.02,
                                            ),
                                            Text(
                                                'Telefon Numarası: \n' +
                                                    item.gtel,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            SizedBox(
                                              height: maxHeight * 0.02,
                                            ),
                                            Text(
                                                'Verilen Teklif: ' +
                                                    item.gfiyat +
                                                    ' TL',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            SizedBox(
                                              height: maxHeight * 0.02,
                                            ),
                                            Text('Tarih: ' + item.gtarih,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            SizedBox(
                                              height: maxHeight * 0.02,
                                            ),
                                            Text(
                                                item.ganagrup +
                                                    '/ ' +
                                                    item.galtgrup +
                                                    '/ ' +
                                                    item.gmarka +
                                                    '/ ' +
                                                    item.gmodel,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            SizedBox(
                                              height: maxHeight * 0.03,
                                            ),
                                          ],
                                        ),
                                        trailing: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.green,
                                          ),
                                          child: Text(
                                            "Detay",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MeetingDetail(
                                                            item.gid)));
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                });
                      }),
                ),
              ),
            ]),
          ),
        ));
      })));
}
