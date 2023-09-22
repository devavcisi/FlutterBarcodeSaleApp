import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:http/http.dart' as http;
import 'config.dart' as config;
import 'package:easycoprombflutter/share_function.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';



String inputSatisYapTcNo = "";
String inputSatisYapTcNounvan = "";
String inputSatisYapTcNotel = "";
String inputSatisYapTcNoemailSepet = "";
String inputSatisYapTcNoAdresSepet = "";

class sepetOnay extends StatefulWidget {
  const sepetOnay({super.key});

  @override
  State<sepetOnay> createState() => _sepetOnay();
}

bool isSendLoad = false;

class _sepetOnay extends State<sepetOnay> {
  var maskFormatter = new MaskTextInputFormatter(
      mask: '# (###) ###-##-##',
      filter: { "#": RegExp(r'[0-9]') },
      type: MaskAutoCompletionType.lazy
  );
  Future functionSepetOnayla(gonderuname, gonderdealer, gondertcno, gonderunvan,
      gondertel, gonderemail, gonderadres, contextB) async {
    print('dEALER?' + gonderdealer + '  uname ' + gonderuname);
    // print(spid.toString()+"gelen");
    var response = await http.get(
        //http://sb.saloonburger.com.tr/v1/ sonrasında buna çevir
        Uri.parse(config.getApiUrl() +
            '/SetStokSatisFiyatlariCekBayiSatisYapSepet?dealer=$gonderdealer&uname=$gonderuname&inputSatisYapTcNo=$gondertcno&inputSatisYapTcNounvan=$gonderunvan&inputSatisYapTcNotel=$gondertel&inputSatisYapTcNoemailSepet=$gonderemail&inputSatisYapTcNoAdresSepet=$gonderadres'), //535XLMATMAVIBEYAZ001
        headers: <String, String>{
          'authorization': config.getbase64Authentication(),
          'Content-Type': 'application/json'
        });
    //var response = await http.get(  "http://sb.saloonburger.com.tr/v1/",headers: <String, String>{'authorization': basicAuth},
    // print(response.statusCode);
    if (response.statusCode == 200) {
      if (response.body.contains("ok")) {
        shareFunction()
            .showAlertSimple(contextB, "Bilgi", "Sipariş Onaylandı", "Tamam");
      }
    } else {
      shareFunction().showAlertSimple(contextB, "HATA", response.body, "Tamam");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text("Satış Ekranı"),
      ),
      body: SafeArea(

          child: LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
    final double maxWidth = constraints.maxWidth;
    final double maxHeight = constraints.maxHeight;
    final double cardHeight = maxHeight * 0.8;
    final double cardWidth = maxWidth * 0.8;
          return Center(
              child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: maxHeight*0.05,
            ),
            Container(
              margin:
                  const EdgeInsets.only(left: 13, bottom: 0, right: 13, top: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "TC/Vergi No: ",
                    style: TextStyle(fontSize: 18),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        maxLength: 11,
                        onChanged: (value) {
                          inputSatisYapTcNo = value;
                        },
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'TC Kimlik/ Vergi Numarası Giriniz...',
                            hintStyle: TextStyle(
                              fontSize: 14,
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: maxHeight*0.04,
                  ),
                  Text(
                    "Ünvan/ Ad Soyad: ",
                    style: TextStyle(fontSize: 18),
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
                          inputSatisYapTcNounvan = value;
                        },
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Ad Soyad giriniz...',
                            hintStyle: TextStyle(
                              fontSize: 14,
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: maxHeight*0.04,
                  ),
                  Text(
                    "Telefon Numarası: ",
                    style: TextStyle(fontSize: 18),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          inputFormatters: [maskFormatter],
                          keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          inputSatisYapTcNotel = value;
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
                    height: maxHeight*0.04,
                  ),
                  Text(
                    "E-posta: ",
                    style: TextStyle(fontSize: 18),
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
                          inputSatisYapTcNoemailSepet = value;
                        },
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'E-mail adresi giriniz...',
                            hintStyle: TextStyle(
                              fontSize: 14,
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: maxHeight*0.04,
                  ),
                  Text(
                    "Adres: ",
                    style: TextStyle(fontSize: 18),
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
                          inputSatisYapTcNoAdresSepet = value;
                        },
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Adres giriniz...',
                            hintStyle: TextStyle(
                              fontSize: 14,
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: maxHeight*0.04,
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextButton(
                        child: isSendLoad
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text('Sipariş Oluştur',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                )),
                        onPressed: () {
                          if (inputSatisYapTcNo == "" ||
                              inputSatisYapTcNounvan == "" ||
                              inputSatisYapTcNotel == "" ||
                              inputSatisYapTcNoemailSepet == "" ||
                              inputSatisYapTcNoAdresSepet == "") {
                            shareFunction().showAlertSimple(
                                context,
                                "Uyarı!",
                                "Lütfen bilgilerin eksiksiz bir şekilde girildiğinden emin olun",
                                "Tamam");
                          } else {
                            functionSepetOnayla(
                                gelenemail,
                                secilendealer,
                                inputSatisYapTcNo,
                                inputSatisYapTcNounvan,
                                inputSatisYapTcNotel,
                                inputSatisYapTcNoemailSepet,
                                inputSatisYapTcNoAdresSepet,
                                context);
                           // shareFunction().showAlertSimple(context,
                             //   "İşlem alındı", "Sepetiniz onaylandı", "Tamam");
                            Navigator.pop(context);



                          }
                         // Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: maxHeight*0.05,
                  )
                ],
              ),
            )
          ],
        ),
      ));})),
    );
  }
}
