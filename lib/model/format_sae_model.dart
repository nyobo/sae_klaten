class FormateSaeModel {
  int id;
  String name;
  String formatCode;
  bool dueDate;
  bool oneDate;
  bool dateNow;
  String informasi;
  int maxCuti;
  bool tambahan;
  String textTambahan;
  

  FormateSaeModel(Map<String, dynamic> data) {
    this.id = data['id'];
    this.name = data['name'];
    this.formatCode = data['format_code'];
    this.dueDate = data['due_date'];
    this.oneDate = data['one_date'];
    this.dateNow = data['date_now'];
    this.informasi = data['informasi'];
    this.maxCuti = data['max_cuti'];
    this.tambahan = data['tambahan'];
    this.textTambahan = data['text_tambahan'];
  }
}
class FormateSaeList{
  List<FormateSaeModel> data = [];
  FormateSaeList(Map<String,dynamic> data){
    for (var i = 0; i < data['data'].length; i++) {
      this.data.add(FormateSaeModel(data['data'][i]));
    }
  }
}


