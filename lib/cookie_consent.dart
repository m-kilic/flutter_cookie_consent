library cookie_consent;

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'button.dart';
import 'examples.dart';
import 'floating_modal.dart';

enum CookieConsentLayout {
  cupertinoBottomSheet,
  cupertinoAlert,
  floatingBottomSheet,
  materialAlert,
  materialBottomSheet,
  materialSnackBar,
}

class CookeConsentCategory {
  CookeConsentCategory({
    required this.id,
    required this.name,
    required this.description,
  });
  final String id;
  final String name;
  final String description;
}

const defaultCookieConsentSharedPrefrencesPrefix = 'cookie_consent';

Future<bool> getCookieConsent({
  required String category,
  required String sharedPrefrencesPrefix,
}) async {
  return (await _getCookieConsent(
          category: category,
          sharedPrefrencesPrefix: sharedPrefrencesPrefix)) ??
      false;
}

Future<bool?> _getCookieConsent({
  required String category,
  required String sharedPrefrencesPrefix,
}) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('$sharedPrefrencesPrefix:$category');
}

Future<void> setCookieConsent({
  required String category,
  required String sharedPrefrencesPrefix,
  required bool value,
}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('$sharedPrefrencesPrefix:$category', value);
}

Future<void> removeCookieConsent({
  required String category,
  required String sharedPrefrencesPrefix,
}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('$sharedPrefrencesPrefix:$category');
}

