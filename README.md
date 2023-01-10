Display a cookie consent banner in your Flutter app or website.

## Features
- Show consent banner in a few different styles
- Let user customize their accepted categories

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

The minimum required input is a BuildContext and a cookie policy url:
```dart
showCookieConsent(
  context,
  cookiePolicyUrl: Uri.parse('https://example.com/cookies'),
);
```

There are several layouts to choose from
| CookieConsentLayout |
| --- |
| cupertinoBottomSheet |
| cupertinoAlert |
| floatingBottomSheet |
| cupertinoAlert |
| materialAlert |
| materialBottomSheet |
| materialSnackBar |

```dart
showCookieConsent(
  context,
  layout: CookieConsentLayout.materialSnackBar,
  cookiePolicyUrl: Uri.parse('https://example.com/cookies'),
);
```

We recommend that you provide your own consent text and categories,
tailored to your app:

```dart
showCookieConsent(
  context,
  cookiePolicyUrl: Uri.parse('https://example.com/cookies'),
  consent: 'By clicking [acceptallcookies], you agree that we can store cookies '
    'on your device and disclose information in accordance with our [cookiepolicy].',
  categories: [
    CookeConsentCategory(
      id: 'necessary',
      name: 'Strictly Necessary Cookies',
      description:
          'Necessary cookies are required to enable the basic features of this site, '
          'such as providing secure log-in or adjusting your consent preferences. '
          'These cookies do not store any personally identifiable data.',
    ),
    CookeConsentCategory(
      id: 'advertising',
      name: 'Advertising Cookies',
      description:
          'Advertising cookies are used to provide visitors with customized '
          'advertisements based on the pages you visited previously and to analyze '
          'the effectiveness of the ad campaigns.',
    ),
  ],
);
```

See `example/` for a working app with demos of all layouts
