import 'dart:io';

import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:sapa_sae_klaten/model/format_model.dart';
import 'package:sapa_sae_klaten/model/format_no_sae.dart';
import 'package:sapa_sae_klaten/model/format_no_sae_list.dart';
import 'package:sapa_sae_klaten/model/format_sae_model.dart';
import 'package:sapa_sae_klaten/resources/api_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
//  ? ket
// ! showRadioBtn = 'true' [ show radio btn ]
// ! bShowDatePicker  = 'true' [ show datepicer Range] false [ show datepicer harian]
// ! bShowDate = 'true' [di gunakan untuk menampilkan kedua date picker] 'false' [di gunakan untuk hidden date picker][ini digunakan jika langsung inggin kirim sms hari itu juga]

class HomeMenuScreen extends StatefulWidget {
  HomeMenuScreen({Key key}) : super(key: key);

  _HomeMenuScreenState createState() => _HomeMenuScreenState();
}

class _HomeMenuScreenState extends State<HomeMenuScreen> {
  final apiProvider = ApiProvider();
  var dF = new DateFormat('dd/MM/yyyy');
  // ! config datePiceker
  int cfDPfristDate = 2015;
  int cfDPlastDate = 2025;
  int radioBtn;
  var _formKey = GlobalKey<FormState>();
  String _dropdownError;
  String noSapa;
  String pilihNo;
  String formatSAE;
  String formatSAECode;
  bool bShowDate = true;
  bool bShowDatePicker = false;
  bool showRadioBtn = false;
  bool tambahan = false;
  String hintAlasan = '';
  String _startDate;
  String _endDate;
  String sHestageCode = '%23';
  String sHestage = '#';
  String _dateOne;
  String _contextSMS;
  String _dateNow;
  String alasan = '';
  String informasi;
  String _picked;
  int jmlHari;
  int jmlBulan;
  int jmlTahun;
  int maxCuti;
  List<String> dataRadio = [];
  String satuHari = "1 Hari";
  String lebihSatuHari = "1 > Hari";
  String hariIni = "Hari ini";
  final TextEditingController _controller = new TextEditingController();

  List data = [];

