part of 'short_news_bloc.dart';

abstract class ShortNewsEvent {}

class FetchShortNews extends ShortNewsEvent {}

abstract class ShortNewsState {}

class ShortNewsInitial extends ShortNewsState {}

class ShortNewsLoaded extends ShortNewsState {
  final List<dynamic> newsList;

  ShortNewsLoaded(this.newsList);
}
