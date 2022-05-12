import 'dart:collection';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:portugoose/common/ui/keyboard.dart';
import 'package:portugoose/common/ui/text_theme.dart';

class SentenceTrainer extends StatefulWidget {
  const SentenceTrainer({Key? key}) : super(key: key);

  @override
  State<SentenceTrainer> createState() => _SentenceTrainerState();
}

class _SentenceTrainerState extends State<SentenceTrainer> {
  late Word _word;
  String _answer = '';

  final _words = <Word>[];

  bool get _canCheck => _answer.isNotEmpty;
  bool _isChecked = false;

  _AnswerState get _answerState {
    if (_isChecked) {
      if (_answer == _word.pt) {
        return _AnswerState.correct;
      } else {
        return _AnswerState.wrong;
      }
    } else {
      return _AnswerState.pending;
    }
  }

  @override
  void initState() {
    super.initState();

    final ref = FirebaseDatabase.instance.ref('basic-adjectives');
    ref.get().then((value) {
      final jsonArray = value.value;
      if (jsonArray == null) {
        throw 'No result';
      }

      final data = jsonArray as Map<dynamic, dynamic>;
      final words = (data["words"] as List<dynamic>).map((e) => Word(pt: e['pt'], ru: e['ru']));
      setState(() {
        _words.addAll(words);
        _word = _words.removeAt(0);
      });
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: _words.isEmpty
              ? Container()
              : Stack(
                  children: [
                    Padding(
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
                                _word.ru,
                                style: buttonStyle.copyWith(color: const Color(0xFF1C1C1E)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 120,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: _answerState.color,
                              ),
                              alignment: Alignment.center,
                              child: _answer.isEmpty
                                  ? Text(
                                      "Translate the word",
                                      style: buttonStyle.copyWith(color: const Color(0xFFF2F2F7).withOpacity(0.5)),
                                    )
                                  : Text(
                                      _answer,
                                      style: buttonStyle.copyWith(color: const Color(0xFFF2F2F7)),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Keyboard(
                            text: _word.pt,
                            onEdit: (result) => setState(() => _answer = result),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F2F7).withAlpha((255 * 0.5).toInt()),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            onTap: _canCheck ? _check : null,
                            child: AnimatedContainer(
                              decoration: BoxDecoration(
                                color: const Color(0xFF7438FF).withAlpha(_canCheck ? 255 : (255 * 0.25).toInt()),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              alignment: Alignment.center,
                              duration: const Duration(milliseconds: 300),
                              child: Text(
                                "Check",
                                style: buttonStyle.copyWith(color: const Color(0xFFF2F2F7)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      );

  void _check() {
    if (_isChecked) {
      setState(() {
        _word = _words.removeAt(0);
        _answer = '';
        _isChecked = false;
      });
    } else {
      setState(() => _isChecked = true);
    }
  }
}

enum _AnswerState {
  pending,
  correct,
  wrong,
}

extension on _AnswerState {
  Color get color {
    switch (this) {
      case _AnswerState.pending:
        return const Color(0xFF7438FF);
      case _AnswerState.correct:
        return const Color(0xFF30D158);
      case _AnswerState.wrong:
        return const Color(0xFFFF453A);
    }
  }
}

class Word {
  Word({
    required this.pt,
    required this.ru,
  });

  final String pt;
  final String ru;
}
