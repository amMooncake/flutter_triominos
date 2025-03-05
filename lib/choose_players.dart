import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/player.dart';

class ChoosePlayersScreen extends StatefulWidget {
  const ChoosePlayersScreen({super.key});

  @override
  State<ChoosePlayersScreen> createState() => _ChoosePlayersScreenState();
}

class _ChoosePlayersScreenState extends State<ChoosePlayersScreen> {
  int _numbersOfPlayers = 0;
  List<MyPlayer> players = [];
  final _formKey = GlobalKey<FormState>();

  void addPlayer() {
    if (_numbersOfPlayers < 6) {
      _numbersOfPlayers++;
      players.add(MyPlayer(name: '', color: Colors.blue));
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Maximum Players Reached')));
    }
    setState(() {});
    print(players);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Players'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * .9,
              child: Material(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                "$_numbersOfPlayers",
                                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            width: 80,
                            height: 80,
                            child: IconButton(
                              onPressed: addPlayer,
                              icon: Icon(size: 40, Icons.add, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: _numbersOfPlayers == 0 ? 0 : 50),
                      if (_numbersOfPlayers != 0)
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              ListView.separated(
                                separatorBuilder: (BuildContext ctxt, int index) => SizedBox(
                                  height: 20,
                                ),
                                itemCount: _numbersOfPlayers,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext ctxt, int index) {
                                  return Material(
                                    elevation: 2,
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    color: Colors.white,
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 130,
                                            child: TextFormField(
                                              maxLength: 10,
                                              decoration: InputDecoration(
                                                counterText: "",
                                                hintText: 'Enter a name',
                                                hintStyle: TextStyle(color: Colors.grey),
                                                enabledBorder: InputBorder.none, // No border when field is enabled
                                                // Optional: to use the primary color for the cursor and text
                                              ),
                                              style: TextStyle(color: Colors.black),
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                            ),
                                            width: 48,
                                            height: 48,
                                            child: IconButton(
                                              onPressed: () {
                                                _numbersOfPlayers--;
                                                players.removeAt(index);
                                                setState(() {});
                                              },
                                              icon: Icon(size: 25, Icons.remove, color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
