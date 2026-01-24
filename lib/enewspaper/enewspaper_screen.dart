import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gayathri_varthalu/bottom_nav_bloc.dart';

class ENewsPaperScreen extends StatefulWidget {
  final String? epaperUrl;
  final bool visible;

  const ENewsPaperScreen({super.key, this.epaperUrl, this.visible = false});

  @override
  State<ENewsPaperScreen> createState() => _ENewsPaperScreenState();
}

class _ENewsPaperScreenState extends State<ENewsPaperScreen> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        context.read<BottomNavBloc>().add(const TabChanged(0));
      },
      child: SafeArea(
        child: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(
                    widget.epaperUrl ?? 'https://www.gayathrivarthalu.com/'),
              ),
              onLoadStart: (controller, url) {
                setState(() {
                  _isLoading = true;
                });
              },
              onLoadStop: (controller, url) {
                setState(() {
                  _isLoading = false;
                });
              },
            ),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
