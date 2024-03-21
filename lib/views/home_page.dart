import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hindlish/purchase_api.dart';
import 'package:hindlish/vm/chat_provider.dart';
import 'package:hindlish/resources/assets.dart';
import 'package:hindlish/views/chat_with_rizz_page.dart';
import 'package:hindlish/views/logout.dart';
import 'package:hindlish/views/setting_page.dart';
import 'package:hindlish/views/refer_a_friend_page.dart';
import 'package:hindlish/views/support_page.dart';
import 'package:provider/provider.dart';
import '../services/uploadScreenshotsSheet.dart';
import '../vm/chatListVm.dart';
import 'detailsImgPage.dart';
import 'detailsPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List screenShotsList = [
    AssetImages.wpimage,
    AssetImages.wpimage,
    AssetImages.wpimage,
    AssetImages.wpimage,
    AssetImages.wpimage,
    AssetImages.wpimage,
  ];
  // int selectedTab = 1;
  bool isStartUp = true;
  @override
  void initState() {
    Provider.of<ChatsListVmC>(context, listen: false).getChatsVmF();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      onPopInvoked: (canPop) {
        Logout().exit(context);
        Future.value(false);
      },
      child: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          return Consumer<ChatsListVmC>(builder: (context, chatsValue, child) {
            chatsValue.getChatsVmF();
            return Scaffold(
                appBar: AppBar(
                    leading: Builder(builder: (context) {
                      return IconButton(
                          icon: Image.asset(AssetIcons.menu),
                          onPressed: (() {
                            Scaffold.of(context).openDrawer();
                          }));
                    }),
                    title: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Image.asset(AssetIcons.hindlish)),
                    centerTitle: true,
                    actions: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const SettingPage()));
                          },
                          icon: Image.asset(AssetIcons.setting))
                    ]),
                drawer: Drawer(
                    backgroundColor: const Color.fromRGBO(99, 99, 99, 1),
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: Column(children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06),
                      ListTile(
                          leading: const CircleAvatar(
                              backgroundImage:
                                  AssetImage(AssetImages.userProfile)),
                          title: const Text("User Creation",
                              style: TextStyle(color: Colors.white)),
                          subtitle: Text("user@gmail.com",
                              style: TextStyle(color: Colors.grey.shade400))),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 4),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CupertinoListTile(
                                  onTap: () {
                                    chatProvider.selectedTabFunction(1);
                                    setState(() {});
                                    Navigator.pop(context);
                                  },
                                  backgroundColor: chatProvider.selectedTab == 1
                                      ? Colors.black
                                      : Colors.transparent,
                                  leading: Image.asset(AssetIcons.calender),
                                  title: const Text("Home",
                                      style: TextStyle(color: Colors.white))))),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 4),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CupertinoListTile(
                                  onTap: () {
                                    chatProvider.selectedTabFunction(2);
                                    setState(() {});
                                    Navigator.pop(context);
                                    openUploadImgSheetF(context);
                                  },
                                  backgroundColor: chatProvider.selectedTab == 2
                                      ? Colors.black
                                      : Colors.transparent,
                                  leading: const Icon(Icons.image,
                                      color: Colors.grey),
                                  // leading: Image.asset(AssetIcons.gallery),
                                  title: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Upload Screenshots",
                                          style: TextStyle(
                                              color: Colors.white)))))),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 4),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CupertinoListTile(
                              onTap: () {
                                chatProvider.selectedTabFunction(3);
                                setState(() {});
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const ReferAFriendPage()));
                              },
                              backgroundColor: chatProvider.selectedTab == 3
                                  ? Colors.black
                                  : Colors.transparent,
                              leading: Image.asset(AssetIcons.users),
                              title: const Text(
                                "Reffer a Friend",
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 4),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CupertinoListTile(
                                  onTap: () {
                                    chatProvider.selectedTabFunction(4);

                                    setState(() {});
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => const SupportPage(),
                                    ));
                                  },
                                  backgroundColor: chatProvider.selectedTab == 4
                                      ? Colors.black
                                      : Colors.transparent,
                                  leading: Image.asset(AssetIcons.phone),
                                  title: const Text("Support",
                                      style: TextStyle(color: Colors.white)))))
                    ])),
                bottomNavigationBar:
                    Column(mainAxisSize: MainAxisSize.min, children: [
                  // ElevatedButton(
                  //     onPressed: () async {
                  //       final offerings = await PurchaseApi.fetchOffers();
                  //       if (offerings.isEmpty) {
                  //         ScaffoldMessenger.of(context).showSnackBar(
                  //           SnackBar(content: Text('offers EMpty')),
                  //         );
                  //       } else {
                  //         var offer = offerings.first;
                  //         debugPrint("📜 $offer");
                  //       }
                  //     },
                  //     child: Text("Get Offers")),
                  Center(
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.black),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)))),
                              onPressed: () {
                                openUploadImgSheetF(context);
                              },
                              child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 13),
                                  child: Text("Upload a screenshot",
                                      style:
                                          TextStyle(color: Colors.white)))))),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)))),
                              onPressed: () {
                                final chatFunction = Provider.of<ChatProvider>(
                                    context,
                                    listen: false);
                                chatFunction.theirReplyFunction("");
                                chatFunction.yourReplyFunction("");
                                chatFunction.showTextFieldFunction(false);
                                chatFunction.getHindiTextList.clear();
                                chatFunction.getEnglishTextList.clear();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const ChatWithRizzPage()));
                              },
                              child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 14.0),
                                  child: Text("Enter Text Manually",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 11))))),
                      //     SizedBox(
                      //       width: MediaQuery.of(context).size.width * 0.47,
                      //       child: ElevatedButton(
                      //         style: ButtonStyle(
                      //             backgroundColor:
                      //                 MaterialStateProperty.all(Colors.white),
                      //             shape: MaterialStateProperty.all(
                      //                 RoundedRectangleBorder(
                      //                     borderRadius:
                      //                         BorderRadius.circular(15)))),
                      //         onPressed: () {
                      //           Navigator.of(context).push(MaterialPageRoute(
                      //             builder: (context) => const ChatWithRizzPage(),
                      //           ));
                      //         },
                      //         child: const Padding(
                      //           padding: EdgeInsets.symmetric(vertical: 14.0),
                      //           child: Text("Enter Text Manually",
                      //               style: TextStyle(
                      //                   color: Colors.black, fontSize: 11)),
                      //         ),
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: MediaQuery.of(context).size.width * 0.38,
                      //       child: ElevatedButton(
                      //         style: ButtonStyle(
                      //             backgroundColor:
                      //                 MaterialStateProperty.all(Colors.white),
                      //             shape: MaterialStateProperty.all(
                      //                 RoundedRectangleBorder(
                      //                     borderRadius:
                      //                         BorderRadius.circular(15)))),
                      //         onPressed: () {},
                      //         child: const Padding(
                      //           padding: EdgeInsets.symmetric(vertical: 14),
                      //           child: Text("GPT-3 / GPT-4",
                      //               style: TextStyle(
                      //                   color: Colors.black, fontSize: 11)),
                      //         ),
                      //       ),
                      //     ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04)
                ]),
                body: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.3),
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
                                  content: StatefulBuilder(builder:
                                      (BuildContext context,
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
                                              }),
                                          RadioListTile<String>(
                                              title: Row(children: [
                                                SizedBox(
                                                    width: size.width * 0.06,
                                                    child: Image.asset(
                                                        AssetIcons.hinglish,
                                                        fit: BoxFit.fill)),
                                                const SizedBox(width: 15),
                                                const Text('Hinglish')
                                              ]),
                                              value: 'Hinglish',
                                              groupValue:
                                                  chatProvider.selectedLanguage,
                                              onChanged: (value) {
                                                setState(() => chatProvider
                                                    .selectedLanguageFunction(
                                                        value!));
                                                Navigator.pop(context);
                                              }),
                                          RadioListTile<String>(
                                              title: Row(children: [
                                                SizedBox(
                                                    width: size.width * 0.09,
                                                    child: Image.asset(
                                                        AssetIcons.usFlag,
                                                        fit: BoxFit.cover)),
                                                const SizedBox(width: 15),
                                                const Text('English')
                                              ]),
                                              value: 'English',
                                              groupValue:
                                                  chatProvider.selectedLanguage,
                                              onChanged: (value) {
                                                setState(() => chatProvider
                                                    .selectedLanguageFunction(
                                                        value!));
                                                Navigator.pop(context);
                                              })
                                        ]);
                                  }))),
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
                                          chatProvider.selectedLanguage ==
                                                  'Hindi'
                                              ? AssetIcons.india
                                              : chatProvider.selectedLanguage ==
                                                      'Hinglish'
                                                  ? AssetIcons.hinglish
                                                  : AssetIcons.usFlag,
                                          fit: BoxFit.fill)),
                                  const Text(
                                    '- ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    chatProvider.selectedLanguage,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Text(
                                    '- ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const Icon(Icons.expand_more_sharp),
                                  // Consider adding an arrow icon for visual indication
                                  // (optional)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      chatsValue.getAllChatsList.isEmpty
                          ? const Center(child: Text("Empty"))
                          : Center(
                              child: Wrap(
                                  children:
                                      chatsValue.getAllChatsList.map((item) {
                              //  return Text("$item");
                              return (item['isFromText'] == true)
                                  ? GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TextDetailsPage(
                                                        mapData: item)));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 13),
                                        child: Stack(
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              height: size.height * 0.22,
                                              width: size.width * 0.28,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: Colors
                                                          .blueGrey.shade700),
                                                  color: Colors.white),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0),
                                                child: ListView.builder(
                                                  itemCount: chatProvider
                                                              .selectedLanguage
                                                              .toString() ==
                                                          "Hindi"
                                                      ? item['hindi'].length
                                                      : chatProvider
                                                                  .selectedLanguage
                                                                  .toString() ==
                                                              "Hinglish"
                                                          ? item['hinglish']
                                                              .length
                                                          : item['eng'].length,
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return chatProvider
                                                                .selectedLanguage
                                                                .toString() ==
                                                            "Hindi"
                                                        ? Column(
                                                            children: [
                                                              Text(
                                                                  "${item['hindi'][index].toString().length > 25 ? item['hindi'][index].toString().substring(0, 24).replaceAll('"', '') : item['hindi'][index].toString().length}",
                                                                  // maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: TextStyle(
                                                                      color: index.isOdd
                                                                          ? Colors
                                                                              .red
                                                                          : Colors
                                                                              .blueGrey
                                                                              .shade600,
                                                                      fontSize:
                                                                          10)),
                                                              const Divider(
                                                                  height: 1)
                                                            ],
                                                          )
                                                        : chatProvider
                                                                    .selectedLanguage
                                                                    .toString() ==
                                                                "Hinglish"
                                                            ? Column(
                                                                children: [
                                                                  Text(
                                                                      "${item['hinglish'][index].toString().length > 25 ? item['eng'][index].toString().substring(0, 24).replaceAll('"', '') : item['eng'][index].toString().length}",
                                                                      // maxLines: 2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: TextStyle(
                                                                          color: index.isOdd
                                                                              ? Colors.red
                                                                              : Colors.blueGrey.shade600,
                                                                          fontSize: 10)),
                                                                  const Divider(
                                                                      height: 1)
                                                                ],
                                                              )
                                                            : Column(
                                                                children: [
                                                                  Text(
                                                                      "${item['eng'][index].toString().length > 25 ? item['eng'][index].toString().substring(0, 24).replaceAll('"', '') : item['eng'][index].toString().length}",
                                                                      // maxLines: 2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: TextStyle(
                                                                          color: index.isOdd
                                                                              ? Colors.red
                                                                              : Colors.blueGrey.shade600,
                                                                          fontSize: 10)),
                                                                  const Divider(
                                                                      height: 1)
                                                                ],
                                                              );
                                                  },
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .28,
                                                decoration: const BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomRight: Radius
                                                                .circular(12),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    12))),
                                                child: const Icon(
                                                  Icons.remove_red_eye,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    imgDetailsPage(
                                                        mapData: item)));
                                      },
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 13),
                                          child: Container(
                                              alignment: Alignment.center,
                                              height: size.height * 0.22,
                                              width: size.width * 0.28,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(),
                                                  color: Colors.white),
                                              child: SingleChildScrollView(
                                                  child: Image.file(
                                                File("${item['imgPath']}"),
                                                fit: BoxFit.cover,
                                              )))));
                            }).toList()))
                    ])));
          });
        },
      ),
    );
  }
}
