import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cookie_consent/cookie_consent.dart';

void main() {
  testWidgets('showDefaultConsentDialog', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Material(child: Container())));
    final BuildContext context = tester.element(find.byType(Container));
    showCookieConsent(
      context,
      cookiePolicyUrl: Uri.parse('https://example.com/cookies'),
    );
  });

  testWidgets('showCupertinoAlertConsentDialog', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Material(child: Container())));
    final BuildContext context = tester.element(find.byType(Container));
    showCookieConsent(
      context,
      layout: CookieConsentLayout.cupertinoAlert,
      cookiePolicyUrl: Uri.parse('https://example.com/cookies'),
    );
  });

  testWidgets('showCupertinoBottomSheetConsentDialog',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Material(child: Container())));
    final BuildContext context = tester.element(find.byType(Container));
    showCookieConsent(
      context,
      layout: CookieConsentLayout.cupertinoBottomSheet,
      cookiePolicyUrl: Uri.parse('https://example.com/cookies'),
    );
  });

  testWidgets('showFloatingBottomSheetConsentDialog',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Material(child: Container())));
    final BuildContext context = tester.element(find.byType(Container));
    showCookieConsent(
      context,
      layout: CookieConsentLayout.floatingBottomSheet,
      cookiePolicyUrl: Uri.parse('https://example.com/cookies'),
    );
  });

  testWidgets('showMaterialAlertConsentDialog', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Material(child: Container())));
    final BuildContext context = tester.element(find.byType(Container));
    showCookieConsent(
      context,
      layout: CookieConsentLayout.materialAlert,
      cookiePolicyUrl: Uri.parse('https://example.com/cookies'),
    );
  });

  testWidgets('showMaterialBottomSheetConsentDialog',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Material(child: Container())));
    final BuildContext context = tester.element(find.byType(Container));
    showCookieConsent(
      context,
      layout: CookieConsentLayout.materialBottomSheet,
      cookiePolicyUrl: Uri.parse('https://example.com/cookies'),
    );
  });
}