  List<FormatNoSae> listdataNoSapa = [];
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    cekListFormatJson();
    cekListNoSapaJson();
  }

  Future<FormatNoSaeList> cekListNoSapaJson() async {
    FormatNoSaeList dataNoSapa = await apiProvider.loadFormatNoSae();
    setState(() {
      listdataNoSapa = dataNoSapa.listData;
    });
    return dataNoSapa;
  }

  Future<FormateSaeList> cekListFormatJson() async {
    FormateSaeList cekJson = await apiProvider.loadFormatSaeAsset();
    setState(() {
      data = cekJson.data;
    });
    return cekJson;
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(cfDPfristDate),
        lastDate: DateTime(cfDPlastDate));

    if (picked != null) {
      String sOneDate = dF.format(picked);
      if (sOneDate != null)
        setState(() {
          _dateOne = sOneDate;
        });
    }
  }

  _validateForm() {
    bool _isValid = _formKey.currentState.validate();
    if (bShowDate) {
      if (bShowDatePicker) {
        if (_startDate == null) {
          setState(() => _dropdownError = "tanggal mulai tidak boleh kosong !");
          _isValid = false;
        } else if (_endDate == null) {
          setState(() => _dropdownError = "tanggal akhir tidak boleh kosong !");
          _isValid = false;
        }
      } else {
        if (_dateOne == null) {
          setState(() {
            _dropdownError = "tanggal tidak boleh kosong !";
            _isValid = false;
          });
        }
      }
    }

    if (tambahan) {
      if (alasan == null || alasan == '') {
        setState(() {
          _dropdownError = "Keterangan tidak boleh kosong !";
          _isValid = false;
        });
      }
    }

    if (_picked == null) {
      setState(() => _dropdownError = "pilih hari !");
      _isValid = false;
    }

    if (formatSAE == null) {
      setState(() => _dropdownError = "format Sae tidak boleh kosong!");
      _isValid = false;
    }

    if (noSapa == null) {
      setState(() => _dropdownError = "no sapa tidak boleh kosong!");
      _isValid = false;
    }

    if (_isValid) {
      String fAlasan = '';
      if (tambahan) {
        fAlasan = '#${alasan}';
      }
      if (bShowDate) {
        if (bShowDatePicker) {
          _contextSMS =
              "#SAE#${formatSAE}${fAlasan}#${_startDate}#${_endDate}#";
        } else {
          _contextSMS = "#SAE#${formatSAE}${fAlasan}#${_dateOne}#";
        }
      } else {
        _dateNow = dF.format(selectedDate);
        _contextSMS = "#SAE#${formatSAE}${fAlasan}#";
      }
      setState(() {
        _dropdownError = '';
      });
      sendSMS(noSapa, _contextSMS);
      clearAll();
    }
  }

  clearAll() {
    _contextSMS = null;
    _dateOne = null;
    _endDate = null;
    tambahan = false;
    _startDate = null;
    noSapa = null;
    pilihNo = null;
    formatSAECode = null;
    formatSAE = null;
    showRadioBtn = false;
  }

  sendSMS(String no, String body) async {
    // Android
    final separator = Platform.isIOS ? '&' : '?';
    body = body.replaceAll(sHestage, sHestageCode.toString());
    var uri = 'sms:+${no}${separator}body=${body.toString()}';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      var uri = 'sms:+${no}';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }
  Future<Database>refreshDataFirnatSae() async{
    // await apiProvider.database;

    FormateSaeList cekJson = await apiProvider.loadFormatSaeAsset();
    await apiProvider.newFormate(cekJson);
    await apiProvider.selectAll();
    // apiProvider.deleteAll();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: tampilanAppBar(),
        body: Form(
            key: _formKey,
            child: ListView(children: <Widget>[
              //* tampilan No sapa
              tampilanDropDownNoSapa(),

              //* tampilan format sapa
              tampilanDropDownFormatSapa(),

              //* tampilan radio btn akan dirapihkan lagi
              showRadioBtn ? tampilanRadioBtn() : tampilanKosong(),

              //* tampilan untuk tambahan jika ada penambahan fiture
              tambahan ? _showTextField() : tampilanKosong(),

              //* tampilan bottom daterange dan date
              // ! bacannya jika showAllDate(bool) true dan radiobtn(Int) != null maka menampilkan condisi jika show dater picker(bool) maka tampil datepicekr range jika tidak akan menampilkan date bisa
              bShowDate && showRadioBtn
                  ? bShowDatePicker ? tampilanDateRange() : tampilanDate()
                  : tampilanKosong(),

              //* tampilan taxt jika ada error
              _dropdownError != null ? tampilanTextError() : tampilanKosong(),
              //* tampilan btn send sms
              btnSendSms()
            ])));
  }
  Widget tampilanAppBar(){
    return AppBar(
      title: Text('Sae Klaten'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: (){
            refreshDataFirnatSae();
          },
        )
      ],
    );
  }
  Widget cekCondition() {
    return Column(
      children: <Widget>[
        Text('bShowDate ${bShowDate}'),
        Text('bShowDatePicker ${bShowDatePicker}'),
        Text('picked ${_picked}'),
        Text('showRadioBtn ${showRadioBtn}'),
        Text('alasan ${alasan}'),
      ],
    );
  }

  Widget tampilanKosong() {
    return SizedBox.shrink();
  }

  Widget tampilanTextError() {
    return Text(
      _dropdownError ?? "",
      style: TextStyle(color: Colors.red),
    );
  }

  Widget tampilanDropDownNoSapa() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: pilihNo,
        isExpanded: true,
        hint: Text("Pilih No SAPA", maxLines: 1),
        items: listdataNoSapa.map((value) {
          return DropdownMenuItem<String>(
            value: value.id.toString(),
            child: new Text(
              "(${value.name}) +${value.codeNegara}${value.no}" ?? "",
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: true,
            ),
          );
        }).toList(),
        onChanged: (value) {
          listdataNoSapa.forEach((b) {
            if (value == b.id.toString()) {
              setState(() {
                pilihNo = b.id.toString();
                noSapa = '${b.codeNegara}${b.no}';
                _dropdownError = null;
              });
            }
          });
          // setState(() {
          //   noSapa = value;
          //   _dropdownError = null;
          // });
        },
      ),
    );
  }

  Widget tampilanDropDownFormatSapa() {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        value: formatSAECode,
        isExpanded: true,
        hint: Text("Select option", maxLines: 1),
        items: data.map((data) {
          return DropdownMenuItem(
            value: data.id.toString(),
            child: new Text(
              data.name ?? "",
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: true,
            ),
          );
        }).toList(),
        onChanged: (value) {
          _controller.clear();
          setState(() {
            dataRadio = [];
            _contextSMS = '';
            formatSAECode = value;
            showRadioBtn = true;
            
          });
          //? tinggl nanti saat pilih dropdown nanti bisa on  mana yang harus active
          data.forEach((b) {
            if (value.toString() == b.id.toString()) {
              setState(() {
                hintAlasan = b.textTambahan;
                if (b.dueDate) {
                  dataRadio.add(lebihSatuHari);
                  _picked = lebihSatuHari;
                  bShowDate = true;
                  bShowDatePicker = true;
                }
                if (b.oneDate) {
                  dataRadio.add(satuHari);
                  _picked = satuHari;
                  bShowDate = true;
                  bShowDatePicker = false;
                }
                if (b.dateNow) {
                  dataRadio.add(hariIni);
                  _picked = hariIni;
                  bShowDate = false;
                }
                formatSAE = b.formatCode;
                tambahan = b.tambahan;
                maxCuti = b.maxCuti;
                informasi = b.informasi;
                _dropdownError = null;
              });
            }
          });
        },
      ),
    );
  }

  Widget tampilanRadioBtn() {
    return Center(
      child: RadioButtonGroup(
        margin: const EdgeInsets.all(12.0),
        labels: dataRadio,
        picked: _picked,
        onChange: (String label, int index) {
          if (label == satuHari) {
            //? satuHari
            setState(() {
              bShowDate = true;
              bShowDatePicker = false;
              _contextSMS = '';
              _dropdownError = null;
            });
          } else if (label == lebihSatuHari) {
            //? lebih dari satuhari
            setState(() {
              bShowDate = true;
              bShowDatePicker = true;
              _contextSMS = '';
              _dropdownError = null;
            });
          } else {
            //? hariIni
            setState(() {
              bShowDate = false;
              _contextSMS = '';
              _dropdownError = null;
            });
          }
        },
        onSelected: (String label) {
          setState(() {
            _picked = label;
          });
        },
      ),
    );
  }

  Widget tampilanDateRange() {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          child: MaterialButton(
              color: Colors.deepOrangeAccent,
              onPressed: () async {
                final List<DateTime> picked =
                    await DateRagePicker.showDatePicker(
                        context: context,
                        initialFirstDate: new DateTime.now(),
                        initialLastDate:
                            (new DateTime.now()).add(new Duration(days: 7)),
                        firstDate: (new DateTime(cfDPfristDate)),
                        lastDate: new DateTime(cfDPlastDate));
                if (picked != null && picked.length == 2) {
                  _dropdownError = '';
                  var strDate = picked.first;
                  var enDate = picked.last;

                  String sStartDate = dF.format(strDate);
                  String sEndDate = dF.format(enDate);
                  setState(() {
                    // jmlHari = strDate.difference(enDate);
                    jmlBulan = (enDate.month - strDate.month);
                    jmlHari = (enDate.day - strDate.day);
                    jmlTahun = (enDate.year - strDate.year);
                    _startDate = sStartDate;
                    _endDate = sEndDate;
                  });
                } else {
                  setState(() {
                    _dropdownError = "Harus lebih dari 1 hari!";
                  });
                }
              },
              child: new Text("Pick date range")),
        ),
        _startDate != null && _endDate != null
            ? Text(
                'Cuti di ambil dari tanggal $_startDate sampai dengan $_endDate')
            : tampilanKosong(),
        jmlTahun != null && jmlBulan != null && jmlHari != null
            ? Text(
                'Jumlah Cuti di ambil $jmlTahun tahun $jmlBulan bulan $jmlHari hari')
            : tampilanKosong()
      ],
    );
  }

  Widget tampilanDate() {
    return MaterialButton(
      child: new Text("Date"),
      color: Colors.deepOrangeAccent,
      onPressed: () => _selectDate(context),
    );
  }

  Widget _showTextField() {
    return new TextField(
      maxLines: 1,
      maxLength: 100,
      controller: _controller,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: new InputDecoration(
          hintText: hintAlasan,
          icon: new Icon(
            Icons.perm_identity,
            color: Colors.grey,
          )),
      onChanged: (value) {
        setState(() {
          alasan = value;
        });
      },
    );
  }

  Widget btnSendSms() {
    return RaisedButton(
      onPressed: () => _validateForm(),
      child: Text("Submit"),
    );
  }
}
