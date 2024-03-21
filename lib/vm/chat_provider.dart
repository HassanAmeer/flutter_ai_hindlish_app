import 'dart:convert';
// import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';
import 'chatListVm.dart';

class ChatProvider with ChangeNotifier {
  ///
  /// get selected tab
  ///
  int _selectedTab = 1;
  int get selectedTab => _selectedTab;
  void selectedTabFunction(int tab) {
    _selectedTab = tab;
    notifyListeners();
  }

  final box = Hive.box('listOfChat');
  List _getDataListFromHive = [];
  List get getDataListFromHive => _getDataListFromHive;

  Future<List> getDataListFromHiveFunction() async {
    _getDataListFromHive = await box.get('chatList') ?? [];
    // log('🤞🤞🤞🤞 data in hive is $_getDataListFromHive');
    return _getDataListFromHive;
  }

  List _oldListData = [];
  List get oldListData => _oldListData;
  addDataToHive() {
    _oldListData = box.get('chatList') ?? [];

    _oldListData.add({
      'their_reply': _theirReply,
      'your_reply': _yourReply,
    });
    box.put('chatList', _oldListData);
  }

  ///
  ///
  ///
  List<String> _hinglishTextList = [];
  List<String> get getHinglishTextList => _hinglishTextList;
  List<String> _englishTextList = [];
  List<String> get getEnglishTextList => _englishTextList;
  String _responseString = '';

  ///
  /// showTextField
  ///
  bool _showTextField = false;
  bool get showTextField => _showTextField;

  void showTextFieldFunction(bool shouldShow) {
    _showTextField = shouldShow;
    notifyListeners();
  }

  ///
  /// hintText
  ///
  String _hintText = '';
  String get hintText => _hintText;
  void hintTextFunction(String getText) {
    _hintText = getText;
    notifyListeners();
  }

