import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

import 'package:gayathri_varthalu/bottom_nav_bloc.dart';

class TVScreen extends StatefulWidget {
  final String liveUrl;
  final bool visible;

  const TVScreen({
    super.key,
    required this.liveUrl,
    this.visible = false,
  });

  @override
  State<TVScreen> createState() => _TVScreenState();
}

class _TVScreenState extends State<TVScreen> {
  @override
  void initState() {
    super.initState();
    _handleOrientation();
  }

  @override
  void didUpdateWidget(covariant TVScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _handleOrientation();
  }

  void _handleOrientation() {
    if (widget.visible) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      // Hide system UI and make it black
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  @override
  void dispose() {
    // Restore portrait orientation and system UI when leaving TVScreen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          // Navigate to ShortNewsScreen after successful pop
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              context.read<BottomNavBloc>().add(const TabChanged(0));
            }
          });
        }
      },
      child: Container(
        color: Colors.black,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: widget.liveUrl.isEmpty
              ? const Center(child: SizedBox.shrink())
              : Stack(
                  children: [
                    InAppWebView(
                      initialSettings: InAppWebViewSettings(
                        transparentBackground: false,
                        supportZoom: false,
                        disableHorizontalScroll: true,
                        disableVerticalScroll: true,
                      ),
                      initialUrlRequest:
                          URLRequest(url: WebUri(widget.liveUrl)),
                      onLoadStart: (controller, url) async {
                        await controller.evaluateJavascript(
                          source:
                              "document.body.style.backgroundColor = 'black'; document.documentElement.style.backgroundColor = 'black'; document.body.style.margin = '0'; document.body.style.padding = '0';",
                        );
                      },
                      onLoadStop: (controller, url) async {
                        await controller.evaluateJavascript(
                          source:
                              "document.body.style.backgroundColor = 'black'; document.documentElement.style.backgroundColor = 'black'; document.body.style.margin = '0'; document.body.style.padding = '0';",
                        );
                      },
                    ),
                    // Back button for both iOS and Android
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 10,
                      left: 10,
                      child: SafeArea(
                        child: Material(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              context
                                  .read<BottomNavBloc>()
                                  .add(const TabChanged(0));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
