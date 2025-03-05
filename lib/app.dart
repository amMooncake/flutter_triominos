import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_triominos/choose_players.dart';

import 'package:flutter_triominos/Navigation_bloc/navigation_bloc.dart';
import 'package:flutter_triominos/game.dart';
import 'package:flutter_triominos/models/player.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationBloc(),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          if (state is ChoosePlayersState) {
            return ChoosePlayersScreen();
          } else if (state is GameState) {
            final state = context.read<NavigationBloc>().state;
            List<MyPlayer> players = [];
            if (state is GameState) {
              players = state.players;
            }
            return GameScreen(players);
          }
          return Scaffold(
            body: Center(
              child: Text("Error has occured"),
            ),
          );
        },
      ),
    );
  }
}
