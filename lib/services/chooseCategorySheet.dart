import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/theme.dart';
import '../vm/chat_provider.dart';
import '../vm/screenshot_provider.dart';

chooseCategorySheetF(context, {required String imgPath}) {
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
                                      width: MediaQuery.of(context).size.width *
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
                          ChatProvider chatProvider =
                              Provider.of<ChatProvider>(context, listen: false);
                          ScreenShotProvider scProvider =
                              Provider.of<ScreenShotProvider>(context,
                                  listen: false);
                          if (imgPath.toString().isNotEmpty) {
                            chatProvider.isLoadingFunction(true);
                            await scProvider.extractTextFromImage(
                                context,
                                selectedCategory.toString(),
                                imgPath.toString());
                            chatProvider.isLoadingFunction(false);
                          } else {
                            chatProvider.isLoadingFunction(true);
                            await chatProvider.askQuestionToChatbot(
                                context, selectedCategory);
                            chatProvider.addDataToHive();
                            chatProvider.isLoadingFunction(false);
                          }
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
