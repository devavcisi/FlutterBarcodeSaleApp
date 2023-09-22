
class StokKarti {
  final int sid;
  final String skodu;
  final String sadi;
  final String sanagrup;
  final String saltgrup;
  //marka
  final String sdepokodu;
  //renk
  final String sozelgrup;
  //beden
  final String smuhkod;
  //satis fiyati
  final double sbirimfiyati;
  const StokKarti({
    required this.sid,
    required this.skodu,
    required this.sadi,
    required this.sanagrup,
    required this.saltgrup,
    required this.sdepokodu,
    required this.sozelgrup,
    required this.smuhkod,
    required this.sbirimfiyati,
  });

  factory StokKarti.fromJson(Map<String, dynamic> json) {
    return StokKarti(
      sid: json['sid'],
      skodu: json['skodu'],
      sadi: json['sadi'],
      sanagrup: json['sanagrup'],
      saltgrup: json['saltgrup'],
      sdepokodu: json['sdepokodu'],
      sozelgrup: json['sozelgrup'],
      smuhkod: json['smuhkod'],
      sbirimfiyati: json['sbirimfiyati'],
    );
  }
}