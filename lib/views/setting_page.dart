import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hindlish/views/about_app_page.dart';
import 'package:hindlish/views/refer_a_friend_page.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animated_rating_stars/animated_rating_stars.dart';

import 'contact_us_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
            padding: EdgeInsets.all(size.width * 0.04),
            child: Container(
                width: size.width * 0.9,
                height: size.height * 0.65,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30))),
                child: Padding(
                    padding: EdgeInsets.all(size.width * 0.04),
                    child: Column(children: [
                      reusableListTile('About App', () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const AboutAppPage()));
                      }),
                      const Divider(),
                      reusableListTile('Contact us', () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ContactUsPage()));
                      }),
                      const Divider(),
                      reusableListTile('Subscription', () {
                        log('subscription');
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ReferAFriendPage()));
                      }),
                      const Divider(),
                      reusableListTile('Share with friends', () async {
                        final result = await Share.shareWithResult(
                            'check out my website https://www.apple.com/app-store/');

                        if (result.status == ShareResultStatus.success) {
                          print('Thank you for sharing my website!');
                        }
                      }),
                      reusableListTile('Rate us', () async {
                        showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                  title: const Text('RATE US'),
                                  content: Center(
                                    child: AnimatedRatingStars(
                                        initialRating: 3.5,
                                        minRating: 0.0,
                                        maxRating: 5.0,
                                        filledColor: Colors.amber,
                                        emptyColor: Colors.grey,
                                        filledIcon: Icons.star,
                                        halfFilledIcon: Icons.star_half,
                                        emptyIcon: Icons.star_border,
                                        onChanged: (double rating) async {
                                          if (rating > 3) {
                                            const url =
                                                'https://www.apple.com/app-store/';

                                            if (await canLaunch(url)) {
                                              await launch(url);
                                            } else {
                                              print('Could not launch url');
                                            }
                                          }
                                        },
                                        displayRatingValue: true,
                                        interactiveTooltips: true,
                                        customFilledIcon: Icons.star,
                                        customHalfFilledIcon: Icons.star_half,
                                        customEmptyIcon: Icons.star_border,
                                        starSize: 30.0,
                                        animationDuration:
                                            Duration(milliseconds: 300),
                                        animationCurve: Curves.easeInOut,
                                        readOnly: false),
                                  ),
                                  actions: [
                                    CupertinoButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Ok'))
                                  ],
                                  insetAnimationCurve: Curves.slowMiddle,
                                  insetAnimationDuration:
                                      const Duration(seconds: 2));
                            });
                      })
                    ])))));
  }
}

Widget reusableListTile(String label, Function()? function) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: CupertinoListTile(
      onTap: function,
      title: Text(label),
      trailing: const Icon(Icons.navigate_next_outlined),
    ),
  );
}
