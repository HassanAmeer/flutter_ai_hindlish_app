import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hindlish/purchase_api.dart';
import 'package:hindlish/views/home_page.dart';
import 'package:pay/pay.dart';
import 'package:purchases_flutter/models/offering_wrapper.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import 'package:share_plus/share_plus.dart';

class ReferAFriendPage extends StatefulWidget {
  const ReferAFriendPage({super.key});

  @override
  State<ReferAFriendPage> createState() => _ReferAFriendPageState();
}

class _ReferAFriendPageState extends State<ReferAFriendPage> {
  bool weeklyPlanSelected = false;
  int selectedPlanAmount = 0;
  bool montlyPlanSelected = false;
  bool isLoading = false;
  Pay payClient = Pay.withAssets(['gpay.json']);
  Package? monthly = PurchaseAPI.offering?.monthly;
  Package? weekly = PurchaseAPI.offering?.weekly;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()));
                  },
                  child: const Text("SKIP"))
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.1, vertical: size.width * 0.1),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/hindlish.png',
                    width: size.width * 0.7,
                  ),
                  SizedBox(height: size.width * 0.06),
                  Image.asset(
                    'assets/lightning_icon.png',
                    width: size.width * 0.2,
                  ),
                  // SizedBox(height: size.width * 0.045),
                  // const Text(
                  //   'Refer to your friend and \nget 10% off on weekly subscription',
                  //   textAlign: TextAlign.center,
                  // ),
                  // SizedBox(height: size.width * 0.045),
                  // InkWell(
                  //   onTap: () async {
                  //     log('share app');
                  //     await Share.share(
                  //         'https://google.com \n\n download riz app with my referral code');
                  //   },
                  //   child: Image.asset(
                  //     'assets/invite_button.png',
                  //     width: size.width * 0.7,
                  //   ),
                  // ),
                  // SizedBox(height: size.width * 0.056),
                  SizedBox(
                    height: size.height * 0.06,
                  ),
                  Image.asset(
                    'assets/icons/profile_icon.png',
                    width: size.width * 0.17,
                  ),
                  SizedBox(height: size.width * 0.02),
                  const Text(
                    'Unlimited Replies',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text('Get access to unlimited lines'),
                  SizedBox(height: size.width * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            weeklyPlanSelected = true;
                            montlyPlanSelected = false;
                            selectedPlanAmount = 30;
                          });
                        },
                        child: Container(
                          height: size.height * 0.13,
                          width: size.width * 0.3,
                          decoration: BoxDecoration(
                            color: weeklyPlanSelected
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                bottomLeft: Radius.circular(15)),
                            border: Border.all(),
                          ),
                          child: const Text(
                            '1\nWeek\n₹\n30',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            weeklyPlanSelected = false;
                            montlyPlanSelected = true;
                            selectedPlanAmount = 100;
                          });
                        },
                        child: Container(
                          height: size.height * 0.13,
                          width: size.width * 0.3,
                          decoration: BoxDecoration(
                            color: montlyPlanSelected
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(15),
                                bottomRight: Radius.circular(15)),
                            border: Border.all(),
                          ),
                          child: const Text(
                            '1\nMonth\n₹\n100',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.width * 0.03),
                  SizedBox(
                    width: size.width,
                    height: size.height * 0.06,
                    child: FilledButton(
                      style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                        backgroundColor:
                            const MaterialStatePropertyAll(Colors.yellowAccent),
                      ),
                      onPressed: () async {
                        if (weeklyPlanSelected == false &&
                            montlyPlanSelected == false) {
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please Select a plan')));
                          return;
                        }

                        String message = "";

                        isLoading = true;
                        setState(() {});

                        Package? userSelectedPackage =
                            weeklyPlanSelected ? weekly : monthly;

                        PurchaseAPI.purchaseProduct(userSelectedPackage!)
                            .then((value) {
                          if (value) {
                            // purchase was successful
                            message =
                                "You have purchased the package Successful";
                            PurchaseAPI.isPaid = true;
                          } else {
                            message = "Failed to Purchased the package";
                            PurchaseAPI.isPaid = false;
                          }

                          isLoading = false;
                          setState(() {});

                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => AlertDialog(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0))),
                                    contentPadding: const EdgeInsets.all(16),
                                    alignment: Alignment.center,
                                    backgroundColor: Colors.white,
                                    content: SizedBox(
                                      width: 280,
                                      height: 240,
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: PurchaseAPI.isPaid
                                                    ? Colors.green
                                                    : Colors.redAccent),
                                            child: Icon(
                                              PurchaseAPI.isPaid
                                                  ? Icons.check
                                                  : Icons.error_outline_sharp,
                                              color: Colors.white,
                                              size: 28,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 25,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Text(
                                              message,
                                              style: TextStyle(fontSize: 16),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 25,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              if (PurchaseAPI.isPaid) {
                                                Navigator.of(context)
                                                    .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const HomePage(),
                                                  ),
                                                  (route) => false,
                                                );
                                              } else {
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: Container(
                                              width: 220,
                                              decoration: BoxDecoration(
                                                color: PurchaseAPI.isPaid
                                                    ? Colors.yellowAccent
                                                    : Colors.yellowAccent
                                                        .withOpacity(0.4),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: const Center(
                                                  child: Text(
                                                "Continue",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )).then((value) {
                            if (PurchaseAPI.isPaid) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                                (route) => false,
                              );
                            }
                          });
                        });
                      },
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Positioned(
                            top: 10.0,
                            left: size.width * 0.23,
                            child: const Text(
                              'Buy Now',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          if (selectedPlanAmount != 0)
                            Positioned(
                              right: 0.0,
                              top: 10.0,
                              child: Text(
                                '$selectedPlanAmount ₹',
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isLoading)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.yellowAccent,
              ),
            ),
          )
      ],
    );
  }
}
