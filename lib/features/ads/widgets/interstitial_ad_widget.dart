import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdWidget {
  static InterstitialAd? _interstitialAd;

  static void load({required String adUnitId, required VoidCallback onAdClosed}) {
    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialAd?.setImmersiveMode(true);
          _interstitialAd?.show();
          _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              onAdClosed();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              onAdClosed();
            },
          );
        },
        onAdFailedToLoad: (error) {
          onAdClosed();
        },
      ),
    );
  }
}
