// import 'dart:async';
// import 'package:komik/constants/komikdb.dart';
// import 'package:komik/model/banner_model.dart';
// import 'package:komik/model/kategori_model.dart';
// import 'package:komik/model/komik_details_list.dart';
// import 'package:komik/model/komik_image.dart';
// import 'package:komik/model/komik_image_list.dart';
// import 'package:komik/model/komiks_list.dart';
// import 'package:komik/model/komils.dart';
// import 'package:komik/model/product.dart';
// import 'package:komik/resources/api_provider.dart';

// class Repository {
//   final apiProvider = ApiProvider();
//   // Future<KomikModel> getKomikAll() => apiProvider.getDataKomik(KomikType.KOMIK);
//   Future<ProductModel> getProduct() =>
//       apiProvider.getDataProduct(KomikType.PRODUCT);
//   // Future<KomiksModel> getKomik() => apiProvider.getJsonKomiks(KomikType.KOMIKS);
//   //? komik
//   Future<KomiksListModel> getKomiks() =>
//       apiProvider.getJsonKomiks(KomikType.KOMIKS);

//   Future<KomiksModel> getKomik(int idKomik) => apiProvider.getKomik(idKomik);
  
//   //? komik detail
//   Future<KomikDetailsList> getKomikDetails(int idKomik) => apiProvider.getKomikDetailsList(idKomik);
//   //? komik image
//   Future<KomikImage> getKomikImage(int idKomik, int noUrut) => apiProvider.getKomikImage(idKomik,noUrut);
//   Future<KomikImageList> getKomikImages(int idKomik,int noUrut) => apiProvider.getKomikImages(idKomik,noUrut);
  
//   //? get all Banner
//   Future<BannerList> getAllBanner() => apiProvider.getAllBanner();

//   //? get all komik berdasarkan hari
//   Future<KomiksListModel> getKomiksByJadwal(String type ,int idJadwal) =>apiProvider.getKomiksByParam(type,idJadwal);
//   //? get all komik berdasarkan kategori
//   Future<KomiksListModel> getKomiksByKategori(String type,int idKategori) => apiProvider.getKomiksByParam(type, idKategori);
//   //? get all kategori
//   Future<KategoriListModel> getAllKategori() => apiProvider.getAllKategori();
  
// }
