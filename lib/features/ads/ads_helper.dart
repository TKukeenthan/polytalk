import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsHelper {
  static Future<InitializationStatus> initialize() {
    return MobileAds.instance.initialize();
  }
}
