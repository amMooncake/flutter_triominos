part of 'navigation_bloc.dart';

@immutable
sealed class NavigationEvent {}

class NavigateToChoosePlayersEvent extends NavigationEvent {}

class NavigateToGameEvent extends NavigationEvent {
  final List<MyPlayer> players;

  NavigateToGameEvent(this.players);

  @override
  List<Object?> get props => [players];
}
