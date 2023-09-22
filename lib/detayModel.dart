import 'dart:ffi';

class DetayKart {
  final int dtyid;
  final String dtytipi;
  final String dtyanagrup;
  final String dtyaltgrup;
  final String dtymarka;
  final String dtymodel;
  final String dtymusteri;
  final String dtyfiyat;
  final String dtytel;
  final String dtyaciklama;
  final String dtydealer;
  final String dtyusername;
  final int dtytarih;

  const DetayKart({
    required this.dtyid,
    required this.dtytipi,
    required this.dtyanagrup,
    required this.dtyaltgrup,
    required this.dtymarka,
    required this.dtymodel,
    required this.dtyfiyat,
    required this.dtytel,
    required this.dtymusteri,
    required this.dtyaciklama,
    required this.dtydealer,
    required this.dtyusername,
    required this.dtytarih,
  });

  factory DetayKart.fromJson(Map<String, dynamic> json) {
    return DetayKart(
      dtyid: json['gid'],
      dtytipi: json['gtipi'],
      dtyanagrup: json['ganagrup'],
      dtyaltgrup: json['galtgrup'],
      dtymarka: json['gmarka'],
      dtymodel: json['gmodel'],
      dtyfiyat: json['gfiyat'],
      dtytel: json['gtel'],
      dtymusteri: json['gmusteri'],
      dtyaciklama: json['gaciklama'],
      dtydealer: json['gdealer'],
      dtyusername: json['gusername'],
      dtytarih: json['gtarih'],
    );
  }
}
