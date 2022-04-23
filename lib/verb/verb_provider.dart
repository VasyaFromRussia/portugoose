import 'package:flutter_riverpod/flutter_riverpod.dart';

final verbProvider = StateNotifierProvider<VerbTrainer, VerbState>(
  (ref) => VerbTrainer(
    VerbState(
      verb: const Verb(
        infinitive: "beber",
        conjugation: Conjugation.second,
      ),
    ),
  ),
);

class VerbTrainer extends StateNotifier<VerbState> {
  VerbTrainer(VerbState state) : super(state);

  void verify(Map<VerbForm, String> forms) {
    final validForms = state.verb.conjugate();
    final remarks = Map.fromEntries(validForms.entries.where((element) => element.value != forms[element.key]));
    state = VerbState(verb: state.verb, remarks: remarks);
  }
}

class VerbState {
  VerbState({
    required this.verb,
    this.remarks,
  });

  final Verb verb;
  final Map<VerbForm, String>? remarks;
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
    final withoutEnding = infinitive.substring(0, infinitive.length - conjugation.infinitiveEnding.length);
    return conjugation.presentEndings.map((form, ending) => MapEntry(form, "$withoutEnding$ending"));
  }
}

enum Conjugation { first, second, third }

extension ConjugationExtension on Conjugation {
  String get infinitiveEnding {
    switch (this) {
      case Conjugation.first:
        return "or";
      case Conjugation.second:
        return "er";
      case Conjugation.third:
        return "ir";
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
