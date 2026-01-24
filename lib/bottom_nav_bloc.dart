import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class BottomNavEvent extends Equatable {
  const BottomNavEvent();
}

class TabChanged extends BottomNavEvent {
  final int index;
  const TabChanged(this.index);

  @override
  List<Object> get props => [index];
}

// State
class BottomNavState extends Equatable {
  final int selectedIndex;
  const BottomNavState(this.selectedIndex);

  @override
  List<Object> get props => [selectedIndex];
}

// Bloc
class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc() : super(const BottomNavState(0)) {
    on<TabChanged>((event, emit) {
      emit(BottomNavState(event.index));
    });
  }
}
