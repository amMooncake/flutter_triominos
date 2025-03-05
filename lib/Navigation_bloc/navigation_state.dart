part of 'navigation_bloc.dart';

@immutable
sealed class NavigationState {}

class ChoosePlayersState extends NavigationState {}

class GameState extends NavigationState {
  final List<MyPlayer> players;

  GameState(this.players);

  @override
  List<Object?> get props => [players];
}
