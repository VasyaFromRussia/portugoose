import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portugoose/utils/ui_utils.dart';
import 'package:portugoose/verb/verb_provider.dart';

class VerbTrainerWidget extends ConsumerWidget {
  VerbTrainerWidget({Key? key}) : super(key: key);

  static const _cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(16)),
    boxShadow: [
      BoxShadow(
        color: Color(0x20000000),
        blurRadius: 8,
        offset: Offset(0, 5),
      ),
    ],
  );

  static const _iconCorrect = Icon(
    Icons.check,
    color: Color(0xFF70CDAE),
  );

  static const _iconWrong = Icon(
    Icons.close,
    color: Color(0xFFD66D4B),
  );

  final _buttonStyle = ElevatedButton.styleFrom(
    primary: const Color(0xFFF5DB71),
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  final _textEditingControllers = <VerbForm, TextEditingController>{};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(verbProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: state.index / state.total,
                minHeight: 10,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: _cardDecoration,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        state.verb.infinitive,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                    Table(
                      columnWidths: const {
                        0: FractionColumnWidth(0.3),
                        2: FixedColumnWidth(50),
                      },
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: validForms.map((form) {
                        final remarks = state.remarks;
                        final isCorrect = remarks != null ? !remarks.containsKey(form) : null;
                        return _buildFormRow(context, form, isCorrect);
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  final notifier = ref.read(verbProvider.notifier);
                  if (state.isPassed) {
                    _textEditingControllers.values.forEach((element) => element.text = "");
                    notifier.next();
                  } else {
                    notifier.verify(_textEditingControllers.map((key, value) => MapEntry(key, value.text)));
                  }
                },
                child: Text(
                  state.isPassed ? "Next" : "Check",
                  style: Theme.of(context).textTheme.button,
                ),
                style: _buttonStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildFormRow(BuildContext context, VerbForm form, bool? isCorrect) => TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              form.pronouns,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: TextField(
              controller: _textEditingControllers.putIfAbsent(form, () => TextEditingController()),
              style: Theme.of(context).textTheme.headline4,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0x88FBE8D4),
                contentPadding: EdgeInsets.all(4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Container(child: isCorrect != null ? (isCorrect ? _iconCorrect : _iconWrong) : Container()),
        ],
      );
}
