class SepetKart {
final int spid;
final String spkodu;
final String spkadi;
final int spstokid;
final String spsasi;
//marka
final double spfiyat;
//renk
final double spindirim;
//beden
final String spuser;
//satis fiyati
final String spdealer;
final int spcikisid;
final int spyedekint;
final String spyedekstring;

final double spyedekfloat;




const SepetKart({
required this.spid,
required this.spkodu,
required this.spkadi,
required this.spstokid,
required this.spsasi,
required this.spfiyat,
required this.spindirim,
required this.spuser,
required this.spdealer,
  required this.spcikisid,
  required this.spyedekint,
  required this.spyedekstring,
  required this.spyedekfloat,
});

factory SepetKart.fromJson(Map<String, dynamic> json) {
return SepetKart(
  spid: json['spid'],
  spkodu: json['spkodu'],
  spkadi: json['spkadi'],
  spstokid: json['spstokid'],
  spsasi: json['spsasi'],
  spfiyat: json['spfiyat'],
  spindirim: json['spindirim'],
  spuser: json['spuser'],
  spdealer: json['spdealer'],
  spcikisid: json['spcikisid'],
  spyedekint: json['spyedekint'],
  spyedekstring: json['spyedekstring'],
  spyedekfloat: json['spyedekfloat'],


);
}
}