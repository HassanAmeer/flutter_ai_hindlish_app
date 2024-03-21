import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hindlish/utils/theme.dart';
import 'package:hindlish/vm/chat_provider.dart';
import 'package:hindlish/vm/screenshot_provider.dart';
import 'package:flutter/material.dart';
import 'package:hindlish/resources/assets.dart';
import 'package:hindlish/views/setting_page.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

// import '../services/chooseCategorySheet.dart';

class ScreenShotResponsePage extends StatefulWidget {
  const ScreenShotResponsePage({super.key, required this.screenShot});
  final String screenShot;
  @override
  State<ScreenShotResponsePage> createState() => _ScreenShotResponsePageState();
}

class _ScreenShotResponsePageState extends State<ScreenShotResponsePage> {
  int selectedTab = 1;

  final translator = GoogleTranslator();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final chatProvider = Provider.of<ChatProvider>(context);
    final screenShotProvider = Provider.of<ScreenShotProvider>(context);

    return PopScope(
        onPopInvoked: (didPop) {
          chatProvider.isLoadingFunction(false);
        },
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  chatProvider.isLoadingFunction(false);
                  // screenShotProvider.disposeLists();
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
              ],
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                          splashFactory: InkRipple.splashFactory,
                          overlayColor: MaterialStateProperty.all(
                              Colors.yellow.withOpacity(0.3))),
                      onPressed: () {
                        // if (screenShotProvider.extractedTextList.isEmpty) {
                        //   print('returning from function');
                        //   return;
                        // }
                        chooseCategorySheetF(context,
                            imgPath: widget.screenShot.toString());
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
                          chatProvider.isLoadingFunction(true);
                          chatProvider.getScreenShotFunction(widget.screenShot);
                          await screenShotProvider.extractTextFromImage(
                              context, selectedCategory, widget.screenShot);
                          // await screenShotProvider.askQuestionToChatbot(context,
                          //     category: "", imgPath: widget.screenShot);
                          chatProvider.isLoadingFunction(false);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                "Get Rizz Hindlish Reply",
                                style: TextStyle(color: Colors.white),
                              ),
                              Image.asset(
                                "assets/lightning_icon.png",
                                height: 30,
                              )
                            ],
                          ),
                        )),
                  )
                ],
              ),
            ),
            body: SingleChildScrollView(
                child: Column(children: [
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.3),
                  child: GestureDetector(
                      onTap: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                'Select Language',
                                style: TextStyle(
                                  fontSize: size.width * 0.05,
                                ),
                              ),
                              content: StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      RadioListTile<String>(
                                        title: Row(
                                          children: [
                                            SizedBox(
                                              width: size.width * 0.06,
                                              child: Image.asset(
                                                AssetIcons.india,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            const Text('Hindi'),
                                          ],
                                        ),
                                        value: 'Hindi',
                                        groupValue:
                                            chatProvider.selectedLanguage,
                                        onChanged: (value) {
                                          setState(() => chatProvider
                                              .selectedLanguageFunction(
                                                  value!));
                                          Navigator.pop(context);
                                        },
                                      ),
                                      RadioListTile<String>(
                                        title: Row(
                                          children: [
                                            SizedBox(
                                              width: size.width * 0.06,
                                              child: Image.asset(
                                                AssetIcons.hinglish,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            const Text('Hinglish'),
                                          ],
                                        ),
                                        value: 'Hinglish',
                                        groupValue:
                                            chatProvider.selectedLanguage,
                                        onChanged: (value) {
                                          setState(() => chatProvider
                                              .selectedLanguageFunction(
                                                  value!));
                                          Navigator.pop(context);
                                        },
                                      ),
                                      RadioListTile<String>(
                                        title: Row(
                                          children: [
                                            SizedBox(
                                              width: size.width * 0.09,
                                              child: Image.asset(
                                                AssetIcons.usFlag,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            const Text('English'),
                                          ],
                                        ),
                                        value: 'English',
                                        groupValue:
                                            chatProvider.selectedLanguage,
                                        onChanged: (value) {
                                          setState(() => chatProvider
                                              .selectedLanguageFunction(
                                                  value!));
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(colors: [
                                Colors.deepPurpleAccent.shade100,
                                Colors.pinkAccent.shade100
                              ])),
                          child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: chatProvider.selectedLanguage ==
                                              'Hindi'
                                          ? size.width * 0.06
                                          : chatProvider.selectedLanguage ==
                                                  'Hinglish'
                                              ? size.width * 0.1
                                              : size.width * 0.09,
                                      child: Image.asset(
                                        chatProvider.selectedLanguage == 'Hindi'
                                            ? AssetIcons.india
                                            : chatProvider.selectedLanguage ==
                                                    'Hinglish'
                                                ? AssetIcons.hinglish
                                                : AssetIcons.usFlag,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    const Text('- ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(chatProvider.selectedLanguage,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    const Text(' -',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    const Icon(Icons.expand_more_sharp),
                                    // Consider adding an arrow icon for visual indication
                                    // (optional)
                                  ]))))),
              const SizedBox(height: 20),

              ///
              ///
              /// container to preview image
              ///
              Container(
                  width: size.width * 0.75,
                  height: size.height * 0.5,
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file((File(widget.screenShot)),
                          fit: BoxFit.fill))),

              ///
              ///
              ///
              ///
              ///
              SizedBox(height: size.width * 0.08),
              if (chatProvider.isLoading)
                const Center(child: CircularProgressIndicator()),
              if (!chatProvider.isLoading &&
                  screenShotProvider.listOfResponses.isNotEmpty)
                Column(children: [
                  Image.asset('assets/ai_generated_lines.png',
                      width: size.width * 0.7),
                  SizedBox(height: size.width * 0.05),
                  if (screenShotProvider.extractedTextList.isNotEmpty &&
                      chatProvider.selectedLanguage != 'Hindi')
                    Wrap(
                        children:
                            screenShotProvider.extractedTextList.map((item) {
                      if (item.length > 10) {
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                width: size.width * 0.85,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                        title: Text(item.toString(),
                                            style: TextStyle(
                                                fontSize: size.width * 0.035,
                                                fontWeight: FontWeight.w500)),
                                        trailing: IconButton(
                                            onPressed: () {
                                              Clipboard.setData(ClipboardData(
                                                  text: item.toString()));
                                              ScaffoldMessenger.of(context)
                                                  .removeCurrentSnackBar();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content:
                                                          Text('Text Copied')));
                                            },
                                            icon: const Icon(Icons.copy))))));
                      }
                      return const SizedBox();
                    }).toList()),
                  if (screenShotProvider.translatedText.isNotEmpty &&
                      chatProvider.selectedLanguage == 'Hindi')
                    Wrap(
                        children: screenShotProvider.translatedText.map((item) {
                      if (item.length > 7) {
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                width: size.width * 0.85,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                        title: Text(item.toString(),
                                            style: TextStyle(
                                                fontSize: size.width * 0.035,
                                                fontWeight: FontWeight.w500)),
                                        trailing: IconButton(
                                            onPressed: () {
                                              Clipboard.setData(ClipboardData(
                                                  text: item.toString()));
                                              ScaffoldMessenger.of(context)
                                                  .removeCurrentSnackBar();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content:
                                                          Text('Text Copied')));
                                            },
                                            icon: const Icon(Icons.copy))))));
                      }
                      return const SizedBox();
                    }).toList())
                ])
            ]))));
  }

  /////////////////
  ///
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
  chooseCategorySheetF(context, {required String imgPath}) {
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
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 8.0),
                                child: InkWell(
                                    onTap: () {
                                      // debugPrint(category);
                                      selectedCategory = category;
                                      setState(() {});
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.27,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.08,
                                        decoration: BoxDecoration(
                                            color: selectedCategory == category
                                                ? ThemeColor.cyan
                                                : Colors.white,
                                            border: Border.all(),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Text(category,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11)))));
                          }).toList()))),

                  ///
                  /// get similar reply button
                  ///
                  Positioned(
                      right: 20,
                      bottom: 10,
                      child: InkWell(
                          onTap: () async {
                            Navigator.pop(context);
                            // ChatProvider chatProvider =
                            //     Provider.of<ChatProvider>(context, listen: false);
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
