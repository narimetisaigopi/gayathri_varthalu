import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gayathri_varthalu/app_router.dart';
import 'package:gayathri_varthalu/theme.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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

    // Configure for non-personalized ads only (ATT tracking disabled)
    final configuration = RequestConfiguration(
      testDeviceIds: [], // Add your test device IDs here if testing
      maxAdContentRating: MaxAdContentRating.g,
      // Note: Without ATT permission, AdMob automatically serves non-personalized ads
    );
    MobileAds.instance.updateRequestConfiguration(configuration);
    print('✅ Ad Request Configuration updated');
    print('   Max Ad Content Rating: G');
    print('   ℹ️  Non-personalized ads only (no tracking)');

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
  // ATT permission removed - app will show non-personalized ads only

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
