import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
// import 'package:hindlish/services/chooseCategorySheet.dart';
import 'package:hindlish/vm/chat_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hindlish/resources/assets.dart';
import 'package:hindlish/views/setting_page.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

import '../utils/theme.dart';
import '../vm/screenshot_provider.dart';

class ChatWithRizzPage extends StatefulWidget {
  const ChatWithRizzPage({super.key});

  @override
  State<ChatWithRizzPage> createState() => _ChatWithRizzPageState();
}

class _ChatWithRizzPageState extends State<ChatWithRizzPage> {
  int selectedTab = 1;
  final FocusNode textFieldFocusNode = FocusNode();
  final translator = GoogleTranslator();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final chatProvider = Provider.of<ChatProvider>(context);

    if (kDebugMode) {
      print(chatProvider.selectedLanguage);
      print('😒😒😒😒${chatProvider.getHindiTextList}');
    }
    return PopScope(
      onPopInvoked: (didPop) {
        chatProvider.isLoadingFunction(false);
        // chatProvider.disposeLists();

        textFieldFocusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              onPressed: () async {
                chatProvider.isLoadingFunction(false);
                // chatProvider.disposeLists();
                //
                // textFieldFocusNode.unfocus();
                Navigator.pop(context);
              },
              icon: Image.asset(
                'assets/icons/back_button.png',
              ),
            ),
            title: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Image.asset(AssetIcons.hindlish)),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SettingPage(),
                    ));
                  },
                  icon: Image.asset(AssetIcons.setting))
            ]),
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              IconButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                      splashFactory: InkRipple.splashFactory,
                      overlayColor: MaterialStateProperty.all(
                          Colors.yellow.withOpacity(0.3))),
                  onPressed: () {
                    chooseCategorySheetF(context);
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(content: Text('$selectedCategory')));
                  },
                  icon: Image.asset('assets/lightning_icon.png',
                      width: size.width * 0.08)),
              const SizedBox(width: 12),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                          splashFactory: InkRipple.splashFactory,
                          overlayColor: MaterialStateProperty.all(
                              Colors.yellow.withOpacity(0.3))),
                      onPressed: () async {
                        if (chatProvider.theirReply.isEmpty &&
                            chatProvider.yourReply.isEmpty) {
                          log('returning from function');
                          return;
                        }

                        // ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(content: Text('$selectedCategory')));
                        await chatProvider.isLoadingFunction(true);
                        await chatProvider.askQuestionToChatbot(
                            context, selectedCategory);
                        await chatProvider.addDataToHive();
                        await chatProvider.isLoadingFunction(false);
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text("Get Rizz Hindlish Reply",
                                    style: TextStyle(color: Colors.white)),
                                Image.asset("assets/lightning_icon.png",
                                    height: 30)
                              ]))))
            ])),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(15),
                  child: Stack(children: [
                    Image.asset('assets/enter_atleast_one_message.png'),
                    const Positioned(
                        left: 20,
                        child: Text(
                            'Please Enter atleast one message to get\n reply from Rizz Hindlish?',
                            maxLines: 2))
                  ])),

              ///
              /// their reply
              ///
              //
              if (chatProvider.theirReply.isNotEmpty)
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                        width: size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 17.0, top: 10, bottom: 10),
                            child: Text(chatProvider.theirReply,
                                maxLines: 7,
                                overflow: TextOverflow.ellipsis)))),
              const SizedBox(height: 20),

              ///
              /// your reply
              //
              if (chatProvider.yourReply.isNotEmpty)
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                        width: size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 17.0, top: 10, bottom: 10),
                            child: Text(chatProvider.yourReply,
                                maxLines: 7,
                                overflow: TextOverflow.ellipsis)))),

              ///
              ///
              /// show textfields
              ///
              chatProvider.showTextField
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 10),
                      child: Container(
                        width: size.width * 0.9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: TextField(
                          textInputAction: TextInputAction.done,
                          focusNode: textFieldFocusNode,
                          maxLines: 4,
                          minLines: 1,
                          onSubmitted: (value) {
                            chatProvider.showTextFieldFunction(false);
                            if (chatProvider.hintText == 'Their reply') {
                              chatProvider.theirReplyFunction(value);
                              textFieldFocusNode.requestFocus();
                            } else if (chatProvider.hintText == 'Your reply') {
                              chatProvider.yourReplyFunction(value);
                            }
                          },
                          decoration: InputDecoration(
                              hintText: chatProvider.hintText,
                              hintStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 0.0)),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                chatProvider.hintTextFunction('Their reply');
                                chatProvider.showTextFieldFunction(true);
                                textFieldFocusNode.requestFocus();
                              },
                              child: Container(
                                margin: const EdgeInsets.all(20),
                                height: size.width * 0.15,
                                width: size.width * 0.43,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Text(
                                    'Their Reply',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                textFieldFocusNode.requestFocus();
                                chatProvider.hintTextFunction('Your reply');
                                chatProvider.showTextFieldFunction(true);
                              },
                              child: Container(
                                height: size.width * 0.15,
                                width: size.width * 0.43,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Text(
                                    'Your Reply',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

              ///
              ///
              /// rizz replies
              ///
              //

              SizedBox(height: size.width * 0.05),
              if (chatProvider.isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              if (!chatProvider.isLoading &&
                  chatProvider.getEnglishTextList.isNotEmpty)
                Column(
                  children: [
                    Image.asset(
                      'assets/ai_generated_lines.png',
                      width: size.width * 0.7,
                    ),
                    SizedBox(height: size.width * 0.05),

                    if (chatProvider.getHindiTextList.isNotEmpty &&
                        chatProvider.selectedLanguage == 'Hindi')
                      Wrap(
                        children: chatProvider.getHindiTextList.map((item) {
                          if (item.length > 7) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: size.width * 0.85,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: Text(
                                      item.toString(),
                                      style: TextStyle(
                                        fontSize: size.width * 0.035,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(
                                            text: item.toString()));
                                        ScaffoldMessenger.of(context)
                                            .removeCurrentSnackBar();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text('Text Copied')));
                                      },
                                      icon: const Icon(Icons.copy),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        }).toList(),
                      ),
                    if (chatProvider.getHinglishTextList.isNotEmpty &&
                        chatProvider.selectedLanguage != 'Hinglish')
                      Wrap(
                        children: chatProvider.getHindiTextList.map((item) {
                          if (item.length > 7) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: size.width * 0.85,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: Text(
                                      item.toString(),
                                      style: TextStyle(
                                        fontSize: size.width * 0.035,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(
                                            text: item.toString()));
                                        ScaffoldMessenger.of(context)
                                            .removeCurrentSnackBar();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text('Text Copied')));
                                      },
                                      icon: const Icon(Icons.copy),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        }).toList(),
                      ),
                    ////
                    if (chatProvider.getEnglishTextList.isNotEmpty &&
                        chatProvider.selectedLanguage == 'English')
                      Wrap(
                        children: chatProvider.getEnglishTextList.map((item) {
                          if (item.length > 7) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: size.width * 0.85,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: Text(
                                      item.toString(),
                                      style: TextStyle(
                                        fontSize: size.width * 0.035,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(
                                            text: item.toString()));
                                        ScaffoldMessenger.of(context)
                                            .removeCurrentSnackBar();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text('Text Copied')));
                                      },
                                      icon: const Icon(Icons.copy),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        }).toList(),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
  ////////////////////

  String selectedCategory = '';
  List<String> categoriesList = [
    '😂 Funny',
    '😫 Angry',
    '🤩 Romantic',
    '😄 Happy',
    '😥 Sad',
    '😭 Crying',
    '😁 Crazy',
    '😍 Love',
    '😥 Emotional'
  ];
  chooseCategorySheetF(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: Stack(children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Wrap(
                        children: categoriesList.map((category) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                            child: InkWell(
                              onTap: () {
                                // debugPrint(category);
                                selectedCategory = category;
                                setState(() {});
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width * 0.27,
                                height:
                                    MediaQuery.of(context).size.width * 0.08,
                                decoration: BoxDecoration(
                                    color: selectedCategory == category
                                        ? ThemeColor.cyan
                                        : Colors.white,
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Text(
                                  category,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  ///
                  /// get similar reply button
                  ///
                  Positioned(
                      right: 20,
                      bottom: 10,
                      child: InkWell(
                          onTap: () async {
                            // ChatProvider chatProvider =
                            //     Provider.of<ChatProvider>(context,
                            //         listen: false);
                            // ScreenShotProvider scProvider =
                            //     Provider.of<ScreenShotProvider>(context,
                            //         listen: false);
                            // if (imgPath.toString().isNotEmpty) {
                            //   chatProvider.isLoadingFunction(true);
                            //   await scProvider.extractTextFromImage(
                            //       context,
                            //       selectedCategory.toString(),
                            //       imgPath.toString());
                            //   chatProvider.isLoadingFunction(false);
                            // } else {
                            //   chatProvider.isLoadingFunction(true);
                            //   await chatProvider.askQuestionToChatbot(
                            //       context, selectedCategory);
                            //   chatProvider.addDataToHive();
                            //   chatProvider.isLoadingFunction(false);
                            // }
                            Navigator.pop(context);
                          },
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: Image.asset('assets/img.png',
                                  fit: BoxFit.cover))))
                ]));
          });
        });
  }
}
