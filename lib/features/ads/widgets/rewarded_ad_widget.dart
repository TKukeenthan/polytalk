import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdWidget {
  static RewardedAd? _rewardedAd;

  static void load({required String adUnitId, required VoidCallback onRewarded, required VoidCallback onAdClosed}) {
    RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _rewardedAd?.show(
            onUserEarnedReward: (ad, reward) {
              onRewarded();
            },
          );
          _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
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
