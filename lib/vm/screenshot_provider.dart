import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

import 'chatListVm.dart';

class ScreenShotProvider with ChangeNotifier {
  List _listOfResponses = [];
  List<String> _translatedText = [];
  List<String> get translatedText => _translatedText;
  List get listOfResponses => _listOfResponses;
  String apiKey = "sk-D5u1O5hxvt1EJfk8gQ2qT3BlbkFJ3i8DHBTIQifRoVSM9e3"; //C
  String openAIEndpoint =
      'https://api.openai.com/v1/engines/gpt-3.5-turbo-instruct/completions';
  final translator = GoogleTranslator();
  List<String> _extractedTextList = [];
  List<String> get extractedTextList => _extractedTextList;
  String _responseString = '';
  late InputImage inputImage;
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  String extractedTextFromScreenShot = '';
  Future<void> extractTextFromImage(
      context, String category, String imagePath) async {
    if (imagePath != 'null') {
      inputImage = InputImage.fromFile(File(imagePath));
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);
      // print('👉 ${recognizedText.blocks.length}');
      extractedTextFromScreenShot = recognizedText.text.toString();
      // print('👉 string resposnse $extractedTextFromScreenShot');
      textRecognizer.close();
      askQuestionToChatbot(context, category: category, imgPath: imagePath);
      // notifyListeners();
    }
  }

  Future<void> askQuestionToChatbot(context,
      {String category = '', String imgPath = ""}) async {
    try {
      var response = await http.post(
        Uri.parse(openAIEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'prompt': 'i am having conversation with someone and i will provide the details of '
              ' messages like screenshot text and you have to analyze those texts, so one of them'
              ' is me and other is the person i m communicating, it can be my boss , my crush or any other'
              ' person . so you have to analyze the chat and you should give me responses based on those '
              ' chat messages, the responses that you will provide me should be atleast 7'
              ' and you must separate them with dot(.), do not use numbers to identify them '
              ' just analyze the chat messages and give responses to me so that  can respond in a way '
              'other get impressed. so the chat Messages including their time when sent are: $extractedTextFromScreenShot '
              ' if category is provided then reponse according to category like happy , angry, funny, love, entertainment etc. The category is ${category.isNotEmpty ? category : 'No category'}  \nAI',
          'max_tokens': 150,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        _listOfResponses = data['choices'];
        if (listOfResponses.isNotEmpty) {
          _responseString = listOfResponses[0]['text'] as String;

          // Split the multiline string into a list of strings
          _extractedTextList = _responseString.split('.');

          // Filter out empty strings
          _extractedTextList = extractedTextList
              .where((text) => text.toString().trim().isNotEmpty)
              .toList();

          //  for (var text in _extractedTextList) {
          //   if (text.toString().trim().length > 5) {
          //     translatedText.add(text);
          //   }
          // }

          // if (_selectedLanguage == 'Hindi') {
          for (var element in _extractedTextList) {
            var translation = await translator.translate(element, to: 'hi');
            if (translation.text.toString().trim().length > 5) {
              translatedText.add(translation.text);
            }
          }
          // }

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
            "isFromText": false,
            "imgPath": imgPath.toString(),
            "theirReply": "",
            "yourReply": "",
            "eng": _extractedTextList.toList(),
            "hindi": translatedText.toList(),
            "hinglish": translatedText.toList(),
          });
        }
        notifyListeners();
      } else {
        if (kDebugMode) {
          print(
              "💥 WHEN GENERATE a reponse from image trycatch2 {${response.body}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('💥Error WHEN GENERATE a reponse from image trycatch2: $e');
      }
    }
  }

  ///
  ///
  /// screenshots saved to hive
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

  ///
  ///
  /// language selected
  ///
//
  Box additionalInfoBox = Hive.box('additional_info');
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

  void disposeLists() {
    _extractedTextList = [];
    _translatedText = [];
    _responseString = '';
    _listOfResponses = [];
    notifyListeners();
  }
}
