import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextButton(
                  onPressed: () => context.go('/basic_adjectives'),
                  child: const Text(
                    'Adjectives trainer',
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/bingo'),
                  child: const Text(
                    'Bingo',
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
