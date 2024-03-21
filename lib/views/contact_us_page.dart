import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});
  void _launchEmail(String recipient) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: recipient,
      queryParameters: {'subject': 'Your Subject Here'},
    );

    if (await launchUrl(Uri.parse(emailLaunchUri.toString()))) {
      await launchUrl(Uri.parse(emailLaunchUri.toString()));
    } else {
      throw 'Could not launch $emailLaunchUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.blue)),
          onPressed: () async {
            const url = 'https://mail.google.com/mail/u/0/#inbox?compose=new';

            if (await canLaunch(url)) {
              await launch(url);
            } else {
              if (kDebugMode) {
                print('Could not launch url');
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'Contact Via Email',
              style:
                  TextStyle(color: Colors.white, fontSize: size.width * 0.05),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Welcome to Our Chat Bot App!. If you have any'
              ' question or feedback, feel free to contact us at : ',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: size.width * 0.045,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'email@example.com',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: size.width * 0.05,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
