/// FormatModelModel.dart
import 'dart:convert';

FormatModel formatFromJson(String str) {
  final jsonData = json.decode(str);
  return FormatModel.fromJson(jsonData);
}

String formatToJson(FormatModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class FormatModel {
  int id;
  String name;
  String formatCode;
  bool dueDate;
  bool oneDate;
  bool dateNow;
  String informasi;
  int maxCuti;
  bool tambahan;

  FormatModel({
    this.id,
    this.name,
    this.formatCode,
    this.dueDate,
    this.oneDate,
    this.dateNow,
    this.informasi,
    this.maxCuti,
    this.tambahan,
  });

  factory FormatModel.fromJson(Map<String, dynamic> json) => new FormatModel(
        id: json["id"],
        name: json["name"],
        formatCode: json["format_code"],
        dueDate: json["due_date"],
        oneDate: json["one_date"],
        dateNow: json["date_now"],
        informasi: json["informasi"],
        maxCuti: json["max_cuti"],
        tambahan: json["tambahan"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "format_code": formatCode,
        "due_date": dueDate,
        'one_date': oneDate,
        'date_now': dateNow,
        "informasi": informasi,
        'max_cuti': maxCuti,
        'tambahan': tambahan,
      };
}
