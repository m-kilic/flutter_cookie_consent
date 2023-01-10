import 'package:cookie_consent/cookie_consent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Cookie Consent Demo',
      home: Scaffold(body: DemoPage()),
    );
  }
}

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final buttonPadding =
        EdgeInsets.symmetric(horizontal: size.width / 5.0, vertical: 10.0);
    return ListView(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Text('Cookie Consent Demo',
                style: Theme.of(context).textTheme.headline3),
          ),
        ),
        Padding(
          padding: buttonPadding,
          child: CupertinoButton.filled(
            onPressed: () => showCookieConsent(
              context,
              layout: CookieConsentLayout.cupertinoAlert,
              cookiePolicyUrl: Uri.parse('https://example.com/cookies'),
            ),
            child: const Text('Cupertino alert'),
          ),
        ),
        Padding(
          padding: buttonPadding,
          child: CupertinoButton.filled(
            onPressed: () => showCookieConsent(
              context,
              layout: CookieConsentLayout.cupertinoBottomSheet,
              cookiePolicyUrl: Uri.parse('https://example.com/cookies'),
            ),
            child: const Text('Cupertino bottom sheet'),
          ),
        ),
        Padding(
          padding: buttonPadding,
          child: CupertinoButton.filled(
            onPressed: () => showCookieConsent(
              context,
              cookiePolicyUrl: Uri.parse('https://example.com/cookies'),
            ),
            child: const Text('Floating bottom sheet'),
          ),
        ),
        Padding(
          padding: buttonPadding,
          child: CupertinoButton.filled(
            onPressed: () => showCookieConsent(
              context,
              layout: CookieConsentLayout.materialAlert,
              cookiePolicyUrl: Uri.parse('https://example.com/cookies'),
            ),
            child: const Text('Material alert'),
          ),
        ),
        Padding(
          padding: buttonPadding,
          child: CupertinoButton.filled(
            onPressed: () => showCookieConsent(
              context,
              layout: CookieConsentLayout.materialBottomSheet,
              cookiePolicyUrl: Uri.parse('https://example.com/cookies'),
            ),
            child: const Text('Material bottom sheet'),
          ),
        ),
        Padding(
          padding: buttonPadding,
          child: CupertinoButton.filled(
            onPressed: () => showCookieConsent(
              context,
              layout: CookieConsentLayout.materialSnackBar,
              cookiePolicyUrl: Uri.parse('https://example.com/cookies'),
            ),
            child: const Text('Material snack bar'),
          ),
        ),
      ],
    );
  }
}
