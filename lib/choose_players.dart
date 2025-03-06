import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_triominos/Navigation_bloc/navigation_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'models/player.dart';

class ChoosePlayersScreen extends StatefulWidget {
  const ChoosePlayersScreen({super.key});

  @override
  State<ChoosePlayersScreen> createState() => _ChoosePlayersScreenState();
}

class _ChoosePlayersScreenState extends State<ChoosePlayersScreen> {
  int _numbersOfPlayers = 0;
  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> _controllers = [];
  final List<Color> _pickedColors = [
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey,
  ];

  void addPlayer() {
    if (_numbersOfPlayers < 6) {
      _numbersOfPlayers++;
      _controllers.add(TextEditingController());
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Maximum Players Reached')));
    }
    setState(() {});
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void removePlayer() {
    _numbersOfPlayers--;
    _controllers.removeLast();
    setState(() {});
  }

  void startGame() {
    if (_formKey.currentState!.validate()) {
      List<MyPlayer> players = [];
      for (var controller in _controllers) {
        players.add(MyPlayer(name: controller.text, color: _pickedColors[_controllers.indexOf(controller)]));
      }
      context.read<NavigationBloc>().add(NavigateToGameEvent(players));
    }
  }

  void pickColor(int index) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text("Pick Color"),
            content: SingleChildScrollView(
              child: BlockPicker(
                pickerColor: _pickedColors[index],
                onColorChanged: (color) {
                  setState(() {
                    Navigator.of(ctx).pop();
                    _pickedColors[index] = color;
                  });
                },
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Players'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: Material(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                        SizedBox(height: _numbersOfPlayers == 0 ? 0 : 30),
                        if (_numbersOfPlayers != 0)
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: _numbersOfPlayers * 70,
                                  child: ListView.builder(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: _numbersOfPlayers,
                                    itemBuilder: (ctx, index) {
                                      return Row(children: [
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: TextFormField(
                                              controller: _controllers[index],
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Enter a name';
                                                }
                                                return null;
                                              },
                                              maxLength: 10,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius: BorderRadius.circular(10), // Adjust border radius
                                                ),
                                                fillColor: _pickedColors[index].withAlpha(100),
                                                filled: true,
                                                counterText: "",
                                                hintText: 'Enter a name',
                                                hintStyle: TextStyle(color: Colors.grey.shade600),
                                                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),

                                                // Optional: to use the primary color for the cursor and text
                                              ),
                                              style: TextStyle(color: Colors.black, fontSize: 20),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () => pickColor(index),
                                            icon: Icon(
                                              Icons.palette,
                                              color: _pickedColors[index],
                                            ))
                                      ]);
                                    },
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(width: 10),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      width: 48,
                                      height: 48,
                                      child: IconButton(
                                        onPressed: removePlayer,
                                        icon: Icon(size: 25, Icons.remove, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (_numbersOfPlayers > 1)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  width: MediaQuery.of(context).size.width * .9,
                  height: 100,
                  child: TextButton(
                    onPressed: () {
                      startGame();
                    },
                    child: Text("START", style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
