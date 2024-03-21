import 'package:flutter/material.dart';
import 'package:hindlish/purchase_api.dart';
import 'package:hindlish/resources/assets.dart';
import 'package:hindlish/views/home_page.dart';
import 'package:hindlish/views/intro.dart';
import 'package:hive/hive.dart';

import 'refer_a_friend_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    checkIntroViewed();
  }

  checkIntroViewed() async {
    var hiveDb = await Hive.openBox('Stngs');
    var checkIntroValue = await hiveDb.get("isViewIntroPages");
    // debugPrint("💥$checkIntroValue");
    if (checkIntroValue != null &&
        checkIntroValue['isViewIntroPages'].toString() == "true") {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1500),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return FadeTransition(
                opacity: animation,
                child:  PurchaseAPI.isPaid ? HomePage() :  ReferAFriendPage(),
                // child: const HomePage(),
              );
            },
          ),
        );
      });
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 3000),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return FadeTransition(
                opacity: animation,
                child: const IntroPage(),
              );
            },
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(AssetIcons.hindlish),
      ),
    );
  }
}

// Hinglish