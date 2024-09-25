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
    items.shuffle(); // للبدء بشكل عشوائي عند فتح اللعبة كل مرة
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
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text.rich(TextSpan(children: [
              TextSpan(
                  text: 'Score:', style: Theme.of(context).textTheme.labelMedium),
              TextSpan(
                  text: '$score',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: Colors.blue))
            ])),
          ),
          if (!gameOver)
            Row(
              children: [
                Spacer(),
                Column(
                    children: items.map((item) {
                  return Container(
                      margin: EdgeInsets.all(8),
                      child: Draggable<ItemsModel>(
                          data: item,
                          childWhenDragging: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage(item.image),
                            radius: 70,
                          ),
                          feedback: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage(item.image),
                            radius: 50,
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage(item.image),
                            radius: 50,
                          )));
                }).toList()),
                Spacer(),
                Column(
                    children: items2.map((item) {
                  return DragTarget<ItemsModel>(
                      onAccept: (receivedItem) async {
                        if (item.value == receivedItem.value) {
                          setState(() {
                            items.remove(receivedItem);
                            items2.remove(item);
                          });
                          score = 'true';
                          item.accepting = false;
                          await player.play(AssetSource('audio/true.wav'))
                              .catchError((error) {
                            print('Error playing true sound: $error');
                          });
                        } else {
                          setState(() {
                            score = 'false';
                            item.accepting = false;
                          });
                          await player
                              .play(AssetSource('audio/tryAgain.wav'))
                              .catchError((error) {
                            print('Error playing tryAgain sound: $error');
                          });
                        }
                      },
                      onWillAccept: (receivedItem) {
                        setState(() {
                          item.accepting = true;
                        });
                        return true;
                      },
                      onLeave: (receivedItem) {
                        setState(() {
                          item.accepting = false;
                        });
                      },
                      builder: (context, acceptedItem, rejectedItem) =>
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: item.accepting
                                    ? Colors.grey[400]
                                    : Colors.grey[200]),
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.width / 6.5,
                            width: MediaQuery.of(context).size.width / 3,
                            margin: EdgeInsets.all(8),
                            child: Text(item.name,
                                style: Theme.of(context).textTheme.headlineMedium),
                          ));
                }).toList()),
                Spacer()
              ],
            ),
        ],
      ))),
    );
  }
}
