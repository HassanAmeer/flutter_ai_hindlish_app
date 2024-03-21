import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseAPI {
  static const _apiKeyAndroid = 'goog_tCsyXyQRyxzMsMUwElCclfGdfxO';
  static const _apiKeiIos = 'appl_tzJSwzeOGDzKBUyhaHYzZHhhffS';

  static bool isPaid = false;

  static Offering? offering = null;
  static Future<void> initialize() async {
    await Purchases.setLogLevel(LogLevel.debug);
    await Purchases.configure(PurchasesConfiguration(Platform.isAndroid ? _apiKeyAndroid : _apiKeiIos));
    await getOffers();
    await checkSubscriptionStatus();
  }

  // static Future<bool> checkYearlySubscription(List<EntitlementInfo> allActiveSubscription) async{
  //   // check user have yearly Premium package enabled and also user is logged in
  //
  //   bool hasYearly = false;
  //   allActiveSubscription.map((e) {
  //     if(e.identifier == "gerente_97_1y:gerente-97-1y" || e.identifier == "gerente_97_1y"){
  //       hasYearly = true;
  //     }
  //   }).toList();
  //
  //   if(hasYearly && FirebaseAuth.instance.currentUser != null){
  //
  //     int avaliable_advices;
  //     String? expirationDate;
  //     var uid = FirebaseAuth.instance.currentUser?.uid ?? "";
  //     await FirebaseFirestore.instance.collection("users").doc(uid).get().then((value) async {
  //       avaliable_advices = value.data()?['legal_advices'] ?? 0;
  //       expirationDate = value.data()?["expirationDate"] ?? null;
  //
  //
  //       if(expirationDate != null){
  //         var currentDate = DateTime.now();
  //         DateTime tempExpiration = DateTime.parse(expirationDate ?? "");
  //         if(isPaid && currentDate.isAfter(tempExpiration)){
  //           avaliable_advices += 2;
  //
  //           var expirationDate1 = DateTime.now().add(Duration(days: 365));
  //           var currentDate1 = DateTime.now();
  //           await FirebaseFirestore.instance.collection("users").doc(uid).update({
  //             "legal_advices" : avaliable_advices,
  //             "purchaseDate" : currentDate1.toString(),
  //             "expirationDate" : expirationDate1.toString()
  //           }).then((value) {
  //             return true;
  //           });
  //         }
  //       } else{
  //         return true;
  //       }
  //
  //
  //
  //
  //     });
  //
  //
  //   }
  //
  //   return true;
  // }

  static Future<void> getOffers() async {

    try {
      var offerings = await Purchases.getOfferings();

      offering = offerings.current;

      log("======");
      log(offering.toString());

    } on PlatformException catch (e) {
      log(e.message.toString());
      offering = null;

    }



  }

  static Future<bool> purchaseProduct(Package package, {BuildContext? context}) async {
    try {
      var purchaserInfo =
      await Purchases.purchasePackage(package);

      if(purchaserInfo.activeSubscriptions.isNotEmpty){
        isPaid = true;
      }

      // Handle successful purchase
      print('Purchase successful: $purchaserInfo');
      return true;
    } catch (e) {
      // Handle purchase error
      print('Purchase error: $e');
      // if(context != null)
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      return false;
    }
  }

  static Future<bool> restorePurchases() async {
    try {
      CustomerInfo purchaserInfo = await Purchases.restorePurchases();
      log(purchaserInfo.entitlements.all.toString());
      // Check subscription status
      bool proSubscription =
          purchaserInfo.activeSubscriptions.isNotEmpty;


      log("==");
      log(proSubscription.toString());

      if (proSubscription) {
        log("==");
        print('Pro subscription is active restore');
        isPaid = true;
      } else {
        log("==");
        print('Pro subscription is not activerestore');
        isPaid = false;
      }

      return isPaid;
      // Handle successful restore
      print('Purchases restored: $purchaserInfo');
    } on Error catch (e) {
      // Handle restore error
      print('Restore error: $e');
      return false;
    }
  }

  static Future<void> checkSubscriptionStatus() async {
    log("hello");
    try {
      CustomerInfo purchaserInfo = await Purchases.getCustomerInfo();
      log(purchaserInfo.entitlements.all.toString());
      // Check subscription status
      bool proSubscription =

          purchaserInfo.entitlements.active.isNotEmpty;


      if (proSubscription) {
        log("==");
        print('Pro subscription is active');
        isPaid = true;
      } else {
        log("==");
        print('Pro subscription is not active');
        isPaid = false;
      }

      // await checkYearlySubscription( purchaserInfo.entitlements.active.values.toList());
    } on Error catch (e) {
      // Handle error
      print('Error checking subscription status: $e');
    }
  }
}