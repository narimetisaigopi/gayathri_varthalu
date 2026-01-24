import 'package:flutter_bloc/flutter_bloc.dart';

abstract class LatestNewsEvent {}

class FetchLatestNews extends LatestNewsEvent {}

abstract class LatestNewsState {}

class LatestNewsInitial extends LatestNewsState {}

class LatestNewsBloc extends Bloc<LatestNewsEvent, LatestNewsState> {
  LatestNewsBloc() : super(LatestNewsInitial()) {
    on<FetchLatestNews>((event, emit) {
      // TODO: implement fetch logic
    });
  }
}
