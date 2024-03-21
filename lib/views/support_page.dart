import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Support Us'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///
              /// image
              ///
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/app_icon.png',
                    width: size.width * 0.56,
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.1,
                      vertical: size.width * 0.03),
                  child: Text(
                    'RIZZ HINDLISH',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: size.width * 0.06,
                    ),
                  ),
                ),
              ),
              Text(
                'Need assistance or have any questions? We are here to help',
                style: TextStyle(fontSize: size.width * 0.04),
              ),
              Text(
                'Support Options',
                style: TextStyle(
                    fontSize: size.width * 0.05, fontWeight: FontWeight.w600),
              ),
              const Text('For general inquiries or feedback please email us :'),
              Text('email@rizzhindlish.com',
                  style: TextStyle(
                      color: Colors.lightBlue, fontSize: size.width * 0.04)),
              Text(
                'Our team is dedicated to providing you with the best of'
                'our support and improving your experience with RIZZ HINDLISH. We appreciate'
                'your feedback and suggestions.',
                style: TextStyle(fontSize: size.width * 0.04),
              ),
            ],
          ),
        ));
  }
}
