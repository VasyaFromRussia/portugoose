import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portugoose/verb/mock_data.dart';

final verbProvider = StateNotifierProvider<VerbTrainer, VerbState>(
  (ref) => VerbTrainer(),
);

class VerbTrainer extends StateNotifier<VerbState> {
  VerbTrainer() : super(VerbState(verb: verbs.first, index: 0, total: verbs.length));

  var currentIndex = 0;

  void next() {
    currentIndex++;
    if (currentIndex < verbs.length) {
      state = VerbState(verb: verbs[currentIndex], index: currentIndex, total: verbs.length);
    }
  }

  void verify(Map<VerbForm, String> forms) {
    final validForms = state.verb.conjugate();
    final remarks = Map.fromEntries(
      validForms.entries.where((element) => element.value.normalized != forms[element.key]?.normalized),
    );
    state = VerbState(verb: state.verb, index: state.index, total: state.total, remarks: remarks);
  }
}

class VerbState {
  VerbState({
    required this.verb,
    required this.index,
    required this.total,
    this.remarks,
  });

  final Verb verb;
  final Map<VerbForm, String>? remarks;
  final index;
  final total;
}

extension VerbStateExtensions on VerbState {
  bool get isPassed => remarks?.isEmpty == true;
}

class Verb {
  const Verb({
    required this.infinitive,
    required this.conjugation,
    this.exclusions = const {},
  });

  final String infinitive;
  final Conjugation conjugation;
  final Map<VerbForm, String> exclusions;

  Map<VerbForm, String> conjugate() {
    var result = <VerbForm, String>{};
    if (conjugation != Conjugation.irregular) {
      final withoutEnding = infinitive.substring(0, infinitive.length - conjugation.infinitiveEnding.length);
      result = conjugation.presentEndings.map((form, ending) => MapEntry(form, "$withoutEnding$ending"));
    }

    exclusions.forEach((key, value) {
      result[key] = value;
    });

    return result;
  }
}

enum Conjugation { first, second, third, irregular }

extension ConjugationExtension on Conjugation {
  String get infinitiveEnding {
    switch (this) {
      case Conjugation.first:
        return "or";
      case Conjugation.second:
        return "er";
      case Conjugation.third:
        return "ir";
      case Conjugation.irregular:
        throw IrregularVerbException();
    }
  }

  Map<VerbForm, String> get presentEndings {
    switch (this) {
      case Conjugation.first:
        return const {
          VerbForm(number: Number.singular, person: Person.first): "o",
          VerbForm(number: Number.singular, person: Person.second): "as",
          VerbForm(number: Number.singular, person: Person.third): "a",
          VerbForm(number: Number.plural, person: Person.first): "amos",
          VerbForm(number: Number.plural, person: Person.third): "am",
        };
      case Conjugation.second:
        return const {
          VerbForm(number: Number.singular, person: Person.first): "o",
          VerbForm(number: Number.singular, person: Person.second): "es",
          VerbForm(number: Number.singular, person: Person.third): "e",
          VerbForm(number: Number.plural, person: Person.first): "emos",
          VerbForm(number: Number.plural, person: Person.third): "em",
        };
      case Conjugation.third:
        return const {
          VerbForm(number: Number.singular, person: Person.first): "o",
          VerbForm(number: Number.singular, person: Person.second): "es",
          VerbForm(number: Number.singular, person: Person.third): "a",
          VerbForm(number: Number.plural, person: Person.first): "amos",
          VerbForm(number: Number.plural, person: Person.third): "am",
        };
      case Conjugation.irregular:
        throw IrregularVerbException();
    }
  }
}

enum Number { singular, plural }

enum Person { first, second, third }

class VerbForm {
  const VerbForm({
    required this.number,
    required this.person,
  });

  final Number number;
  final Person person;
}

const validForms = [
  VerbForm(number: Number.singular, person: Person.first),
  VerbForm(number: Number.singular, person: Person.second),
  VerbForm(number: Number.singular, person: Person.third),
  VerbForm(number: Number.plural, person: Person.first),
  VerbForm(number: Number.plural, person: Person.third),
];

class IrregularVerbException implements Exception {}

extension on String {
  String get normalized => trim().toLowerCase();
}
