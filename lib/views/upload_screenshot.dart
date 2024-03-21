import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hindlish/resources/assets.dart';
import 'package:hindlish/services/uploadScreenshotsSheet.dart';
import 'package:hindlish/views/chat_with_rizz_page.dart';
import 'package:hindlish/views/home_page.dart';
import 'package:hindlish/views/refer_a_friend_page.dart';
import 'package:hindlish/views/screenshot_response_page.dart';
import 'package:hindlish/views/setting_page.dart';
import 'package:hindlish/views/support_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../vm/chat_provider.dart';

class UploadScreenShot extends StatefulWidget {
  const UploadScreenShot({super.key});

  @override
  State<UploadScreenShot> createState() => _UploadScreenShotState();
}

class _UploadScreenShotState extends State<UploadScreenShot> {
  List forUploadImgsList = [
    AssetIcons.gallery,
    AssetIcons.gallery,
    AssetIcons.gallery,
  ];
  final ImagePicker picker = ImagePicker();

  int selectedTab = 1;
  String imagePath = '';
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
            icon: Image.asset(AssetIcons.menu),
            onPressed: (() {
              Scaffold.of(context).openDrawer();
            }),
          );
        }),
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
      drawer: Drawer(
        backgroundColor: const Color.fromRGBO(99, 99, 99, 1),
        width: MediaQuery.of(context).size.width * 0.65,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            ListTile(
                leading: const CircleAvatar(
                    backgroundImage: AssetImage(AssetImages.userProfile)),
                title: const Text(
                  "kamran Creation",
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text("admin@gmail.com",
                    style: TextStyle(color: Colors.grey.shade400))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CupertinoListTile(
                    onTap: () {
                      chatProvider.selectedTabFunction(1);
                      setState(() {});
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ));
                    },
                    backgroundColor: chatProvider.selectedTab == 1
                        ? Colors.black
                        : Colors.transparent,
                    leading: Image.asset(AssetIcons.calender),
                    title: const Text(
                      "Home",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CupertinoListTile(
                    onTap: () {
                      chatProvider.selectedTabFunction(2);
                      Navigator.pop(context);
                      setState(() {});
                    },
                    backgroundColor: chatProvider.selectedTab == 2
                        ? Colors.black
                        : Colors.transparent,
                    leading: const Icon(
                      Icons.image,
                      color: Colors.grey,
                    ),
                    // leading: Image.asset(AssetIcons.gallery),
                    title: const Text(
                      "Upload Screenshots",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CupertinoListTile(
                    onTap: () {
                      chatProvider.selectedTabFunction(3);

                      setState(() {});
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ReferAFriendPage(),
                      ));
                    },
                    backgroundColor: chatProvider.selectedTab == 3
                        ? Colors.black
                        : Colors.transparent,
                    // leading: Icon(
                    //   Bootstrap.person_plus,
                    //   color: Colors.white,
                    // ),
                    leading: Image.asset(AssetIcons.users),
                    title: const Text(
                      "Reffer a Friend",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CupertinoListTile(
                    onTap: () {
                      chatProvider.selectedTabFunction(4);

                      setState(() {});
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SupportPage(),
                      ));
                    },
                    backgroundColor: chatProvider.selectedTab == 4
                        ? Colors.black
                        : Colors.transparent,
                    leading: Image.asset(AssetIcons.phone),
                    title: const Text(
                      "Support",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)))),
                onPressed: () {
                  // showModalBottomSheet(
                  //     context: context,
                  //     builder: (BuildContext context) {
                  //       return StatefulBuilder(builder: (context, setState) {
                  //         return Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           children: [
                  //             Row(
                  //               mainAxisAlignment:
                  //                   MainAxisAlignment.spaceBetween,
                  //               children: [
                  //                 IconButton(
                  //                     onPressed: () {
                  //                       Navigator.pop(context);
                  //                     },
                  //                     icon: const Icon(Icons.close)),
                  //                 const Center(
                  //                     child: Text("Upload Screenshots")),
                  //                 TextButton(
                  //                   onPressed: () async {
                  //                     final imagePath = await ImagePicker()
                  //                         .pickImage(
                  //                             source: ImageSource.gallery);
                  //                     if (imagePath != null) {
                  //                       print(imagePath.path);
                  //                       chatProvider.addBottomScreenShots(
                  //                           imagePath.path);
                  //                       setState(() {});
                  //                     }
                  //                   },
                  //                   child: const Text('Add Image'),
                  //                 ),
                  //               ],
                  //             ),
                  //             FutureBuilder(
                  //               future:
                  //                   chatProvider.getBottomSheetScreenShots(),
                  //               builder: (context, snapshot) {
                  //                 if (snapshot.connectionState ==
                  //                     ConnectionState.waiting) {
                  //                   return const CircularProgressIndicator();
                  //                 }
                  //                 if (snapshot.hasError) {
                  //                   return const Text('Some error occurred');
                  //                 }
                  //                 return Wrap(
                  //                   children: chatProvider
                  //                       .bottomSheetScreenShots
                  //                       .map((e) => (e.toString().isNotEmpty &&
                  //                               e.toString() != 'null')
                  //                           ? Padding(
                  //                               padding:
                  //                                   const EdgeInsets.all(10),
                  //                               child: InkWell(
                  //                                 onTap: () {
                  //                                   print(
                  //                                       'go to next page with image path');
                  //                                   Navigator.of(context)
                  //                                       .push(MaterialPageRoute(
                  //                                     builder: (context) =>
                  //                                         ScreenShotResponsePage(
                  //                                             screenShot: e),
                  //                                   ));
                  //                                   print(e);
                  //                                 },
                  //                                 child: Stack(children: [
                  //                                   Container(
                  //                                     width: 100,
                  //                                     height: 100,
                  //                                     decoration: BoxDecoration(
                  //                                       borderRadius:
                  //                                           BorderRadius
                  //                                               .circular(10),
                  //                                       border: Border.all(),
                  //                                     ),
                  //                                     child: ClipRRect(
                  //                                       borderRadius:
                  //                                           BorderRadius
                  //                                               .circular(10),
                  //                                       child: Image.file(
                  //                                         File(e),
                  //                                         fit: BoxFit.fill,
                  //                                       ),
                  //                                     ),
                  //                                   ),
                  //                                   Positioned(
                  //                                     right: -12,
                  //                                     top: -12,
                  //                                     child: IconButton(
                  //                                         onPressed: () {
                  //                                           chatProvider
                  //                                               .deleteScreenShotFromHive(
                  //                                                   e);
                  //                                           setState(() {});
                  //                                         },
                  //                                         icon: const Icon(
                  //                                           Icons.delete,
                  //                                           color: Colors.red,
                  //                                         )),
                  //                                   ),
                  //                                 ]),
                  //                               ),
                  //                             )
                  //                           : SizedBox())
                  //                       .toList(),
                  //                 );
                  //               },
                  //             ),
                  //           ],
                  //         );
                  //       });
                  //     });
                  openUploadImgSheetF(context);
                },
                child: const Text("Upload a screenshot",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.47,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)))),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ChatWithRizzPage(),
                    ));
                  },
                  child: const Text("Enter Text Manually",
                      style: TextStyle(color: Colors.black, fontSize: 11)),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.38,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)))),
                  onPressed: () {},
                  child: const Text("GPT-3 / GPT-4",
                      style: TextStyle(color: Colors.black, fontSize: 11)),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                      builder: (BuildContext context, StateSetter setState) {
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
                              groupValue: chatProvider.selectedLanguage,
                              onChanged: (value) {
                                setState(() => chatProvider
                                    .selectedLanguageFunction(value!));
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
                              groupValue: chatProvider.selectedLanguage,
                              onChanged: (value) {
                                setState(() => chatProvider
                                    .selectedLanguageFunction(value!));
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: chatProvider.selectedLanguage == 'Hindi'
                              ? size.width * 0.06
                              : size.width * 0.09,
                          child: Image.asset(
                            chatProvider.selectedLanguage == 'Hindi'
                                ? AssetIcons.india
                                : AssetIcons.usFlag,
                            fit: BoxFit.fill,
                          ),
                        ),
                        const Text(
                          '- ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          chatProvider.selectedLanguage,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          ' -',
                          style: TextStyle(fontWeight: FontWeight.bold),
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
