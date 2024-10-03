import 'package:audioplayers/audioplayers.dart';
import 'package:gamedrag/items.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final player = AudioPlayer();
  late List<ItemsModel> items; // show image
  late List<ItemsModel> items2; // show name
  late String score; // result
  late bool gameOver; // the game end or not

  initGame() {
    gameOver = false;
    score = '';
    items = [
      ItemsModel(
          name: 'Apple', image: 'assets/image/apple.png', value: 'Apple'),
      ItemsModel(
          name: 'Bananas', image: 'assets/image/bananas.png', value: 'Bananas'),
      ItemsModel(
          name: 'Grape', image: 'assets/image/grapes.png', value: 'Grape'),
      ItemsModel(
          name: 'Mango', image: 'assets/image/mango.png', value: 'Mango'),
      ItemsModel(
          name: 'Orange', image: 'assets/image/oreange.png', value: 'Orange'),
      ItemsModel(
          name: 'Strawberry',
          image: 'assets/image/strawberyy.png',
          value: 'Strawberry'),
    ];
    items2 = List<ItemsModel>.from(items);
    items.shuffle();
    items2.shuffle();
  }

  @override
  void initState() {
    super.initState();
    initGame();
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) gameOver = true;
    return Scaffold(
      appBar: AppBar(
        title: Text('Fruit Matcher'),
        backgroundColor: Colors.purple[700],
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              // Add help functionality here
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'Drag the fruits to their names',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Row(
                children: [
                  Spacer(),
                  // Images Column
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.purple, width: 2),
                    ),
                    child: Column(
                      children: items.map((item) {
                        return Container(
                          margin: EdgeInsets.all(8),
                          child: Draggable<ItemsModel>(
                            data: item,
                            childWhenDragging: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage(item.image),
                              radius: 50,
                            ),
                            feedback: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage(item.image),
                              radius: 50,
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage(item.image),
                              radius: 40,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Spacer(),
                  // Names Column
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.purple, width: 2),
                    ),
                    child: Column(
                      children: items2.map((item) {
                        return DragTarget<ItemsModel>(
                          onAccept: (receivedItem) async {
                            if (item.value == receivedItem.value) {
                              setState(() {
                                items.remove(receivedItem);
                                items2.remove(item);
                              });
                              score = 'true';
                              await player.play(AssetSource('audio/true.wav'));
                            } else {
                              setState(() {
                                score = 'false';
                              });
                              await player
                                  .play(AssetSource('audio/tryAgain.wav'));
                            }
                          },
                          builder: (context, acceptedItem, rejectedItem) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey[200],
                              ),
                              alignment: Alignment.center,
                              height: 50,
                              width: 150,
                              margin: EdgeInsets.all(8),
                              child: Text(item.name),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(height: 20),
              // Score Section
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple[100],
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.purple, width: 2),
                ),
                child: Text(
                  'Score: $score',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
