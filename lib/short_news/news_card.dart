import 'package:flutter/material.dart';
import 'package:flutter_social_share_plugin/flutter_social_share.dart';
import 'package:gayathri_varthalu/constants/string_constants.dart';
import 'package:gayathri_varthalu/short_news/news_like_service.dart';
import 'package:gayathri_varthalu/theme.dart';
import 'package:gayathri_varthalu/utils/youtube_utils.dart';
import 'package:gayathri_varthalu/widgets/cached_image_widget.dart';
import 'package:url_launcher/url_launcher.dart';

enum Share {
  facebook,
  twitter,
  whatsapp,
  whatsapp_business,
  share_system,
  share_instagram,
  share_telegram,
  share_sms,
  share_mail,
}

class NewsCard extends StatefulWidget {
  final String? imageUrl;
  final String? videoUrl;
  final String? userImageUrl;
  final String title;
  final String userName;
  final String userTag;
  final String? description;
  final int likeCount;
  final int disLikeCount;
  final int viewCount;
  final VoidCallback onShare;
  final VoidCallback onLike;
  final String slno;
  final String newsDate;
  final String? newsDistrict;
  final String? category;
  final String? shareUrl;

  const NewsCard({
    super.key,
    this.imageUrl,
    this.videoUrl,
    required this.title,
    this.description,
    required this.likeCount,
    required this.disLikeCount,
    required this.viewCount,
    required this.onShare,
    required this.onLike,
    required this.slno,
    this.userImageUrl,
    required this.userName,
    required this.userTag,
    required this.newsDate,
    this.newsDistrict,
    this.category,
    this.shareUrl,
  });

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  bool isLoading = false;
  int likeCount = 0;
  int disLikeCount = 0;

  @override
  void initState() {
    super.initState();
    likeCount = widget.likeCount;
    disLikeCount = widget.disLikeCount;
  }

  Future<void> _toggleLike() async {
    setState(() {
      isLoading = true;
      likeCount++;
    });
    await NewsLikeService().sendLikeDislike(slno: widget.slno, option: 1);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _toggleDislike() async {
    setState(() {
      isLoading = true;
      disLikeCount++;
    });
    await NewsLikeService().sendLikeDislike(slno: widget.slno, option: 2);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double imageHeight = screenHeight * 0.35;
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)), // Match AdCardWidget radius
      elevation: 4,
      child: SizedBox(
        height: screenHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if ((widget.imageUrl != null && widget.imageUrl!.isNotEmpty) ||
                (widget.videoUrl != null && widget.videoUrl!.isNotEmpty))
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: CachedImageWidget(
                      imageUrl: (widget.imageUrl != null &&
                              widget.imageUrl!.isNotEmpty)
                          ? widget.imageUrl!
                          : YoutubeUtils.getYoutubeThumbnailSync(
                              widget.videoUrl!),
                      fit: BoxFit.fill,
                      height: imageHeight,
                      width: double.infinity,
                    ),
                  ),
                  if (widget.videoUrl != null && widget.videoUrl!.isNotEmpty)
                    GestureDetector(
                      onTap: () async {
                        final videoId =
                            YoutubeUtils.extractVideoId(widget.videoUrl!);
                        if (videoId != null) {
                          final url = YoutubeUtils.videoUrlFromId(videoId);
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url),
                                mode: LaunchMode.externalApplication);
                          }
                        }
                      },
                      child: const Icon(Icons.play_circle_fill,
                          size: 64, color: Colors.white),
                    ),
                ],
              ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: 60,
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                    decoration: const BoxDecoration(color: Colors.black),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              (widget.userImageUrl != null &&
                                      widget.userImageUrl!.isNotEmpty)
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(32.0),
                                      child: CachedImageWidget(
                                        imageUrl: widget.userImageUrl!,
                                        fit: BoxFit.fill,
                                        height: 40,
                                        width: 40,
                                      ),
                                    )
                                  : Container(
                                      width: 30,
                                      height: 30,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(32.0),
                                      ),
                                      child: Text(
                                        widget.userName.isNotEmpty
                                            ? widget.userName[0].toUpperCase()
                                            : 'G',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('  ${widget.userName}',
                                      style: AppTheme.subText),
                                  Text('  ${widget.userTag}',
                                      style: AppTheme.subText),
                                ],
                              ),
                            ]),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(widget.newsDate,
                                    style: AppTheme.subText.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                const Text(StringConstants.gayathriNews,
                                    style: AppTheme.subText),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Opacity(
                          opacity: 0.1,
                          child: Image.asset(
                            ImageConstants.logo,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                              child: Text(
                                widget.title,
                                textAlign: TextAlign.left,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (widget.description != null &&
                                widget.description!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                child: SizedBox(
                                  // Use all remaining space for description
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if ((widget.newsDistrict != null &&
                                              widget
                                                  .newsDistrict!.isNotEmpty) ||
                                          (widget.category != null &&
                                              widget.category!.isNotEmpty))
                                        Text.rich(
                                          TextSpan(
                                            text: widget.newsDistrict!.trim(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 16),
                                            children: [
                                              if (widget.category != null &&
                                                  widget.category!.isNotEmpty)
                                                TextSpan(
                                                  text:
                                                      ' (${widget.category}) ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontSize: 16,
                                                      ),
                                                ),
                                              TextSpan(
                                                text: widget.description!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w600),
                                              )
                                            ],
                                          ),
                                          maxLines: 10,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            buildToolBar(), // Move toolbar to the very end
          ],
        ),
      ),
    );
  }

  Widget buildToolBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.thumb_up_alt_outlined),
            onPressed: isLoading ? null : _toggleLike,
          ),
          Text('$likeCount'),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.thumb_down_alt_outlined),
            onPressed: isLoading ? null : _toggleDislike,
          ),
          Text('$disLikeCount'),
          const Spacer(), // Pushes the share icon to the right
          buildSharePost(),
        ],
      ),
    );
  }

  Widget buildSharePost() {
    return IconButton(
      icon: const Icon(Icons.share),
      onPressed: isLoading ? null : _handleShare,
    );
  }

  void _handleShare() async {
    final shareText = '${widget.title}\n '
        'Read more at: ${widget.shareUrl}\n'
        'Download App: ${StringConstants.playstoreAppLink}';
    ;
    final FlutterSocialShare flutterShareMe = FlutterSocialShare();
    // Open plugin's bottom sheet for all options
    await flutterShareMe.shareToSystem(msg: shareText);
  }
}
