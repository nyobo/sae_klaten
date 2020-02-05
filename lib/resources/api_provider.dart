// Copyright 2019 Joshua de Guzman (https://jmdg.io). All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' show Client;
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:sapa_sae_klaten/model/format_model.dart';
import 'package:sapa_sae_klaten/model/format_no_sae.dart';
import 'package:sapa_sae_klaten/model/format_no_sae_list.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sapa_sae_klaten/model/format_sae_model.dart';

class ApiProvider {
  HttpClient clients = new HttpClient();
  Client client = Client();
  static Database _database;

  final apiKey = '973e0b034af17e62d03ca343795ac965';
  // final baseUrl = 'http://okamtd.com/api/v1/items'; //live
  final baseUrl = ""; //staging
  final String key =
      'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImRjMzY0Y2E5N2VkY2FhYTMyM2FiNjkyYzIzM2M0YTM2MThjY2RmZmY2ZTk3ODA4ZWUxZTU2N2E4NzBhMmNjZmNiYzNhYmI1NjZkZGMzYTk3In0.eyJhdWQiOiIxIiwianRpIjoiZGMzNjRjYTk3ZWRjYWFhMzIzYWI2OTJjMjMzYzRhMzYxOGNjZGZmZjZlOTc4MDhlZTFlNTY3YTg3MGEyY2NmY2JjM2FiYjU2NmRkYzNhOTciLCJpYXQiOjE1NjQzNjI5MDAsIm5iZiI6MTU2NDM2MjkwMCwiZXhwIjoxNTk1OTg1MzAwLCJzdWIiOiI0Iiwic2NvcGVzIjpbXX0.mitJImtP1gDEeNeLgvbLdNXQKa-IUSQ641LKAb99M4o1rSvFy53xSn-AOjdyd_XIhccj0qaqsGP3-7COR43SNXXEVaCiKxIvcS_wwpjZBNfbhk2uNp2wxXHoBChVGmWsJRidRBJxcoZ3nmYzXbTesAgJV3M4y0fKe38UC-uCZ2tbb0_tdN5vjk6wPf7RUwz1T2d4e97Y8RcsMolTIlH-unlALdxCdQ2MN-15tDcbg6aivDGEdnX2yKXLW4xRwLoVyPMjSxp8HSLelC4CDmxQpcMPhAtz7AN6Cx-ycaTtmFjyVRbgyau_ptNIwmeCVW5F6jChfCXg63S9pbLvgW-h1pmQF79ETh5w7Hxa-tCizTM16DTIWyUkA9losvv8yBoZBLk2r7l_75p12PA6mlDa4ISm73ozxS6m2q0X48YntflgIsWoP5f4m4k2YsJOurK3bgor13ZRBs7-5zQVzCcq6srwajd_EIbFRGZeCJTSj_h87kt0GP8xLNUBkczOOHWaIRA0lvBcnV-extEXNMD7_wLwRNjMvw64oGqPJL3bzY_ID_clN6j9mlp-B8XyOFCgJf3Phk5BTfftop8cebcKPHr8k5WRPNNWu7sIoUgaaEB3fJ4nIkxuitDO2rcyxvAXVF8GSaOMZdMwtKi6GSQ1yAft306sg5vLA22uSpTd9nk';
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE formatSae ("
          "id INTEGER PRIMARY KEY,"
          "_id_format_sae TEXT,"
          "format_code TEXT,"
          "name TEXT"
          ")");
    });
  }
  selectAll()async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM formatSae");
    return res;    
  }
  getDataById(int $idSae){
    
  }
  newFormate(FormateSaeList newFormate) async {
    final db = await database;
    var res;
    for (var i = 0; i < newFormate.data.length; i++) {
      int id = newFormate.data[i].id;
      String name = newFormate.data[i].name;
      String formatCode = newFormate.data[i].formatCode;
       var resCek = await db.query("formatSae",where: "_id_format_sae = ?", whereArgs: [id]);
        if (resCek.isEmpty) {
            res = await db.rawInsert(
            "INSERT Into formatSae (_id_format_sae,name,format_code)"
            " VALUES (${id},'${name.toString()}','${formatCode.toString()}')");
        }//? nanti tambhan udate
    }
    return res;
  }

  deleteAll()async{
    final db = await database;
    db.rawDelete("Delete from formatSae");
  }

  // newFormat(FormatModel newFormat) async {
  //   final db = await database;
  //   //get the biggest id in the table
  //   var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM formatSae");
  //   int id = table.first["id"];
  //   //insert to the table using the new id
  //   var raw = await db.rawInsert(
  //       "INSERT Into formatSae (id,name,last_name,blocked)"
  //       " VALUES (?,?,?,?)",
  //       [id, newFormat.name, newFormat.formatCode, newFormat.oneDate]);
  //   return raw;
  // }
  getFormatById(int idFormateSae) async {
    final db = await database;
    var res = await db.query("formatSae",
        where: "id = ?", whereArgs: [idFormateSae]);
    return res;
    // return res.isNotEmpty ? FormatModel.fromJson(res.first) : Null ;
  }

  Future<FormateSaeList> loadFormatSaeAsset() async {
    String sFormatJson = await rootBundle.loadString('json/format_sae.json');
    if (sFormatJson != null) {
      FormateSaeList fSaeList = FormateSaeList(json.decode(sFormatJson));
      return fSaeList;
    }
  }

  Future<FormatModel> saveFormatSaeSqlite() async {
    String sFormatJson = await rootBundle.loadString('json/format_sae.json');
    if (sFormatJson != null) {}
  }

  Future<FormatNoSaeList> loadFormatNoSae() async {
    String sFormatJson = await rootBundle.loadString('json/format_no_sae.json');
    if (sFormatJson != null) {
      return FormatNoSaeList(json.decode(sFormatJson));
    } else {
      throw "error json null";
    }
  }

  Future<List> getDataDropDown() async {
    String sFormatJson = await rootBundle.loadString('json/format_sae.json');
    if (sFormatJson != null) {
      return List(json.decode(sFormatJson));
    } else {
      throw ('error');
    }
  }
  // Future<BannerList> getAllBanner()async{
  //   final String url ='$baseUrl/banners';
  //   final response = await client.get(url,headers: {HttpHeaders.authorizationHeader:key});
  //   if (response.statusCode == HttpStatus.ok) {
  //     return BannerList(json.decode(response.body));
  //   }else{
  //     throw Exception('failed to load banner');
  //   }
  // }
}
