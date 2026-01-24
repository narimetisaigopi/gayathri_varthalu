import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gayathri_varthalu/services/short_news_service.dart';

part 'short_news_event.dart';

part 'short_news_state.dart';

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
  }
}
