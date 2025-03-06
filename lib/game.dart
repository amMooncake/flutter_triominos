import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_triominos/Navigation_bloc/navigation_bloc.dart';

import 'models/player.dart';

class GameScreen extends StatefulWidget {
  const GameScreen(this.players, {super.key});
  final List<MyPlayer> players;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final List<int> points = [1, 2, 5, 10, 20, 50];
  List<MyPlayer> players = [];
  int _currentPlayer = 0;
  int roundNumber = 0;
  bool gameStarted = false;
  bool addingPoints = true;
  int pointsToBeAdded = 0;

  void roundButtonPressed() {
    if (gameStarted) {
      players[_currentPlayer].score += pointsToBeAdded;
      players[_currentPlayer].isPlaying = false;
      if (_currentPlayer == players.length - 1) {
        _currentPlayer = 0;
        roundNumber++;
      } else {
        _currentPlayer++;
      }
      players[_currentPlayer].isPlaying = true;
    } else {
      players[0].isPlaying = true;
      gameStarted = true;
      roundNumber++;
    }
    pointsToBeAdded = 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    players = widget.players;
    return Scaffold(
      appBar: AppBar(
        title: Text('Round number: ${roundNumber}'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                players.forEach((player) {
                  player.score = 0;
                  player.isPlaying = false;
                });
                _currentPlayer = 0;
                roundNumber = 0;
                gameStarted = false;
                pointsToBeAdded = 0;
              });
            },
            icon: Icon(Icons.restore),
          ),
          IconButton(
            onPressed: () {
              context.read<NavigationBloc>().add(NavigateToChoosePlayersEvent());
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  shrinkWrap: true,
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: players[index].isPlaying
                          ? BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              color: widget.players[index].color,
                            )
                          : BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              border: Border.all(color: players[index].color, width: 5),
                            ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              players[index].name,
                              style: TextStyle(
                                  color: players[index].isPlaying ? Colors.white : Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${players[index].score}",
                              style: TextStyle(
                                color: players[index].isPlaying ? Colors.white : Colors.black,
                                fontSize: players[index].score < 1000 ? 40 : 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              color: addingPoints ? Colors.green : Colors.red,
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: addingPoints ? Colors.green : Colors.red,
                              ),
                              onPressed: () {
                                if (gameStarted) {
                                  if (addingPoints) {
                                    pointsToBeAdded += points[index];
                                  } else {
                                    pointsToBeAdded -= points[index];
                                  }
                                  setState(() {});
                                }
                              },
                              child: Text(
                                "${points[index]}",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "$pointsToBeAdded",
                            style: TextStyle(
                              fontSize: (pointsToBeAdded <= -1000 || pointsToBeAdded >= 1000) ? 30 : 50,
                              color: pointsToBeAdded < 0 ? Colors.red : Colors.green,
                            ),
                          ),
                          SizedBox(height: 10),
                          IconButton(
                            onPressed: () {
                              addingPoints = !addingPoints;
                              setState(() {});
                            },
                            icon: Icon(
                              Icons.change_circle,
                              size: 66,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  width: MediaQuery.of(context).size.width * .9,
                  height: 80,
                  child: TextButton(
                    onPressed: roundButtonPressed,
                    child: Text(
                        gameStarted
                            ? _currentPlayer == players.length - 1
                                ? "NEXT ROUND"
                                : "NEXT PLAYER"
                            : "START GAME",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