showCookieConsent(
  BuildContext context, {

  /// Pick a layot for your dialog
  CookieConsentLayout layout = CookieConsentLayout.floatingBottomSheet,

  /// shared_prefrences is used to store the user's intent,
  /// by combining this prefix and the category id
  String sharedPrefrencesPrefix = defaultCookieConsentSharedPrefrencesPrefix,

  /// Main dialog title
  String title = 'Your privacy',

  /// Main dialog consent text to display. You can use placeholders
  /// [acceptallcookies] which inserts acceptAllLabel in bold and [cookiepolicy]
  /// which inserts cookiePolicyLabel which is clickable and opens cookiePolicyUrl
  /// in a web browser.
  String consent =
      'By clicking [acceptallcookies], you agree that we can store cookies '
          'on your device and disclose information in accordance with our [cookiepolicy].',

  /// Provide an url to your app's or website's cookie policy document
  required Uri cookiePolicyUrl,
  String cookiePolicyLabel = 'Cookie Policy',

  /// Let user select only necessary cookies
  bool showAcceptNecessary = true,
  String acceptNecessaryLabel = 'Only necessary cookies',
  String acceptNecessaryCategoryId = 'necessary',

  /// Let user accept all cookies
  bool showAcceptAll = true,
  String acceptAllLabel = 'Accept all cookies',

  /// Let user customize their consent choices
  bool showCustomize = true,
  bool? showCustomizeLabel,
  bool? showCustomizeIcon,
  String customizeLabel = 'Customize settings',
  String customizeHeadline = 'Customize your choices',
  IconData customizeIcon = Icons.settings,

  /// Show reject all button
  bool showRejectAll = false,
  String rejectAllLabel = 'Reject all cookies',
  String customizeSaveLabel = 'Confirm my choices',

  /// Categories the user can opt in to. Preferably provide your own
  /// list rather than using the default example, and tailor the descriptions
  /// specifically to your app or website.
  List<CookeConsentCategory>? categories,

  /// Whether the user can dismiss the sheet by clicking outside of it.
  bool dismissible = true,
}) {
  categories ??= exampleCookieConsentCategories;

  showCustomizeIcon ??= ![CookieConsentLayout.cupertinoAlert].contains(layout);
  showCustomizeLabel ??= [
    CookieConsentLayout.cupertinoBottomSheet,
    CookieConsentLayout.cupertinoAlert
  ].contains(layout);

  cookieConsentBody(
    BuildContext context,
    CookieConsentLayout layout, {
    bool showTitle = false,
    bool useCupertinoButtons = false,
    bool useVerticalButtons = false,
    Function? onPop,
  }) {
    onPop ??= () => Navigator.of(context).pop();
    final buttons = [
      if (showAcceptAll)
        CookieConsentButton(
          useCupertino: useCupertinoButtons,
          isPrimary: true,
          onPressed: () async {
            onPop?.call();
            for (CookeConsentCategory category in categories ?? []) {
              await setCookieConsent(
                  category: category.id,
                  sharedPrefrencesPrefix: sharedPrefrencesPrefix,
                  value: true);
            }
          },
          label: acceptAllLabel,
        ),
      if (showAcceptNecessary)
        CookieConsentButton(
          useCupertino: useCupertinoButtons,
          isPrimary: !showAcceptAll,
          onPressed: () async {
            onPop?.call();
            await setCookieConsent(
                category: acceptNecessaryCategoryId,
                sharedPrefrencesPrefix: sharedPrefrencesPrefix,
                value: true);
          },
          label: acceptNecessaryLabel,
        ),
      if (showRejectAll)
        CookieConsentButton(
          useCupertino: useCupertinoButtons,
          onPressed: () async {
            onPop?.call();
            for (CookeConsentCategory category in categories ?? []) {
              await removeCookieConsent(
                  category: category.id,
                  sharedPrefrencesPrefix: sharedPrefrencesPrefix);
            }
          },
          label: rejectAllLabel,
        ),
      if (showCustomize && (showCustomizeIcon! || showCustomizeLabel!))
        CookieConsentButton(
          useCupertino: useCupertinoButtons,
          icon: showCustomizeIcon ? customizeIcon : null,
          onPressed: () {
            onPop?.call();
            showCustomizeCookieConsentDialog(
              context,
              layout: layout,
              categories: categories!,
              dismissible: dismissible,
              acceptNecessaryCategoryId: acceptNecessaryCategoryId,
              sharedPrefrencesPrefix: sharedPrefrencesPrefix,
              acceptAllLabel: acceptAllLabel,
              showAcceptAll: showAcceptAll,
              customizeSaveLabel: customizeSaveLabel,
              customizeHeadline: customizeHeadline,
            );
          },
          label: showCustomizeLabel! ? customizeLabel : null,
        ),
    ];

    List<TextSpan> consentSpans = [];

    final patterns = [
      '[acceptallcookies]',
      '[cookiepolicy]',
    ];

    int lastMatch = 0;
    for (int i = 0; i < consent.length - 1; i++) {
      if (i < lastMatch) continue;
      for (final pattern in patterns) {
        if (consent.substring(i).startsWith(pattern)) {
          consentSpans.add(TextSpan(text: consent.substring(lastMatch, i)));
          lastMatch = i + pattern.length;
          switch (pattern) {
            case '[acceptallcookies]':
              consentSpans.add(
                TextSpan(
                    text: acceptAllLabel,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              );
              break;
            case '[cookiepolicy]':
              consentSpans.add(TextSpan(
                text: cookiePolicyLabel,
                style: const TextStyle(fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => launchUrl(cookiePolicyUrl),
              ));
              break;
          }
        }
      }
    }
    if (lastMatch < consent.length) {
      consentSpans.add(TextSpan(text: consent.substring(lastMatch)));
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showTitle)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          const SizedBox(height: 12.0),
          RichText(
              text: TextSpan(
                  style: TextStyle(
                    // color: Colors.white,
                    color: layout == CookieConsentLayout.materialSnackBar
                        ? Colors.white
                        : Colors.black,
                    // fontStyle: FontStyle.italic,
                  ),
                  children: consentSpans)),
          const SizedBox(height: 12.0),
          useVerticalButtons
              ? Column(
                  children: buttons,
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: buttons,
                ),
        ]);
  }

  switch (layout) {
    case CookieConsentLayout.cupertinoBottomSheet:
      showBarModalBottomSheet(
        context: context,
        builder: (_) => Padding(
          padding: const EdgeInsets.all(20.0),
          child: cookieConsentBody(context, layout,
              showTitle: true, useCupertinoButtons: true),
        ),
        expand: false,
      );
      break;
    case CookieConsentLayout.cupertinoAlert:
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title),
          content: cookieConsentBody(context, layout,
              showTitle: false,
              useCupertinoButtons: true,
              useVerticalButtons: true),
        ),
        barrierDismissible: dismissible,
      );
      break;
    case CookieConsentLayout.floatingBottomSheet:
      showCustomModalBottomSheet(
        context: context,
        builder: (context) => Padding(
          padding: const EdgeInsets.all(20.0),
          child: cookieConsentBody(context, layout, showTitle: true),
        ),
        containerWidget: (_, animation, child) => FloatingModal(
          child: child,
        ),
        expand: false,
      );
      break;
    case CookieConsentLayout.materialAlert:
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text(title),
                content: cookieConsentBody(context, layout, showTitle: false),
              ));
      break;
    case CookieConsentLayout.materialBottomSheet:
      showMaterialModalBottomSheet(
        context: context,
        builder: (_) => Padding(
          padding: const EdgeInsets.all(20.0),
          child: cookieConsentBody(context, layout, showTitle: true),
        ),
        expand: false,
      );
      break;
    case CookieConsentLayout.materialSnackBar:
      final snackBar = SnackBar(
        content: cookieConsentBody(context, layout,
            showTitle: true,
            onPop: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
        duration: const Duration(seconds: 9999999),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      break;
  }
}

