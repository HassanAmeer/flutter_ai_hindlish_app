import 'package:flutter/material.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text('About Us'),
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
                'RIZZ HINDLISH takes your conversation with people to the next level.'
                ' Win conversation with our AI ChatBot Professional and attractive responses.'
                ' For those who feel behind in conversation This app is like a savior for those'
                ' Just paste your conversation and get response within seconds, Although you can'
                ' also upload screenshots for HINDLISH AI to analayze it and get more rizz responses ',
                style: TextStyle(
                  fontSize: size.width * 0.04,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ));
  }
}
