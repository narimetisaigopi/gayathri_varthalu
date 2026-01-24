import 'package:flutter_bloc/flutter_bloc.dart';

abstract class TVEvent {}

class FetchTV extends TVEvent {}

abstract class TVState {}

class TVInitial extends TVState {}

class TVBloc extends Bloc<TVEvent, TVState> {
  TVBloc() : super(TVInitial()) {
    on<FetchTV>((event, emit) {
      // TODO: implement fetch logic
    });
  }
}
