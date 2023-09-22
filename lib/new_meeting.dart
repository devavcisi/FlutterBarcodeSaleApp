import 'dart:convert';
import 'package:easycoprombflutter/share_function.dart';

import 'home_page.dart';
import 'package:easycoprombflutter/denemeModel.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'config.dart' as config;
import 'package:http/http.dart' as http;

String GTSecilenValue = "Ziyaret";
var dropdownAnagrupValue;
var dropdownAltgrupValue;
String AGSecilenValue = "deneme";
String inputGorusmeIsim = "";
double inputGorusmeFiyat = 0.0;
String inputGorusmeTel = "";
String inputGorusmeAciklama = "";
late String initialDropDownVal;
late int selectedIndex;
bool isloading = true;
String secilenilkgrup = "MOTOR";
String secilenilkaltgrup = "ADVENTURE";
String secilenilkmarkagrup = "BENELLI";
String secilenmodelgrup = "TRK 502X";

class NewMeetings extends StatefulWidget {
  @override
  _NewMeetings createState() => _NewMeetings();
}

class _NewMeetings extends State<NewMeetings> {
  bool isSendLoading = false;
  Future<List<denemeModel>> gelenAnagrupListesi() async {
    var response = await http.post(
        Uri.parse(config.getApiUrl() + '/getAnagrup?'),
        headers: <String, String>{
          'authorization': config.getbase64Authentication()
        });
    //print(response.body);
    List<denemeModel> persons = [];
    List<dynamic> movies = jsonDecode(response.body);

    // bodyjson = jsonDecode(response.body);
    for (int i = 0; i < movies.length; i++) {
      persons.add(denemeModel(
          name: movies[i]['fieldname'], username: movies[i]['fieldname']));
    }
    return persons;
  }

  Future setGorusme(gorusmeTipi, anaGrup, altGrup, marka, model, musTel,
      musIsim, aciklama, uname, udealer, gfiyat) async {
    // print(spid.toString()+"gelen");
    var body = jsonEncode({
      'data': {
        'gorusmeTipi': gorusmeTipi,
        'anaGrup': anaGrup,
        'altGrup': altGrup,
        'marka': marka,
        'model': model,
        'musTel': musTel,
        'musIsim': musIsim,
        'aciklama': aciklama,
        'uname': uname,
        'udealer': udealer,
        'gfiyat': gfiyat
      }
    });
    var response = await http.post(
        //http://sb.saloonburger.com.tr/v1/ sonrasında buna çevir
        Uri.parse(config.getApiUrl() + '/setGorusme'), //535XLMATMAVIBEYAZ001
        headers: <String, String>{
          'authorization': config.getbase64Authentication(),
          'Content-Type': 'application/json'
        },
        body: body);
    setState(() {
      isSendLoading = false;
    });
    //var response = await http.get(  "http://sb.saloonburger.com.tr/v1/",headers: <String, String>{'authorization': basicAuth},
    // print(response.statusCode);
  }

  Future<List<denemeModel>> gelenAltgrupListesi(anagrup) async {
    var response = await http.post(
        Uri.parse(config.getApiUrl() + '/getAltgrup?anagrup=$anagrup'),
        headers: <String, String>{
          'authorization': config.getbase64Authentication()
        });

    List<denemeModel> persons = [];
    List<dynamic> movies = jsonDecode(response.body);

    // bodyjson = jsonDecode(response.body);
    int varmi = 0;
    for (int i = 0; i < movies.length; i++) {
      if (movies[i]['fieldname'] == secilenilkaltgrup) {
        varmi = 1;
      }
      persons.add(denemeModel(
          name: movies[i]['fieldname'], username: movies[i]['fieldname']));
    }
    if (movies.length > 0) {
      if (varmi == 0) {
        secilenilkaltgrup = movies[0]['fieldname'];
      }
    } else {
      secilenilkaltgrup = "ADVENTURE";
    }

    return persons;
  }

  Future<List<denemeModel>> getMarkaListesi(anagrup, altgrup) async {
    var response = await http.post(
        Uri.parse(
            config.getApiUrl() + '/getMarka?anagrup=$anagrup&altgrup=$altgrup'),
        headers: <String, String>{
          'authorization': config.getbase64Authentication()
        });

    //  print(response.body);
    List<denemeModel> persons = [];
    List<dynamic> movies = jsonDecode(response.body);
    int varmi = 0;
    // bodyjson = jsonDecode(response.body);
    for (int i = 0; i < movies.length; i++) {
      if (movies[i]['fieldname'] == secilenilkmarkagrup) {
        varmi = 1;
      }
      persons.add(denemeModel(
          name: movies[i]['fieldname'], username: movies[i]['fieldname']));
    }

    if (movies.length > 0) {
      if (varmi == 0) {
        secilenilkmarkagrup = movies[0]['fieldname'];
      }
    } else {
      secilenilkmarkagrup = "ADVENTURE";
    }
    return persons;
  }