  ///
  /// loading
  ///
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  isLoadingFunction(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  ///
  ///
  /// language selected
  ///
//
  Box additionalInfoBox = Hive.box('Stngs');
  String _selectedLanguage = 'Hindi';
  String get selectedLanguage => _selectedLanguage;
  void getSelectedLanguageFunction() {
    _selectedLanguage = additionalInfoBox.get('language') ?? 'Hindi';
    notifyListeners();
  }

  void selectedLanguageFunction(String language) {
    _selectedLanguage = language;
    additionalInfoBox.put('language', language);
    notifyListeners();
  }

  // 'prompt': 'I am having a conversation with someone, and its message is: $_theirReply '
  //           'and I want to reply in a more "rizz" way. So, my reply is: $_yourReply. '
  //           'Analyze my user reply and make my reply more attractive so that whom I\'m chatting with gets impressed. '
  //           'Provide at least 10 responses from which I can choose the best, and do not use numbers to separate them. '
  //           'Just use a dot (.) to separate them.\nAI: If a category is provided, then respond according to categories '
  //           'like happy, angry, funny, love, entertainment, etc. The category is ${category.isNotEmpty ? category : 'No category'}.\n'
  //           'AI: And also in 3 languages like this Map format =>, + '
  //           ''
  //           '{"isFromText": true, '
  //           '"imgPath": "", '
  //           '"theirReply": $_theirReply.toString(), '
  //           '"yourReply": $_yourReply.toString(), '
  //           '"eng": listOfResponseWords, '
  //           '"hindi": listOfResponseWords'
  //           '"hinglish": listOfResponseWords'
  //           '}"',
  ///
  ///
  /// list of responses from AI
  ///
  List _listOfResponses = [];
  List<String> _hindiTextList = [];
  List<String> get getHindiTextList => _hindiTextList;
  List get listOfResponses => _listOfResponses;
  String apiKey = "sk-D5u1O5hxvt1EJfk8gQ2qT3BlbkFJ3i8DHBTIQifRoVSM9e3"; // C
  String openAIEndpoint =
      'https://api.openai.com/v1/engines/gpt-3.5-turbo-instruct/completions';
  final translator = GoogleTranslator();

  Future<void> askQuestionToChatbot(context, category) async {
    try {
      var response = await http.post(Uri.parse(openAIEndpoint),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey'
          },
          body: jsonEncode({
            'prompt': 'i am having conversation with someone and its message is :$_theirReply '
                ' and i want to reply in a more '
                'rizz way so my reply is : $_yourReply. so analyze my user reply'
                ' and make my reply more attractive so that whom i chatting with get impressed'
                ' and provide atleast 10 responses from which i can choose the best and do not '
                'use numbers to separte them jsut use a dot(.) to separate them. \nAI: if category is provided then reponse according to category like happy , angry, funny, love, entertainment etc. The category is ${category.isNotEmpty ? category : 'No category'} \nAI',
            'max_tokens': 250
          }));

      if (response.statusCode == 200) {
        var decodedResp = jsonDecode(response.body);
        var decodedRespChoices = decodedResp['choices'];
        if (decodedRespChoices.isNotEmpty) {
          var decodedRespChoicesText = decodedRespChoices[0]['text'] as String;

          // debugPrint("👉decodedRespChoices:$decodedRespChoices");
          // debugPrint("👉decodedRespChoicesText:$decodedRespChoicesText");
          _englishTextList = decodedRespChoicesText.split('.');

          // // Filter out empty strings
          _englishTextList = _englishTextList
              .where((text) => text.toString().trim().length > 5)
              .toList();

          // for (var element in _englishTextList) {
          //   var translation = await translator.translate(element, to: 'hi');
          //   if (translation.text.toString().trim().length > 5) {
          //     _hindiTextList.add(translation.text);
          //   }
          // }

          // var response2 = await http.post(Uri.parse(openAIEndpoint),
          //     headers: {
          //       'Content-Type': 'application/json',
          //       'Authorization': 'Bearer $apiKey'
          //     },
          //     body: jsonEncode({
          //       'prompt':
          //           'convert this paragrapgh to in hindi in english:$decodedRespChoicesText',
          //     }));

          // if (response2.statusCode == 200) {
          //   var decodedResp2 = jsonDecode(response.body);
          //   var decodedRespChoices2 = decodedResp2['choices'];
          //   if (decodedRespChoices2.isNotEmpty) {
          //     var decodedRespChoicesText2 =
          //         decodedRespChoices2[0]['text'] as String;
          //     _hinglishTextList = decodedRespChoicesText2.split('.');
          //     debugPrint("👉 _hinglishTextList: $_hinglishTextList");
          //     // // Filter out empty strings
          //     _hinglishTextList = _hinglishTextList
          //         .where((text) => text.toString().trim().length > 5)
          //         .toList();
          //   }
          // } else {
          //   _hinglishTextList = ['Hinglish Is Not an atcual Language'];
          // }
          await Provider.of<ChatsListVmC>(context, listen: false).addChatsVmF({
            "isFromText": true,
            "imgPath": "",
            "theirReply": _theirReply.toString(),
            "yourReply": _yourReply.toString(),
            "eng": _englishTextList,
            "hindi": _hindiTextList,
            "hinglish": _hindiTextList
          });
        }
        notifyListeners();
      } else {
        if (kDebugMode) {
          print("💥 when ai reponse: ${response.body}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('💥 when ai reponse Error: $e');
      }
    }
  }

  ///
  ///
  /// their reply and your reply
  String _theirReply = '';
  String get theirReply => _theirReply;

  void theirReplyFunction(String value) {
    _theirReply = value;
    notifyListeners();
  }

  String _yourReply = '';
  String get yourReply => _yourReply;

  void yourReplyFunction(String value) {
    _yourReply = value;
    notifyListeners();
  }

  ///
  ///  add screenshots to hive
  ///

  final screenshotBox = Hive.box('listOfScreenShots');
  List screenShotsListFromHive = [];
  String _getScreenShot = '';
  void getScreenShotFunction(String screenShot) {
    _getScreenShot = screenShot;
    addScreenShotsToHive();
    notifyListeners();
  }

  void addScreenShotsToHive() {
    screenShotsListFromHive = screenshotBox.get('screenShotsList') ?? [];
    screenShotsListFromHive.add(_getScreenShot);
    screenshotBox.put('screenShotsList', screenShotsListFromHive);
  }

  Future<List> getScreenShotListFromHive() async {
    screenShotsListFromHive = await screenshotBox.get('screenShotsList') ?? [];
    return screenShotsListFromHive;
  }

  void disposeLists() async {
    _englishTextList.clear();
    _hindiTextList.clear();
    _responseString = '';
    _listOfResponses.clear();
    _theirReply = '';
    _yourReply = '';
    _showTextField = false;
    notifyListeners();
  }
}
