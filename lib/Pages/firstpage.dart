import 'package:flutter/material.dart';
import 'package:web_event/MAinPageCOntainer.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blue[900],
        body: const MainPageContainer(),
      ),
    );
  }
}
