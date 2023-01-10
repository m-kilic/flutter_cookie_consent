import 'cookie_consent.dart';

final cookieConsentCategoryExampleNecessary = CookeConsentCategory(
  id: 'necessary',
  name: 'Strictly Necessary Cookies',
  description:
      'Necessary cookies are required to enable the basic features of this site, '
      'such as providing secure log-in or adjusting your consent preferences. '
      'These cookies do not store any personally identifiable data.',
);

final cookieConsentCategoryExamplePerformance = CookeConsentCategory(
  id: 'performance',
  name: 'Performance Cookies',
  description:
      'Performance cookies are used to understand how visitors interact '
      'with the website. These cookies help provide information on metrics such '
      'as the number of visitors, bounce rate, traffic source, etc.',
);

final cookieConsentCategoryExampleFunctional = CookeConsentCategory(
  id: 'functional',
  name: 'Functional Cookies',
  description:
      'Functional cookies help perform certain functionalities like sharing '
      'the content of the website on social media platforms, collecting feedback, '
      'and other third-party features.',
);

final cookieConsentCategoryExampleAdvertising = CookeConsentCategory(
  id: 'advertising',
  name: 'Advertising Cookies',
  description:
      'Advertising cookies are used to provide visitors with customized '
      'advertisements based on the pages you visited previously and to analyze '
      'the effectiveness of the ad campaigns.',
);

final exampleCookieConsentCategories = [
  cookieConsentCategoryExampleNecessary,
  cookieConsentCategoryExamplePerformance,
  cookieConsentCategoryExampleFunctional,
  cookieConsentCategoryExampleAdvertising,
];