showCustomizeCookieConsentDialog(
  BuildContext context, {

  /// Pick a layot for your dialog
  required CookieConsentLayout layout,

  /// Categories the user can opt in to. Preferably provide your own
  /// list rather than using the default example, and tailor the descriptions
  /// specifically to your app or website.
  required List<CookeConsentCategory> categories,

  /// Whether the user can dismiss the sheet by clicking outside of it.
  required bool dismissible,

  /// This one cannot be toggled
  required String acceptNecessaryCategoryId,
  required String sharedPrefrencesPrefix,
  required String acceptAllLabel,
  required bool showAcceptAll,
  required String customizeSaveLabel,
  required String customizeHeadline,
}) {
  customizeConsentBody(
    BuildContext context, {
    bool showTitle = false,
    bool useCupertinoButtons = false,
    bool useVerticalButtons = false,
  }) {
    int cnt = 0;
    return StatefulBuilder(
      builder: (context, setState) => FutureBuilder(
        future: Future.wait(
          categories.map(
            (category) async {
              return {
                category.id: await _getCookieConsent(
                    category: category.id,
                    sharedPrefrencesPrefix: sharedPrefrencesPrefix)
              };
            },
          ),
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CupertinoActivityIndicator(),
              ),
            );
          }
          final state = <String, bool?>{
            for (Map<String, bool?> part in snapshot.data!) ...part,
          };
          return Material(
            color: Colors.transparent,
            child: SizedBox(
              width: 320,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(4),
                      1: FixedColumnWidth(66),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: categories
                        .map((category) => TableRow(
                              children: [
                                ExpansionTile(
                                  title: Text(category.name),
                                  trailing: const Icon(
                                      CupertinoIcons.question_circle_fill,
                                      size: 18.0),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Text(category.description),
                                    ),
                                  ],
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CupertinoSwitch(
                                          value: category.id ==
                                                  acceptNecessaryCategoryId
                                              ? true
                                              : state[category.id] ?? false,
                                          onChanged: category.id ==
                                                  acceptNecessaryCategoryId
                                              ? null
                                              : (value) {
                                                  setCookieConsent(
                                                      category: category.id,
                                                      sharedPrefrencesPrefix:
                                                          sharedPrefrencesPrefix,
                                                      value: value);
                                                  setState(() => cnt++);
                                                })
                                    ]),
                              ],
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CookieConsentButton(
                        label: customizeSaveLabel,
                        isPrimary: true,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      if (showAcceptAll)
                        CookieConsentButton(
                          label: acceptAllLabel,
                          onPressed: () async {
                            Navigator.of(context).pop();
                            for (final category in categories) {
                              await setCookieConsent(
                                  category: category.id,
                                  sharedPrefrencesPrefix:
                                      sharedPrefrencesPrefix,
                                  value: true);
                            }
                          },
                        )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  switch (layout) {
    case CookieConsentLayout.cupertinoBottomSheet:
    case CookieConsentLayout.cupertinoAlert:
    case CookieConsentLayout.floatingBottomSheet:
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(customizeHeadline),
          content: customizeConsentBody(context,
              showTitle: false,
              useCupertinoButtons: true,
              useVerticalButtons: true),
        ),
        barrierDismissible: dismissible,
      );
      break;

    case CookieConsentLayout.materialAlert:
    case CookieConsentLayout.materialBottomSheet:
    case CookieConsentLayout.materialSnackBar:
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text(customizeHeadline),
                content: customizeConsentBody(context, showTitle: false),
              ));
      break;
  }
}
