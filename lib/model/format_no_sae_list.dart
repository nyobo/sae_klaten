import 'package:sapa_sae_klaten/model/format_no_sae.dart';

class FormatNoSaeList {
  List<FormatNoSae> listData = [];
  FormatNoSaeList(Map<String,dynamic> data){
    for (var i = 0; i < data['data'].length; i++) {
      this.listData.add(FormatNoSae.fromJson(data['data'][i]));
    }
  }

}