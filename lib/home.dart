import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart'; // Add this dependency in pubspec.yaml

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Color bgcolor = Colors.yellowAccent;
  Color highlight = Colors.redAccent;

  List<Map<String, String>> lapsList = [];
  Timer? _timer;
  Duration _elapsedTime = Duration.zero;
  Duration _countdownTime = Duration(minutes: 1); // Default countdown time
  bool isCountdown = false;

  bool isStart = false;
  bool isPause = false;

  AudioPlayer audioPlayer = AudioPlayer();

  String timeFormat(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  void startWatch() {
    setState(() {
      isStart = true;
      isPause = false;
      isCountdown = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime += const Duration(seconds: 1);
      });
    });
  }

  void startCountdown() {
    setState(() {
      isCountdown = true;
      isStart = true;
      isPause = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdownTime.inSeconds > 0) {
          _countdownTime -= const Duration(seconds: 1);
        } else {
          audioPlayer.play('alert_sound.mp3'); // Ensure you have this file in assets
          _timer?.cancel();
          isStart = false;
          isCountdown = false;
        }
      });
    });
  }

  void pauseWatch() {
    _timer?.cancel();
    setState(() {
      isPause = true;
      isStart = false;
    });
  }

  void resetWatch() {
    _timer?.cancel();
    _elapsedTime = Duration.zero;
    lapsList.clear();
    setState(() {
      isStart = false;
      isPause = false;
      isCountdown = false;
      _countdownTime = Duration(minutes: 1); // Reset countdown time
    });
  }

  void stopWatch() {
    _timer?.cancel();
    setState(() {
      _elapsedTime = Duration.zero;
      isStart = false;
      isPause = false;
      isCountdown = false;
    });
  }

  void addLap() {
    if (isStart) {
      setState(() {
        lapsList.add({'lap': 'LAP ${lapsList.length + 1}', 'time': timeFormat(_elapsedTime)});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        title: const Text('Ultimate Chaos Stopwatch', style: TextStyle(fontSize: 30)),
        centerTitle: true,
        backgroundColor: highlight,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: resetWatch,
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: 30,
            left: 10,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(150),
                border: Border.all(color: Colors.purple, width: 10),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isCountdown ? timeFormat(_countdownTime) : timeFormat(_elapsedTime),
                      style: const TextStyle(color: Colors.white, fontSize: 60, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text('Lap Now!', style: TextStyle(color: Colors.black, fontSize: 20)),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 200,
            left: 50,
            right: 0,
            child: Container(
              height: 100,
              child: ListView.builder(
                itemCount: lapsList.length,
                padding: const EdgeInsets.only(left: 10, right: 10),
                itemBuilder: (context, index) {
                  final lapItem = lapsList[index];
                  return Container(
                    width: 150,
                    height: 80,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10)],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(lapItem['lap']!, style: const TextStyle(color: Colors.black, fontSize: 16)),
                        Text(lapItem['time']!, style: const TextStyle(color: Colors.black, fontSize: 14)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    if (isStart) {
                      pauseWatch();
                    } else if (isPause) {
                      startWatch();
                    } else {
                      startWatch();
                    }
                  },
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 5)],
                    ),
                    child: Center(
                      child: Text(isStart ? 'PAUSE' : isPause ? 'RESUME' : 'START', style: const TextStyle(color: Colors.black, fontSize: 24)),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (isStart || isPause) {
                      stopWatch();
                    } else {
                      resetWatch();
                    }
                  },
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 5)],
                    ),
                    child: Center(
                      child: Text(isStart || isPause ? 'STOP' : 'RESET', style: const TextStyle(color: Colors.white, fontSize: 24)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 150,
            left: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, elevation: 10, padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
              onPressed: addLap,
              child: const Text('Add Lap', style: TextStyle(fontSize: 20)),
            ),
          ),
          Positioned(
            bottom: 150,
            right: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, elevation: 10, padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
              onPressed: startCountdown,
              child: const Text('Start Countdown', style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }
}
