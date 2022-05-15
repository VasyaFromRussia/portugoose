import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:portugoose/common/ui/action_button.dart';
import 'package:portugoose/common/ui/card.dart';
import 'package:portugoose/common/ui/keyboard.dart';
import 'package:portugoose/common/ui/palette.dart';
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
                          CardContainer(
                            height: 120,
                            color: Palette.grey100,
                            child: Text(
                              _word.ru,
                              style: buttonStyle.copyWith(color: Palette.grey900),
                            ),
                          ),
                          const SizedBox(height: 16),
                          CardContainer(
                            height: 120,
                            color: _answerState.color,
                            child: _answer.isEmpty
                                ? Text(
                                    "Translate the word",
                                    style: buttonStyle.copyWith(color: Palette.deepPurpleLite),
                                  )
                                : Text(
                                    _answer,
                                    style: buttonStyle.copyWith(color: Palette.grey100),
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
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                        decoration: const BoxDecoration(
                          color: Palette.grey100,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: ActionButton(
                          text: "Check",
                          color: Palette.deepPurple,
                          disabledColor: Palette.deepPurpleLite,
                          isEnabled: _canCheck,
                          onPressed: _canCheck ? _check : null,
                          textStyle: buttonStyle.copyWith(color: Palette.grey100),
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
        return Palette.deepPurple;
      case _AnswerState.correct:
        return Palette.green;
      case _AnswerState.wrong:
        return Palette.red;
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
