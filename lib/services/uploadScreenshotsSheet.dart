import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../views/screenshot_response_page.dart';
import '../vm/chat_provider.dart';
import '../vm/screenshot_provider.dart';
import '../vm/uploadedImgsVM.dart';

openUploadImgSheetF(context) {
  final checkIftextInList =
      Provider.of<ScreenShotProvider>(context, listen: false);
  checkIftextInList.translatedText.clear();
  checkIftextInList.extractedTextList.clear();
  ///////////
  Provider.of<UploadImgsVMC>(context, listen: false).getImgs();
  showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Consumer<UploadImgsVMC>(builder: (context, imgsValue, child) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close)),
                      const Center(
                          child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Upload Screenshots"))),
                      TextButton(
                          onPressed: () async {
                            final imagePath = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            if (imagePath != null) {
                              debugPrint(imagePath.path);
                              imgsValue.addImgs(imagePath.path);
                            }
                          },
                          child: const Text('Add Image'))
                    ]),
                imgsValue.uploadedImgs.isEmpty
                    ? Transform.translate(
                        offset:
                            Offset(0, MediaQuery.of(context).size.height * 0.2),
                        child: Center(
                            child: Text("EMPTY",
                                style: TextStyle(
                                    color: Colors.blueGrey.shade200,
                                    fontSize: 25))))
                    : Wrap(
                        children: imgsValue.uploadedImgs
                            .map((e) => (e.toString().isNotEmpty &&
                                    e.toString() != 'null')
                                ? Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ScreenShotResponsePage(
                                                          screenShot: e)));
                                        },
                                        child: Stack(children: [
                                          Container(
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all()),
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child: Image.file(File(e),
                                                      fit: BoxFit.fill))),
                                          Positioned(
                                              right: -12,
                                              top: -12,
                                              child: IconButton(
                                                  onPressed: () {
                                                    imgsValue.deleteImgs(e);
                                                  },
                                                  icon: const Icon(Icons.delete,
                                                      color: Colors.red)))
                                        ])))
                                : const SizedBox())
                            .toList())
              ]);
        });
      });
}
