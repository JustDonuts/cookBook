import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}


class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return ContentArea(builder: ((context, scrollController) {
      return SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(50.0),
              child: Text(
                'About',
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(60, 0, 60, 0),
              child: Column(
                children: const [
                  Text(
                    'A very simple MacOS Flutter app to save your favourite recipes. \n \n Main features: \n • Save the recipes locally \n • Automatically assign a cover photo to your recipes by scraping Yahoo! \n • Adjust the ingredients quantities according to the portions \n • Store links to recipes you want to check out \n • Searchbar \n\n I am always looking for ways to improve the app, so if you have any ideas, feel free to open an issue on the repo!',
                    style: TextStyle(color: Colors.white30),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text('Check me out on GitHub!', style: TextStyle(color: Colors.white30)),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: GestureDetector(
                onTap: () {
                  _launchUrl();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 50,
                        child:
                            Image.asset('assets/images/github-mark-white.png')),
                    const Text('  JustDonuts')
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }));
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(Uri.parse('https://github.com/JustDonuts'))) {
      throw Exception('Could not launch url');
    }
  }
}
