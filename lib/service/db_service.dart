import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maxsociety/main.dart';
import 'package:maxsociety/model/app_metadata_model.dart';
import 'package:maxsociety/util/preference_key.dart';

class DBService {
  static DBService instance = DBService();
  late FirebaseFirestore _db;
  String metadataCollection = 'metadata';
  DBService() {
    _db = FirebaseFirestore.instance;
  }

  Future<bool> getAppMetadata() async {
    List<AppMetadataModel> metadataList = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _db.collection(metadataCollection).get();

    metadataList = querySnapshot.docs
        .map((metadata) => AppMetadataModel.fromMap(metadata.data()))
        .toList();
    log(metadataList.first.toJson());
    prefs.setString(PreferenceKey.metadata, metadataList.first.toJson());
    return true;
  }
}
