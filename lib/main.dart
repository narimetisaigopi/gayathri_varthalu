import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gayathri_varthalu/app_router.dart';
import 'package:gayathri_varthalu/theme.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gayathri_varthalu/bottom_nav_bloc.dart';
import 'package:gayathri_varthalu/services/url_bloc.dart';
import 'package:gayathri_varthalu/services/ad_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('\n========================================');
  print('🚀 APP INITIALIZATION STARTING');
  print('📅 Time: ${DateTime.now()}');
  print('========================================\n');

  try {
    await Firebase.initializeApp();
    print('✅ Firebase initialized successfully\n');
  } catch (e) {
    print('❌ Firebase initialization failed: $e\n');
  }

  print('🎯 Initializing Google Mobile Ads...');
  try {
    final initializationStatus = await MobileAds.instance.initialize();
    print('✅ Google Mobile Ads SDK initialized');
    print('📊 Adapter Statuses:');
    initializationStatus.adapterStatuses.forEach((key, value) {
      print('  - $key: ${value.description} (State: ${value.state})');
    });

    // Get SDK version
    print(
        '📦 Mobile Ads SDK Version: ${await MobileAds.instance.getVersionString()}');

    // Optional: Set request configuration for testing
    final configuration = RequestConfiguration(
      testDeviceIds: [], // Add your test device IDs here if testing
      maxAdContentRating: MaxAdContentRating.g,
    );
    MobileAds.instance.updateRequestConfiguration(configuration);
    print('✅ Ad Request Configuration updated');
    print('   Max Ad Content Rating: G');

    // Initialize Ad Service for interstitial ads
    AdService().initialize();
    print('✅ Ad Service initialized');
    print('========================================\n');
  } catch (e, stackTrace) {
    print('❌ Google Mobile Ads initialization failed!');
    print('Error: $e');
    print('Stack: $stackTrace');
    print('========================================\n');
  }

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    statusBarColor: Colors.transparent,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // Request ATT permission after the first frame is rendered
    // This ensures the app UI is visible when the dialog appears
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestAppTrackingTransparency();
    });
  }

  Future<void> _requestAppTrackingTransparency() async {
    print('\n========================================');
    print('🔐 Requesting App Tracking Transparency...');
    print('========================================\n');

    try {
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      print('📊 Current ATT Status: $status');

      if (status == TrackingStatus.notDetermined) {
        print('⏳ Showing ATT permission dialog...');
        // Small delay to ensure UI is fully rendered
        await Future.delayed(const Duration(milliseconds: 500));

        final newStatus =
            await AppTrackingTransparency.requestTrackingAuthorization();
        print('✅ ATT Permission requested. New status: $newStatus');
      } else {
        print('✅ ATT Status already determined: $status');
      }
    } catch (e) {
      print('⚠️  ATT request failed (likely Android or error): $e');
    }
    print('========================================\n');
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BottomNavBloc>(create: (_) => BottomNavBloc()),
        BlocProvider<UrlBloc>(create: (_) => UrlBloc()..add(FetchUrlsEvent())),
      ],
      child: MaterialApp.router(
        title: 'Gayathri Varthalu',
        theme: AppTheme.init(),
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
