import 'package:bloc/bloc.dart';
import 'package:flutter_triominos/models/player.dart';
import 'package:meta/meta.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(ChoosePlayersState()) {
    on<NavigateToChoosePlayersEvent>((event, emit) {
      emit(ChoosePlayersState());
    });

    on<NavigateToGameEvent>((event, emit) {
      emit(GameState(event.players));
    });
  }
}
