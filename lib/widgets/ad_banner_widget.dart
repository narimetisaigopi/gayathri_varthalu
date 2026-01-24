import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdBannerWidget extends StatefulWidget {
  final String? adUnitId;

  const AdBannerWidget({this.adUnitId, super.key});

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  String? _errorMessage;
  bool _isAdInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only load ad once
    if (!_isAdInitialized) {
      _isAdInitialized = true;
      _loadAd();
    }
  }

  Future<void> _loadAd() async {
    // Production Ad Unit ID
    const prodAdUnitId = 'ca-app-pub-2214578587937661/7583308365';
    // Test Ad Unit ID (fallback while production ad unit activates)
    const testAdUnitId = 'ca-app-pub-3940256099942544/9214589741';

    // Use test ads temporarily until production ad unit is active in AdMob
    // Change back to prodAdUnitId once your ad unit is approved and active
    final adUnitId = widget.adUnitId ?? testAdUnitId;

    // Get the screen width to create an adaptive banner
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      print('❌ Unable to get adaptive banner size');
      return;
    }

    print('\n========================================');
    print('🎯 GOOGLE ADS: Creating Adaptive Banner Ad');
    print('📅 Timestamp: ${DateTime.now()}');
    print('🆔 Ad Unit ID: $adUnitId');
    print('📏 Ad Size: ${size.width}x${size.height} (Adaptive)');
    print(
        '⚠️  Using TEST ads - Switch to prodAdUnitId once your ad unit is active');
    print('========================================\n');

    try {
      _bannerAd = BannerAd(
        adUnitId: adUnitId,
        size: size,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            print('\n✅✅✅ SUCCESS: Banner Ad Loaded ✅✅✅');
            print('Ad Unit ID: ${ad.adUnitId}');
            print(
                'Ad Size: ${(ad as BannerAd).size.width}x${(ad).size.height}');
            print('Timestamp: ${DateTime.now()}');
            print('========================================\n');
            if (mounted) {
              setState(() => _isLoaded = true);
            }
          },
          onAdFailedToLoad: (ad, error) {
            print('\n❌❌❌ ERROR: Banner Ad Failed to Load ❌❌❌');
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
            if (mounted) {
              setState(() {
                _errorMessage = 'Code ${error.code}: ${error.message}';
              });
            }
            ad.dispose();
          },
          onAdOpened: (ad) {
            print('📖 Banner Ad Opened - User clicked the ad');
          },
          onAdClosed: (ad) {
            print('🚪 Banner Ad Closed');
          },
          onAdImpression: (ad) {
            print('👁 Banner Ad Impression Recorded');
          },
          onAdWillDismissScreen: (ad) {
            print('⚠️ Ad will dismiss screen');
          },
          onPaidEvent: (ad, valueMicros, precision, currencyCode) {
            print(
                '💰 Paid Event: $valueMicros micros, Currency: $currencyCode');
          },
        ),
      );

      print('🔄 Loading Adaptive Banner Ad...');
      _bannerAd!.load();
      print('📤 Ad load() called successfully\n');
    } catch (e, stackTrace) {
      print('\n💥💥💥 EXCEPTION while creating Adaptive Banner Ad 💥💥💥');
      print('Exception: $e');
      print('Stack Trace: $stackTrace');
      print('========================================\n');
    }
  }

  @override
  void dispose() {
    print('🗑 Disposing Banner Ad widget');
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(
        '🎨 Building AdBannerWidget - isLoaded: $_isLoaded, hasError: ${_errorMessage != null}');

    if (_errorMessage != null) {
      return Container(
        height: 60,
        margin: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.red[100],
          border: Border.all(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 20),
            const SizedBox(height: 4),
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 10),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    }

    if (!_isLoaded) {
      print('⏳ Ad still loading, showing progress indicator');
      return Container(
        height: 50,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 8),
            Text('Loading Ad...',
                style: TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      );
    }

    print('✅ Ad loaded successfully, displaying AdWidget');
    return Container(
      color: Colors.white,
      width: double.infinity,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}
