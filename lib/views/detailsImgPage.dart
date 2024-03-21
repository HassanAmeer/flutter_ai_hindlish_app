import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hindlish/vm/chatListVm.dart';
import 'package:hindlish/vm/chat_provider.dart';
import 'package:hindlish/resources/assets.dart';
import 'package:hindlish/views/setting_page.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

class imgDetailsPage extends StatefulWidget {
  final Map? mapData;
  const imgDetailsPage({super.key, this.mapData = const {}});

  @override
  State<imgDetailsPage> createState() => _imgDetailsPageState();
}

class _imgDetailsPageState extends State<imgDetailsPage> {
  int selectedTab = 1;
  final FocusNode textFieldFocusNode = FocusNode();
  final translator = GoogleTranslator();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ChatProvider chatProvider =
        Provider.of<ChatProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            Navigator.pop(context);
          },
          icon: Image.asset('assets/icons/back_button.png'),
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
      extendBody: true,
      bottomNavigationBar: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
              vertical: 15),
          child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                  splashFactory: InkRipple.splashFactory,
                  overlayColor: MaterialStateProperty.all(
                      Colors.yellow.withOpacity(0.3))),
              onPressed: () async {
                showCupertinoDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title: const Text('Want To Delete ?'),
                        actions: [
                          CupertinoButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('NO')),
                          CupertinoButton(
                              onPressed: () {
                                Provider.of<ChatsListVmC>(context,
                                        listen: false)
                                    .deleteChatsVmF(widget.mapData);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'YES',
                                style: TextStyle(color: Colors.red),
                              )),
                        ],
                        insetAnimationCurve: Curves.slowMiddle,
                        insetAnimationDuration: const Duration(seconds: 2),
                      );
                    });
              },
              child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.delete_forever,
                    color: Colors.yellow,
                  ))),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Text("${widget.mapData}"),

            const SizedBox(height: 15),
            widget.mapData!['imgPath'].toString().isNotEmpty
                ? Container(
                    width: size.width * 0.75,
                    height: size.height * 0.5,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        (File(widget.mapData!['imgPath'].toString())),
                        fit: BoxFit.fill,
                      ),
                    ),
                  )
                : const Text(""),
            const SizedBox(height: 15),

            Column(
              children: [
                Image.asset('assets/ai_generated_lines.png',
                    width: size.width * 0.7),
                SizedBox(height: size.width * 0.05),
                if (widget.mapData!['eng'].isNotEmpty &&
                    chatProvider.selectedLanguage.toString() != 'Hindi')
                  ListView.builder(
                    itemCount: widget.mapData!['eng'].length,
                    shrinkWrap: true,
                    controller: ScrollController(),
                    itemBuilder: (BuildContext context, int index) {
                      var item = widget.mapData!['eng'][index]
                          .toString()
                          .replaceAll('"', "")
                          .trim();
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
                                                    content:
                                                        Text('Text Copied')));
                                          },
                                          icon: const Icon(Icons.copy))))));
                    },
                  ),
                if (widget.mapData!['hindi'].isNotEmpty &&
                    chatProvider.selectedLanguage.toString() == 'Hindi')
                  ListView.builder(
                    itemCount: widget.mapData!['hindi'].length,
                    shrinkWrap: true,
                    controller: ScrollController(),
                    itemBuilder: (BuildContext context, int index) {
                      var item = widget.mapData!['hindi'][index]
                          .toString()
                          .replaceAll('"', "")
                          .trim();
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
                                                    content:
                                                        Text('Text Copied')));
                                          },
                                          icon: const Icon(Icons.copy))))));
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
