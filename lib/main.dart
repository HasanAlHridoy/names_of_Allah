import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:just_audio/just_audio.dart';

import 'names.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final CardSwiperController controller = CardSwiperController();
  final player = AudioPlayer();
  int nameIndex = 0;
  bool isVolumnOn = true;
  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  )  {
    player.setUrl(names()[currentIndex!]['audio_url']);
    if(isVolumnOn == true){
      player.setVolume(1);
    }else{
      player.setVolume(0);
    }
    player.play();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('dddd'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 300,
            child: CardSwiper(
              cardsCount: names().length,
              onSwipe: _onSwipe,
              controller: controller,
              cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
                nameIndex = index;
                return Container(
                  height: 200,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.green, Colors.green.shade900]),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(height: 20),
                      Text('$nameIndex of 99'),
                      const SizedBox(height: 20),
                      Text(names()[nameIndex]['arabic']),
                      Text(names()[nameIndex]['name_in_english']),
                      const SizedBox(height: 20),
                      Text(names()[nameIndex]['meaning_in_english']),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ),
          IconButton(
            onPressed: () {
              isVolumnOn = !isVolumnOn;
              setState(() {
              });
            },
            icon: isVolumnOn ? Icon(Icons.volume_down_rounded) : Icon(Icons.volume_off) ,
          ),
          ElevatedButton(
            onPressed: () async {
              player.pause();
            },
            child: Text('pause'),
          ),
          ElevatedButton(
            onPressed: ()  async{
              await player.setUrl(names()[nameIndex-1]['audio_url']);
              if(isVolumnOn == true){
                await player.setVolume(1);
              }else{
                await player.setVolume(0);
              }
              await player.play();

            },
            child: Text('play'),
          ),
          ElevatedButton(
            onPressed: ()  {
              setState(() {
                nameIndex = 0;
                _onSwipe(0, 0, CardSwiperDirection.none);
              });

            },
            child: Text('reset'),
          ),
        ],
      ),
    );
  }
}
