import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  static Future sendAnalyticsEvent({required String eventName, String? clickevent, Map? moreInfo}) async {
    await analytics.logEvent(
      name: eventName,
      parameters: <String, dynamic>{'clickEvent': clickevent, 'info': moreInfo},
    );
  }
}
