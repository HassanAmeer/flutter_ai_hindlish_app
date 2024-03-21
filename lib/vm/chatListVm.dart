import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ChatsListVmC extends ChangeNotifier {
  List getAllChatsList = [];

  addChatsVmF(value) async {
    var hiveDb = await Hive.openBox('aiChats');
    getAllChatsList = await hiveDb.get("allChats") ?? [];
    getAllChatsList.add(value);
    await hiveDb.put("allChats", getAllChatsList);
    notifyListeners();
  }

  getChatsVmF() async {
    var hiveDb = await Hive.openBox('aiChats');
    getAllChatsList = await hiveDb.get("allChats") ?? [];
    // debugPrint("👉 getChatsVmF: ${getAllChatsList.toString()}");
    notifyListeners();
  }

  deleteChatsVmF(mapData) async {
    var hiveDb = await Hive.openBox('aiChats');
    getAllChatsList.remove(mapData);
    await hiveDb.put("allChats", getAllChatsList);
    notifyListeners();
  }
}
    // [
    //   {
    //     "isFromText": true,
    //     "imgPath": "",
    //     "theirReply": "",
    //     "yourReply": "",
    //     "eng": [],
    //     "hindi": [],
    //   },
    // ];

