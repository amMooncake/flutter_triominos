import 'package:flutter/material.dart';

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

  void StartGame() {
    if (_formKey.currentState!.validate()) {
      List<MyPlayer> players = [];
      for (var controller in _controllers) {
        players.add(MyPlayer(name: controller.text, color: Colors.primaries[_controllers.indexOf(controller)]));
      }
      print(players);
    }
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
                      SizedBox(height: _numbersOfPlayers == 0 ? 0 : 30),
                      if (_numbersOfPlayers != 0)
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 3 / 2),
                                shrinkWrap: true,
                                itemCount: _numbersOfPlayers,
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                    height: 10,
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
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
                                          fillColor: Colors.grey.shade200,
                                          filled: true,
                                          counterText: "",
                                          hintText: 'Enter a name',
                                          hintStyle: TextStyle(color: Colors.grey),
                                          // Optional: to use the primary color for the cursor and text
                                        ),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  );
                                },
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
                height: 48,
                child: TextButton(
                  onPressed: StartGame,
                  child: Text("START", style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
