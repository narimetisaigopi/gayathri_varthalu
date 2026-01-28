import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gayathri_varthalu/bottom_nav_bloc.dart';
import 'package:gayathri_varthalu/contact_us/contact_us_screen.dart';
import 'package:gayathri_varthalu/enewspaper/enewspaper_screen.dart';
import 'package:gayathri_varthalu/latest_news/latest_news_screen.dart';
import 'package:gayathri_varthalu/services/token_service.dart';
import 'package:gayathri_varthalu/services/url_bloc.dart';
import 'package:gayathri_varthalu/short_news/short_news_screen.dart';
import 'package:gayathri_varthalu/tv_feature/tv_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const List<_SocialApp> _apps = [
    _SocialApp('Snapchat', Icons.snapchat,
        'https://www.snapchat.com/add/yourusername'),
    _SocialApp('Instagram', Icons.camera_alt_outlined,
        'https://instagram.com/yourusername'),
    _SocialApp('Facebook', Icons.facebook_outlined,
        'https://facebook.com/yourusername'),
    _SocialApp('YouTube', Icons.ondemand_video,
        'https://www.youtube.com/@gayathrivarthalu'),
    _SocialApp(
        'Contact Us', Icons.contact_mail, 'mailto:contact@yourdomain.com'),
    _SocialApp('Message', Icons.message, ''),
  ];

  bool _isRequestingPermission = false;
  bool _hasShownPopup = false;

  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
    _fetchAndLogFcmToken();
    _setupForegroundMessageListener();
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _requestNotificationPermission() async {
    if (_isRequestingPermission) return;
    _isRequestingPermission = true;
    try {
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // User allowed notifications, register token
        await TokenService.registerToken();
      }
    } finally {
      _isRequestingPermission = false;
    }
  }

  Future<void> _fetchAndLogFcmToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      debugPrint('FCM Token: ${token ?? 'No token'}');
      // You can send this token to your backend if needed
    } catch (e) {
      debugPrint('Error fetching FCM token: $e');
    }
  }

  void _setupForegroundMessageListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        final title = message.notification!.title ?? '';
        final body = message.notification!.body ?? '';
        // Show a simple dialog/snackbar for demonstration
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Notification: $title\n$body'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    });
  }

  bool _showNavBar = true;

  void _showPopupImage(BuildContext context, String imageUrl) {
    if (_hasShownPopup) return;
    _hasShownPopup = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.9),
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(20),
            child: Stack(
              children: [
                // Full screen image with margin
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 4.0,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              color: Colors.white,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.error_outline,
                              color: Colors.white,
                              size: 50,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                // Close button
                Positioned(
                  top: 40,
                  right: 20,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final bottomNavBloc = context.read<BottomNavBloc>();
        final selectedIndex = bottomNavBloc.state.selectedIndex;
        if (selectedIndex != 0) {
          bottomNavBloc.add(TabChanged(0));
          return false;
        }
        return true;
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            _showNavBar = !_showNavBar;
          });
        },
        child: BlocBuilder<UrlBloc, UrlState>(
          builder: (context, urlState) {
            final webUrl = (urlState is UrlLoaded) ? urlState.webUrl : null;
            final epaperUrl =
                (urlState is UrlLoaded) ? urlState.ePaperUrl : null;
            final popImage = (urlState is UrlLoaded) ? urlState.popImage : null;

            // Show popup if epaperUrl has value and popImage exists
            if (urlState is UrlLoaded &&
                epaperUrl != null &&
                epaperUrl.isNotEmpty &&
                popImage != null &&
                popImage.isNotEmpty &&
                popImage != "0") {
              _showPopupImage(context, popImage);
            }

            return BlocBuilder<BottomNavBloc, BottomNavState>(
              builder: (context, state) {
                Widget body;
                bool showNavBar = true;
                final liveUrl = (urlState is UrlLoaded) ? urlState.liveUrl : '';
                switch (state.selectedIndex) {
                  case 0:
                    body = ShortNewsScreen();
                    break;
                  case 1:
                    body = TVScreen(liveUrl: liveUrl, visible: true);
                    showNavBar = false;
                    break;
                  case 2:
                    body = LatestNewsScreen(webUrl: webUrl);
                    break;
                  case 3:
                    body = ENewsPaperScreen(epaperUrl: epaperUrl);
                    break;
                  case 4:
                    body = ContactUsScreen();
                    break;
                  default:
                    body = ShortNewsScreen();
                }
                return Scaffold(
                  body: SafeArea(
                    top: true,
                    bottom: true,
                    child: body,
                  ),
                  bottomNavigationBar: showNavBar
                      ? SafeArea(
                          bottom: true,
                          child: CustomBottomNavBar(
                            selectedIndex: state.selectedIndex,
                            onItemTapped: (index) {
                              context
                                  .read<BottomNavBloc>()
                                  .add(TabChanged(index));
                            },
                          ),
                        )
                      : null,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(16)), // Add top border radius
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NavBarItem(
            icon: Icons.article,
            label: 'Short News',
            selected: selectedIndex == 0,
            onTap: () => onItemTapped(0),
          ),
          _NavBarItem(
            icon: Icons.tv,
            label: 'Live TV',
            selected: selectedIndex == 1,
            onTap: () => onItemTapped(1),
          ),
          _NavBarItem(
            icon: Icons.fiber_new,
            label: 'Latest News',
            selected: selectedIndex == 2,
            onTap: () => onItemTapped(2),
          ),
          _NavBarItem(
            icon: Icons.newspaper,
            label: 'E-paper',
            selected: selectedIndex == 3,
            onTap: () => onItemTapped(3),
          ),
          _NavBarItem(
            icon: Icons.contact_mail,
            label: 'Contact',
            selected: selectedIndex == 4,
            onTap: () => onItemTapped(4),
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? Theme.of(context).primaryColor : Colors.grey;
    return Flexible(
      fit: FlexFit.tight,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                fontSize: 11,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialApp {
  final String name;
  final IconData icon;
  final String url;

  const _SocialApp(this.name, this.icon, this.url);
}
