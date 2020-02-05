import 'dart:convert';

FormatNoSae formatFromJson(String str) {
  final jsonData = json.decode(str);
  return FormatNoSae.fromJson(jsonData);
}

String formatToJson(FormatNoSae data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class FormatNoSae {
  int id;
  String name;
  String codeNegara;
  String no;
  bool status;

  FormatNoSae({
    this.id,
    this.name,
    this.codeNegara,
    this.no,
    this.status,
  });
 
  factory FormatNoSae.fromJson(Map<String, dynamic> json) => new FormatNoSae(
        id: json["id"],
        name: json["name"],
        codeNegara: json["code_negara"],
        no: json["no"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code_negara": codeNegara,
        "no": no,
        'status': status,
      };
}
