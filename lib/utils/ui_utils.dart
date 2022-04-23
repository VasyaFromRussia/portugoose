import 'package:portugoose/verb/verb_provider.dart';

extension VerbExtensions on VerbForm {
  String get pronouns {
    switch (number) {
      case Number.singular:
        switch (person) {
          case Person.first:
            return "Eu";
          case Person.second:
            return "Tu";
          case Person.third:
            return "Ele/Ela/Você";
        }
      case Number.plural:
        switch (person) {
          case Person.first:
            return "Nós";
          case Person.second:
            throw InvalidForm();
          case Person.third:
            return "Eles/Elas/Vocês";
        }
    }
  }
}

class InvalidForm implements Exception {}
