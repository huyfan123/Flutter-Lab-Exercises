import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(
      const MaterialApp(
        home: Magic8BallApp(),
        debugShowCheckedModeBanner: false,
      ),
    );

class Magic8BallApp extends StatelessWidget {
  const Magic8BallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        title: const Text('Ask Me Anything'),
        backgroundColor: Colors.blueGrey.shade900,
        foregroundColor: Colors.white,
      ),
      body: const Magic8BallPage(),
    );
  }
}

class Magic8BallPage extends StatefulWidget {
  const Magic8BallPage({super.key});

  @override
  State<Magic8BallPage> createState() => _Magic8BallPageState();
}

class _Magic8BallPageState extends State<Magic8BallPage> {
  int ballNumber = 1;

  void changeBall() {
    setState(() {
      // Generate a random number between 1 and 5
      ballNumber = Random().nextInt(5) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset('assets/images/ball$ballNumber.png'),
            ),
          ),
          ElevatedButton(
            onPressed: changeBall,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text(
              'Get Answer',
              style: TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
