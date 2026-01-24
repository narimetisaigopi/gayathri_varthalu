import 'package:go_router/go_router.dart';
import 'package:gayathri_varthalu/home_screen.dart';
import 'package:gayathri_varthalu/short_news/short_news_screen.dart';
import 'package:gayathri_varthalu/latest_news/latest_news_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'short-news',
          builder: (context, state) => const ShortNewsScreen(),
        ),
        GoRoute(
          path: 'latest-news',
          builder: (context, state) => const LatestNewsScreen(),
        ),
      ],
    ),
  ],
);
