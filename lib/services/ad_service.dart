import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;
  int _numInterstitialLoadAttempts = 0;
  static const int maxFailedLoadAttempts = 3;

  // Interstitial Ad Unit ID
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-2214578587937661/7634623335';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-2214578587937661/2255455525';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  // Banner Ad Unit ID
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-2214578587937661/7583308365';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-2214578587937661/2255455525';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  /// Initialize the AdService
  void initialize() {
    print('\n========================================');
    print('🎯 AD SERVICE: Initializing');
    print('📅 Timestamp: ${DateTime.now()}');
    print('========================================\n');

    loadInterstitialAd();
  }

  /// Load an interstitial ad
  void loadInterstitialAd() {
    print('\n========================================');
    print('🎯 INTERSTITIAL AD: Loading');
    print('📅 Timestamp: ${DateTime.now()}');
    print('🆔 Ad Unit ID: $interstitialAdUnitId');
    print('🔄 Load Attempt: ${_numInterstitialLoadAttempts + 1}');
    print('========================================\n');

    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          print('\n✅✅✅ SUCCESS: Interstitial Ad Loaded ✅✅✅');
          print('Ad Unit ID: ${ad.adUnitId}');
          print('Timestamp: ${DateTime.now()}');
          print('========================================\n');

          _interstitialAd = ad;
          _isInterstitialAdReady = true;
          _numInterstitialLoadAttempts = 0;

          _interstitialAd!.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              print('📺 Interstitial Ad showed full screen content');
            },
            onAdDismissedFullScreenContent: (ad) {
              print('🚪 Interstitial Ad dismissed full screen content');
              print('🔄 Loading next Interstitial Ad...');
              ad.dispose();
              _isInterstitialAdReady = false;
              loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('\n❌ ERROR: Interstitial Ad failed to show ❌');
              print('📛 Error Code: ${error.code}');
              print('📛 Error Message: ${error.message}');
              print('========================================\n');
              ad.dispose();
              _isInterstitialAdReady = false;
              loadInterstitialAd();
            },
            onAdImpression: (ad) {
              print('👁 Interstitial Ad impression recorded');
            },
            onAdClicked: (ad) {
              print('🖱 Interstitial Ad clicked');
            },
          );
        },
        onAdFailedToLoad: (error) {
          print('\n❌❌❌ ERROR: Interstitial Ad Failed to Load ❌❌❌');
          print('Timestamp: ${DateTime.now()}');
          print('📛 Error Code: ${error.code}');
          print('📛 Error Domain: ${error.domain}');
          print('📛 Error Message: ${error.message}');
          print('📛 Response Info: ${error.responseInfo}');
          print('\n🔍 Common Error Codes:');
          print('  0 = Internal error');
          print('  1 = Invalid request');
          print('  2 = Network error');
          print('  3 = No fill (no ads available)');
          print('========================================\n');

          _numInterstitialLoadAttempts += 1;
          _isInterstitialAdReady = false;

          if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
            print(
                '🔄 Retrying to load Interstitial Ad (${_numInterstitialLoadAttempts}/$maxFailedLoadAttempts)...\n');
            Future.delayed(const Duration(seconds: 5), () {
              loadInterstitialAd();
            });
          } else {
            print(
                '⚠️ Max load attempts reached. Will retry on next show attempt.\n');
          }
        },
      ),
    );
  }

  /// Show the interstitial ad
  Future<void> showInterstitialAd() async {
    print('\n========================================');
    print('🎬 INTERSTITIAL AD: Attempting to show');
    print('📅 Timestamp: ${DateTime.now()}');
    print('✅ Is Ready: $_isInterstitialAdReady');
    print('========================================\n');

    if (_isInterstitialAdReady && _interstitialAd != null) {
      print('🎯 Showing Interstitial Ad...');
      await _interstitialAd!.show();
      _interstitialAd = null;
    } else {
      print('⚠️ Interstitial Ad not ready yet. Loading new ad...');
      loadInterstitialAd();
    }
  }

  /// Check if interstitial ad is ready to show
  bool get isInterstitialAdReady => _isInterstitialAdReady;

  /// Dispose of the ad service
  void dispose() {
    print('🗑 Disposing Ad Service');
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isInterstitialAdReady = false;
  }
}