  Future<List<denemeModel>> getModelListesi(anagrup, altgrup, marka) async {
    var response = await http.post(
        Uri.parse(config.getApiUrl() +
            '/getModel?anagrup=$anagrup&altgrup=$altgrup&marka=$marka'),
        headers: <String, String>{
          'authorization': config.getbase64Authentication()
        });

    //  print(response.body);
    List<denemeModel> persons = [];
    List<dynamic> movies = jsonDecode(response.body);

    int varmi = 0;
    // bodyjson = jsonDecode(response.body);
    for (int i = 0; i < movies.length; i++) {
      if (movies[i]['fieldname'] == secilenmodelgrup) {
        varmi = 1;
      }
      persons.add(denemeModel(
          name: movies[i]['fieldname'], username: movies[i]['fieldname']));
    }
    if (movies.length > 0) {
      if (varmi == 0) {
        secilenmodelgrup = movies[0]['fieldname'];
      }
    } else {
      secilenmodelgrup = "ADVENTURE";
    }
    return persons;
  }

  var maskFormatter = MaskTextInputFormatter(
      mask: '0##########',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: Colors.deepOrange,
          title: Text("Görüşme",
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
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Text("Ana Grup :",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: maxWidth * 0.01,
                        ),
                        Card(
                          color: Colors.deepOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: FutureBuilder<List<denemeModel>>(
                                future: gelenAnagrupListesi(),
                                builder: (BuildContext context, snapshot) {
                                  return snapshot.data == null
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : DropdownButton<String>(
                                          hint: Text("Anagrup Seçiniz"),
                                          dropdownColor: Colors.deepOrange,
                                          value: secilenilkgrup,
                                          onChanged: (value) {
                                            print(value.toString());
                                            setState(() {
                                              isloading = true;
                                              secilenilkgrup = value.toString();
                                            });
                                          },
                                          items: snapshot.data!
                                              .map((fc) =>
                                                  DropdownMenuItem<String>(
                                                    child: Text(
                                                      fc.name,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    value: fc.name,
                                                  ))
                                              .toList(),
                                        );
                                },
                              )),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Alt Grup :",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: maxWidth * 0.01,
                        ),
                        Card(
                          color: Colors.deepOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: FutureBuilder<List<denemeModel>>(
                                future: gelenAltgrupListesi(secilenilkgrup),
                                builder: (context, snapshotss) {
                                  return snapshotss.data == null
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : DropdownButton<String>(
                                          hint: Text("Alt Seçiniz"),
                                          dropdownColor: Colors.deepOrange,
                                          value: secilenilkaltgrup,
                                          onChanged: (value) {
                                            print("dd=" + value.toString());

                                            setState(() {
                                              isloading = false;
                                              secilenilkaltgrup =
                                                  value.toString();
                                            });
                                            // getMarkaListesi(secilenilkgrup,secilenilkaltgrup);
                                          },
                                          items: snapshotss.data!
                                              .map((vc) =>
                                                  DropdownMenuItem<String>(
                                                    child: Text(
                                                      vc.name,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    value: vc.name,
                                                  ))
                                              .toList(),
                                        );
                                },
                              )),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Marka :",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: maxWidth * 0.01,
                        ),
                        Card(
                          color: Colors.deepOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: FutureBuilder<List<denemeModel>>(
                                future: getMarkaListesi(
                                    secilenilkgrup, secilenilkaltgrup),
                                builder: (context, snapshotss) {
                                  return snapshotss.data == null
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : DropdownButton<String>(
                                          hint: Text("Marka Seçiniz"),
                                          dropdownColor: Colors.deepOrange,
                                          value: secilenilkmarkagrup,
                                          onChanged: (value) {
                                            setState(() {
                                              isloading = false;
                                              secilenilkmarkagrup =
                                                  value.toString();
                                            });
                                          },
                                          items: snapshotss.data!
                                              .map((vc) =>
                                                  DropdownMenuItem<String>(
                                                    child: Text(
                                                      vc.name,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    value: vc.name,
                                                  ))
                                              .toList(),
                                        );
                                },
                              )),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Model :",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: maxWidth * 0.01,
                        ),
                        Card(
                          color: Colors.deepOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: FutureBuilder<List<denemeModel>>(
                                future: getModelListesi(secilenilkgrup,
                                    secilenilkaltgrup, secilenilkmarkagrup),
                                builder: (context, snapshotss) {
                                  return snapshotss.data == null
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : DropdownButton<String>(
                                          hint: Text("Model Seçiniz"),
                                          dropdownColor: Colors.deepOrange,
                                          value: secilenmodelgrup,
                                          onChanged: (value) {
                                            setState(() {
                                              isloading = false;
                                              secilenmodelgrup =
                                                  value.toString();
                                            });
                                          },
                                          items: snapshotss.data!
                                              .map((vc) =>
                                                  DropdownMenuItem<String>(
                                                    child: Text(
                                                      vc.name,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    value: vc.name,
                                                  ))
                                              .toList(),
                                        );
                                },
                              )),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Görüşme Tipi:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: maxWidth * 0.01,
                        ),
                        Card(
                          color: Colors.deepOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: DropdownButton(
                              dropdownColor: Colors.deepOrange,
                              value: GTSecilenValue,
                              items: [
                                //add items in the dropdown
                                DropdownMenuItem(
                                    child: Text(
                                      "Ziyaret",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    value: "Ziyaret"),

                                DropdownMenuItem(
                                  child: Text(
                                    "Tel",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  value: "Tel",
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  GTSecilenValue = value.toString();
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: maxHeight * 0.03,
                    ),
                    Text(
                      "Müşteri İsmi: ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          onChanged: (value) {
                            inputGorusmeIsim = value;
                          },
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Müşteri İsmi Giriniz...',
                              hintStyle: TextStyle(
                                fontSize: 14,
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: maxHeight * 0.03,
                    ),
                    Text(
                      "Telefon Numarası: ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          inputFormatters: [maskFormatter],
                          onChanged: (value) {
                            inputGorusmeTel = value;
                          },
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: '0 (5xx) xxx-xx-xx',
                              hintStyle: TextStyle(
                                fontSize: 14,
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: maxHeight * 0.03,
                    ),
                    Text(
                      "Açıklama: ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          maxLines: 5,
                          onChanged: (value) {
                            inputGorusmeAciklama = value;
                          },
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Açıklama Giriniz...',
                              hintStyle: TextStyle(
                                fontSize: 14,
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: maxHeight * 0.03,
                    ),
                    Text(
                      "Fiyat: ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          onChanged: (value) {
                            inputGorusmeFiyat =
                                double.parse(value.replaceAll(",", "."));
                          },
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Fiyat Giriniz... Örn: 449.99',
                              hintStyle: TextStyle(
                                fontSize: 14,
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: maxHeight * 0.03,
                    ),
                    SizedBox(
                      height: maxHeight * 0.03,
                    ),
                    Center(
                      child: SizedBox(
                        width: maxWidth * 0.6,
                        height: maxHeight * 0.07,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            backgroundColor: Colors.deepOrange,
                          ),
                          onPressed: () {
                            if (inputGorusmeAciklama == "" ||
                                inputGorusmeIsim == "" ||
                                inputGorusmeTel == "") {
                              shareFunction().showAlertSimple(
                                  context,
                                  "Uyarı",
                                  "Boş alanların eksiksiz doldurulduğundan emin olun!",
                                  "Tamam");
                              Navigator.pop(context);
                              Navigator.pop(context);

                            } else {
                              setState(() {
                                isSendLoading = true;
                              });

                              setGorusme(
                                  GTSecilenValue,
                                  secilenilkgrup,
                                  secilenilkaltgrup,
                                  secilenilkmarkagrup,
                                  secilenmodelgrup,
                                  inputGorusmeTel,
                                  inputGorusmeIsim,
                                  inputGorusmeAciklama,
                                  gelenemail,
                                  secilendealer,
                                  inputGorusmeFiyat);

                             setState(() {
                                inputGorusmeIsim = "";
                                inputGorusmeAciklama = "";
                                inputGorusmeTel = "";
                              });


                            // shareFunction().showAlertSimple(context,
                              //   "Bilgilendirme", "Görüşme eklendi", "Tamam");
                              Navigator.pop(context);
                            }
                            //Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              isSendLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      'Görüşmeyi Onayla',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                              SizedBox(
                                width: maxWidth * 0.015,
                              ),
                              Icon(
                                Icons.check_circle,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: maxHeight * 0.03,
                    )
                  ]),
            ),
          ));
        })));
  }
}
