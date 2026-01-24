import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImageWidget extends StatefulWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const CachedImageWidget({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  State<CachedImageWidget> createState() => _CachedImageWidgetState();
}

class _CachedImageWidgetState extends State<CachedImageWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(
      CachedNetworkImageProvider(widget.imageUrl),
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: widget.imageUrl,
        fit: widget.fit,
        width: widget.width,
        height: widget.height,
        placeholder: (context, url) => SizedBox.shrink(),
        errorWidget: (context, url, error) =>
            const Icon(Icons.broken_image_rounded, size: 40),
      ),
    );
  }
}
