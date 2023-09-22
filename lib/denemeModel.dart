class denemeModel {

final String name;
final String username;





const denemeModel({
required this.name,
required this.username,

});

factory denemeModel.fromJson(Map<String, dynamic> json) {
return denemeModel(
  name: json['name'],
  username: json['username'],



);
}
}