import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gayathri_varthalu/services/token_service.dart';

// Events
abstract class UrlEvent {}

class FetchUrlsEvent extends UrlEvent {}

// States
abstract class UrlState {}

class UrlInitial extends UrlState {}

class UrlLoading extends UrlState {}

class UrlLoaded extends UrlState {
  final String webUrl;
  final String liveUrl;
  final String ePaperUrl;
  final String? popImage;

  UrlLoaded({
    required this.webUrl,
    required this.liveUrl,
    required this.ePaperUrl,
    this.popImage,
  });
}

class UrlError extends UrlState {
  final String message;

  UrlError(this.message);
}

class UrlBloc extends Bloc<UrlEvent, UrlState> {
  UrlBloc() : super(UrlInitial()) {
    on<FetchUrlsEvent>((event, emit) async {
      emit(UrlLoading());
      try {
        final data = await TokenService.fetchUrls();
        emit(UrlLoaded(
          webUrl: data?['weburl'],
          liveUrl: data?['liveurl'],
          ePaperUrl: data?['epaperurl'],
          popImage: data?['pop_image'],
        ));
      } catch (e) {
        emit(UrlError('Failed to fetch URLs'));
      }
    });
  }
}
