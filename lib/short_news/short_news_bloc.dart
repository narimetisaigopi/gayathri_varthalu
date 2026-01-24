import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gayathri_varthalu/services/short_news_service.dart';

abstract class ShortNewsEvent {}

class FetchShortNews extends ShortNewsEvent {}

class FetchAdvertisements extends ShortNewsEvent {}

abstract class ShortNewsState {}

class ShortNewsInitial extends ShortNewsState {}

class ShortNewsAndAdvertisementsLoaded extends ShortNewsState {
  final List<dynamic> newsList;
  final List<dynamic> adsList;
  ShortNewsAndAdvertisementsLoaded(this.newsList, this.adsList);
}

class AdvertisementsLoaded extends ShortNewsState {
  final List<dynamic> adsList;
  AdvertisementsLoaded(this.adsList);
}

class ShortNewsLoading extends ShortNewsState {}

class ShortNewsError extends ShortNewsState {
  final String message;
  ShortNewsError(this.message);
}

class ShortNewsBloc extends Bloc<ShortNewsEvent, ShortNewsState> {
  ShortNewsBloc() : super(ShortNewsInitial()) {
    on<FetchShortNews>((event, emit) async {
      emit(ShortNewsLoading());
      try {
        final news = await ShortNewsService.fetchShortNews();
        final ads = await ShortNewsService.fetchAdvertisements();
        emit(ShortNewsAndAdvertisementsLoaded(news, ads));
      } catch (e) {
        emit(ShortNewsError('Failed to load short news or ads'));
      }
    });
    on<FetchAdvertisements>((event, emit) async {
      emit(ShortNewsLoading());
      try {
        final ads = await ShortNewsService.fetchAdvertisements();
        emit(AdvertisementsLoaded(ads));
      } catch (e) {
        emit(ShortNewsError('Failed to load advertisements'));
      }
    });
  }
}
