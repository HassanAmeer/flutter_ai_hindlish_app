import 'package:flutter/material.dart';
import 'package:hindlish/resources/assets.dart';
import 'package:hindlish/views/home_page.dart';
import 'package:hive/hive.dart';

import 'refer_a_friend_page.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  PageController pageContr = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageContr,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(AssetImages.intro1),
                Text("Introduction to Rizz Hindlish",
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(color: Colors.black)),
                const SizedBox(height: 18),
                Text(
                    """AI dating assistant & discover the benefits of using RizzHindlish & RizzClone for language tasks""",
                    // """Meet Chatbot, your personal AI language model & discover the benefits of using RizzHindlish & RizzClone for language tasks""",
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(color: Colors.black)),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 10,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5)),
                          child: const Text("       "),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          height: 10,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(5)),
                          child: const Text("   "),
                        ),
                      ],
                    ),
                    IconButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black)),
                        onPressed: () {
                          pageContr.jumpToPage(1);
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                        )),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(AssetImages.intro2),
                Text("Getting started with Rizz Hindlish",
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(color: Colors.black)),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Text("""Try out different language tasks and \nmodes. """,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(color: Colors.black)),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 10,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(5)),
                          child: const Text("   "),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          height: 10,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5)),
                          child: const Text("       "),
                        ),
                      ],
                    ),
                    IconButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black)),
                        onPressed: () async {
                          var hiveDb = await Hive.openBox('Stngs');
                          await hiveDb.put("isViewIntroPages", {
                            "isViewIntroPages": true,
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ReferAFriendPage(),
                                // builder: (context) => const HomePage(),
                              ));
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                        )),
                  ],
                )
              ],
            ),
          ),
          //////////////////////////////////////////
        ],
      ),
    );
  }
}
