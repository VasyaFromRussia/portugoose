import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:portugoose/common/ui/keyboard.dart';
import 'package:portugoose/common/ui/text_theme.dart';

class SentenceTrainer extends StatefulWidget {
  const SentenceTrainer({Key? key}) : super(key: key);

  @override
  State<SentenceTrainer> createState() => _SentenceTrainerState();
}

class _SentenceTrainerState extends State<SentenceTrainer> {
  String _answer = "";

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 120,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: const Color(0xFFF2F2F7),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Beer",
                  style: buttonStyle.copyWith(color: Color(0xFF1C1C1E)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: const Color(0xFF7438FF),
                ),
                alignment: Alignment.center,
                child: _answer.isEmpty
                    ? Text(
                        "Translate the word",
                        style: buttonStyle.copyWith(color: Color(0xFFF2F2F7).withOpacity(0.5)),
                      )
                    : Text(
                        _answer,
                        style: buttonStyle.copyWith(color: Color(0xFFF2F2F7)),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Keyboard(
              text: "cerveja",
              onEdit: (result) => setState(() => _answer = result),
            ),
            Expanded(child: Container()),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFF7438FF),
              ),
              padding: EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              child: Text(
                "Check",
                style: buttonStyle.copyWith(color: Color(0xFFF2F2F7)),
              ),
            ),
          ],
        ),
      );
}
