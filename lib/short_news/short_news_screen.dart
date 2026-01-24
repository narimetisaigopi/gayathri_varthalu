import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gayathri_varthalu/widgets/ad_banner_widget.dart';
import 'package:gayathri_varthalu/widgets/ad_card_widget.dart';
import 'package:gayathri_varthalu/widgets/custom_loading_indicator.dart';
import 'package:flutter/services.dart';

import 'bloc/short_news_bloc.dart';
import 'news_card.dart';

class ShortNewsScreen extends StatefulWidget {
  final bool visible;
  const ShortNewsScreen({super.key, this.visible = false});

  @override
  State<ShortNewsScreen> createState() => _ShortNewsScreenState();
}

class _ShortNewsScreenState extends State<ShortNewsScreen>
    with AutomaticKeepAliveClientMixin {
  int currentIndex = 0;
  late final PageController _pageController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Do you want to exit the application?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return shouldExit ?? false;
      },
      child: Scaffold(
        body: BlocProvider(
          create: (_) => ShortNewsBloc()..add(FetchShortNews()),
          child: BlocBuilder<ShortNewsBloc, ShortNewsState>(
            builder: (context, state) {
              if (state is ShortNewsLoading || state is ShortNewsInitial) {
                return const CustomLoadingIndicator(message: 'Loading news...');
              } else if (state is ShortNewsAndAdvertisementsLoaded) {
                final newsList = state.newsList;
                final adsList = state.adsList;
                print('📰 News loaded: ${newsList.length} items');
                print('📢 Ads loaded: ${adsList.length} items');

                if (newsList.isEmpty) {
                  return const Center(child: Text('No news available.'));
                }
                // Interleave news and ads after every 2 news posts
                final List<Widget> items = [];
                int adIndex = 0;
                int adsListLength = adsList.length;

                for (int i = 0; i < newsList.length; i++) {
                  items.add(SizedBox.expand(
                    child: NewsCard(
                      slno: newsList[i]['slno'],
                      category: newsList[i]['category'] ?? '',
                      newsDistrict: newsList[i]['district'] ?? '',
                      userTag: newsList[i]['user_tag'] ?? '',
                      imageUrl: newsList[i]['news_img'],
                      userImageUrl: newsList[i]['user_pic'],
                      userName: newsList[i]['user_name'],
                      videoUrl: newsList[i]['youtube_link'],
                      title: newsList[i]['news_name'] ?? '',
                      description: newsList[i]['description'] ?? '',
                      newsDate: newsList[i]['date'] ?? '',
                      shareUrl: newsList[i]['share_url'] ?? '',
                      likeCount: int.tryParse(
                              newsList[i]['likes']?.toString() ?? '0') ??
                          0,
                      disLikeCount: int.tryParse(
                              newsList[i]["dlikes"]?.toString() ?? '0') ??
                          0,
                      viewCount: int.tryParse(
                              newsList[i]['views']?.toString() ?? '0') ??
                          0,
                      onLike: () {
                        debugPrint("like button pressed");
                      },
                      onShare: () {
                        debugPrint("share icon pressed");
                      },
                    ),
                  ));
                  // Insert ad after every 2 news posts
                  if ((i + 1) % 2 == 0) {
                    if (adsListLength > 0) {
                      final ad = adsList[adIndex % adsListLength];
                      adIndex++;
                      items.add(
                        Center(
                          child: AdCardWidget(
                            imageUrl: ad['image'],
                            title: ad['title'],
                            description: ad['description'],
                            ctaText: 'Learn More',
                            ctaUrl: ad['web_link'],
                            index: adIndex, // Pass index for badge
                          ),
                        ),
                      );
                    }
                  }

                  if ((i + 1) % 5 == 0) {
                    // Show Ad after every 5 news cards
                    print(
                        '🎯 Adding AdBannerWidget at position ${items.length} (after news item ${i + 1})');

                    // Production Banner Ad Unit (Real ads)
                    const adUnitId = 'ca-app-pub-2214578587937661/7583308365';
                    print('📌 Using ad unit: $adUnitId');

                    items.add(AdBannerWidget(adUnitId: adUnitId));
                    print(
                        '✅ AdBannerWidget added to items list. Total items: ${items.length}');
                  }
                }
                return SafeArea(
                  top: true,
                  bottom: true,
                  left: false,
                  right: false,
                  child: Scaffold(
                    backgroundColor: Colors.grey[300],
                    body: Stack(
                      children: [
                        PageView.builder(
                          controller: _pageController,
                          scrollDirection: Axis.vertical,
                          itemCount: items.length,
                          onPageChanged: (index) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                          itemBuilder: (context, index) => items[index],
                        ),
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 8,
                          right: 20,
                          child: Builder(
                            builder: (context) {
                              final currentItem = items.isNotEmpty &&
                                      currentIndex < items.length
                                  ? items[currentIndex]
                                  : null;
                              // Hide index layout if current item is AdCardWidget
                              if (currentItem is Center &&
                                  currentItem.child is AdCardWidget) {
                                return const SizedBox.shrink();
                              }
                              return Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 16),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Text(
                                        "${currentIndex + 1} / ${items.length}",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.orangeAccent,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    height: 30,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.refresh_rounded,
                                        color: Colors.black,
                                        size: 18,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          currentIndex = 0;
                                          _pageController.jumpToPage(0);
                                        });
                                        context
                                            .read<ShortNewsBloc>()
                                            .add(FetchShortNews());
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is ShortNewsError) {
                return Center(child: Text(state.message));
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}
