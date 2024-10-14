import 'package:flutter/material.dart';
import 'dart:async';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Color bgcolor = const Color(0xFFF6F8FE);
  Color secondry = const Color(0xFFECEFF9);
  Color highlight = const Color(0xFFE7EBF7);

  List<Map<String, String>> lapsList = [];

  Timer? _timer;
  Duration _elapsedTime = Duration.zero;

  bool isStart = false;
  bool isPause = false;

  String timeFormat(Duration duration) {
    // Format Duration to HH:MM:SS
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  void startWatch() {
    // Start the Stopwatch
    setState(() {
      isStart = true;
      isPause = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime += const Duration(seconds: 1);
      });
    });
  }

  void pauseWatch() {
    // Pause the Stopwatch
    _timer?.cancel();
    setState(() {
      isPause = true;
      isStart = false;
    });
  }

  void resetWatch() {
    // Reset the Stopwatch
    _timer?.cancel();
    _elapsedTime = Duration.zero;
    lapsList.clear();
    setState(() {
      isStart = false;
      isPause = false;
    });
  }

  void stopWatch() {
    // Stop the Stopwatch
    _timer?.cancel();
    setState(() {
      _elapsedTime = Duration.zero;
      isStart = false;
      isPause = false;
    });
  }

  void addLap() {
    // Add a Lap
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
        leading: const Padding(
          padding: EdgeInsets.only(left: 25, top: 20),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 30,
          ),
        ),
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 15, right: 55, bottom: 5),
            child: Container(
              height: 50,
              width: 200,
              decoration: BoxDecoration(
                color: secondry,
                borderRadius: BorderRadius.circular(360),
              ),
              child: const Center(
                child: Text(
                  'StopWatch',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Timer Display
          Padding(
            padding: const EdgeInsets.only(top: 110),
            child: Center(
              child: InkWell(
                onTap: addLap,
                child: Container(
                  height: 270,
                  width: 270,
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(360),
                    boxShadow: List.filled(
                      10,
                      BoxShadow(
                        color: highlight,
                        blurRadius: 30,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Display Time
                      Text(
                        timeFormat(_elapsedTime),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontFamily: 'Redex',
                        ),
                      ),
                      const SizedBox(height: 10), // Spacing between time and text
                      // "Tap to Lap" text
                      const Text(
                        'Tap to Lap',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Laps List
          SizedBox(
            width: double.infinity,
            height: 250,
            child: ListView.builder(
              itemCount: lapsList.length,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 10, right: 10, top: 80),
              itemBuilder: (context, index) {
                final lapItem = lapsList[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 30, left: 10, right: 5),
                  child: Container(
                    height: 120,
                    width: 180,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[400],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10, right: 10),
                              child: Icon(
                                Icons.delete,
                                size: 20,
                                color: highlight,
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 15),
                          child: Text(
                            lapItem['lap']!,
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Redex',
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, left: 15),
                          child: Text(
                            lapItem['time']!,
                            style: TextStyle(
                              color: Colors.lightGreenAccent,
                              fontFamily: 'Ubuntu',
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Spacer(),

          // Control Buttons
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Start/Pause Button
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: InkWell(
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
                      height: 70,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(360),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isStart ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            color: Colors.green,
                            size: 35,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            isStart ? 'PAUSE' : isPause ? 'RESUME' : 'START',
                            style: TextStyle(
                              color: Colors.grey.shade300,
                              fontSize: 19,
                              fontFamily: 'Ubuntu',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Spacer(),

                // Stop/Reset Button
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: InkWell(
                    onTap: () {
                      if (isStart || isPause) {
                        stopWatch();
                      } else {
                        resetWatch();
                      }
                    },
                    child: Container(
                      height: 70,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(360),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isStart || isPause ? Icons.stop_rounded : Icons.restart_alt,
                            color: Colors.red,
                            size: 35,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            isStart || isPause ? 'STOP' : 'RESET',
                            style: TextStyle(
                              color: Colors.grey.shade300,
                              fontSize: 19,
                              fontFamily: 'Ubuntu',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
