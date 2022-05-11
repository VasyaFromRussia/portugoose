import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portugoose/numbers/verb_ui.dart';
import 'package:portugoose/sentence.dart';
import 'package:portugoose/verb/verb_ui.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ProviderScope(child:
     MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        textTheme: const TextTheme(
          headline3: TextStyle(
            color: Colors.black,
            fontSize: 36,
            fontWeight: FontWeight.w400,
          ),
          headline4: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w200,
          ),
          button: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      home: Scaffold(
        body: SafeArea(child: SentenceTrainer()),
      ),
    ),
  );
}

