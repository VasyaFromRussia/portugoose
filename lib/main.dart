import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portugoose/bingo/bingo_ui.dart';
import 'package:portugoose/common/ui/text_theme.dart';
import 'package:portugoose/firebase_options.dart';
import 'package:portugoose/home/home_screen.dart';
import 'package:portugoose/sentence.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final _router = GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/basic_adjectives',
      builder: (context, state) => const SentenceTrainer(),
    ),
    GoRoute(
      path: '/bingo',
      builder: (context, state) => const BingoScreen(),
    )
  ]);

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
        builder: (context, snapshot) => ProviderScope(
          child: MaterialApp.router(
            routeInformationParser: _router.routeInformationParser,
            routerDelegate: _router.routerDelegate,
            theme: ThemeData(
              textTheme: textTheme,
              fontFamily: 'Rubik',
            ),
          ),
        ),
      );
}
