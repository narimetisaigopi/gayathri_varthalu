part of 'short_news_bloc.dart';

class AdvertisementsLoaded extends ShortNewsState {
  final List<dynamic> adsList;
  AdvertisementsLoaded(this.adsList);
}

class ShortNewsAndAdvertisementsLoaded extends ShortNewsState {
  final List<dynamic> newsList;
  final List<dynamic> adsList;
  ShortNewsAndAdvertisementsLoaded(this.newsList, this.adsList);
}

class ShortNewsLoading extends ShortNewsState {}

class ShortNewsError extends ShortNewsState {
  final String message;
  ShortNewsError(this.message);
}
