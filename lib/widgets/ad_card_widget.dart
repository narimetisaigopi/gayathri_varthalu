import 'package:flutter/material.dart';
import 'package:gayathri_varthalu/theme.dart';
import 'package:gayathri_varthalu/widgets/cached_image_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class AdCardWidget extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final String? description;
  final String? ctaText;
  final String? ctaUrl;
  final int? index;

  const AdCardWidget({
    super.key,
    this.imageUrl,
    this.title,
    this.description,
    this.ctaText = 'Learn More',
    this.ctaUrl,
    this.index,
  });

  Future<void> _launchUrl(BuildContext context) async {
    if (ctaUrl == null || ctaUrl!.isEmpty) return;
    final uri = Uri.parse(ctaUrl!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open link.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double cardHeight = MediaQuery.of(context).size.height * 0.9;
    return Card(
      elevation: 4,
      child: Stack(
        children: [
          SizedBox(
            height: cardHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (imageUrl != null && imageUrl!.isNotEmpty)
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: CachedImageWidget(
                      imageUrl: imageUrl!,
                      fit: BoxFit.fill,
                      height: cardHeight * 0.7,
                      width: double.infinity,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                  ),
                if (title != null && title!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      title!,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (description != null && description!.isNotEmpty)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: SingleChildScrollView(
                        child: Text(
                          description!,
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  height: 72,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 140,
                    height: 62, // Set a fixed width for the button
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _launchUrl(context),
                      child: Text(ctaText ?? 'Learn More'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (index != null)
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Advertisement',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
