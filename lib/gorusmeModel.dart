import 'dart:ffi';

class GorusmeKart {
  final int gid;
  final String gtipi;
  final String ganagrup;
  final String galtgrup;
  final String gmarka;
  final String gmodel;
  final String gmusteri;
  final String gfiyat;
  final String gtel;
  final String gtarih;

  const GorusmeKart(
      {required this.gid,
      required this.gtipi,
      required this.ganagrup,
      required this.galtgrup,
      required this.gmarka,
      required this.gmodel,
      required this.gfiyat,
      required this.gtel,
      required this.gtarih,
      required this.gmusteri});

  factory GorusmeKart.fromJson(Map<String, dynamic> json) {
    return GorusmeKart(
        gid: json['gid'],
        gtipi: json['gtipi'],
        ganagrup: json['ganagrup'],
        galtgrup: json['galtgrup'],
        gmarka: json['gmarka'],
        gmodel: json['gmodel'],
        gfiyat: json['gfiyat'],
        gtel: json['gtel'],
        gtarih: json['gtarih'],
        gmusteri: json['gmusteri']);
  }
}
