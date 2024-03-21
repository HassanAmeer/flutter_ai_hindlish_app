import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class UploadImgsVMC extends ChangeNotifier {
  List uploadedImgs = [];

  addImgs(value) async {
    var hiveDb = await Hive.openBox('aiChats');
    uploadedImgs = await hiveDb.get("uploadedImgsDBList") ?? [];
    uploadedImgs.add(value);
    await hiveDb.put("uploadedImgsDBList", uploadedImgs);
    notifyListeners();
  }

  getImgs() async {
    var hiveDb = await Hive.openBox('aiChats');
    uploadedImgs = await hiveDb.get("uploadedImgsDBList") ?? [];
    notifyListeners();
  }

  deleteImgs(data) async {
    var hiveDb = await Hive.openBox('aiChats');
    uploadedImgs.remove(data);
    await hiveDb.put("uploadedImgsDBList", uploadedImgs);
    notifyListeners();
  }
}
