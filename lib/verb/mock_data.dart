import 'package:portugoose/verb/verb_provider.dart';

const verbs = [
  Verb(
    infinitive: "ser",
    conjugation: Conjugation.irregular,
    exclusions: {
      VerbForm(number: Number.singular, person: Person.first): "sou",
      VerbForm(number: Number.singular, person: Person.second): "és",
      VerbForm(number: Number.singular, person: Person.third): "é",
      VerbForm(number: Number.plural, person: Person.first): "somos",
      VerbForm(number: Number.plural, person: Person.third): "são",
    },
  ),
  Verb(
    infinitive: "ter",
    conjugation: Conjugation.irregular,
    exclusions: {
      VerbForm(number: Number.singular, person: Person.first): "tenho",
      VerbForm(number: Number.singular, person: Person.second): "tens",
      VerbForm(number: Number.singular, person: Person.third): "tem",
      VerbForm(number: Number.plural, person: Person.first): "temos",
      VerbForm(number: Number.plural, person: Person.third): "têm",
    },
  ),
  Verb(
    infinitive: "estar",
    conjugation: Conjugation.irregular,
    exclusions: {
      VerbForm(number: Number.singular, person: Person.first): "estou",
      VerbForm(number: Number.singular, person: Person.second): "estás",
      VerbForm(number: Number.singular, person: Person.third): "está",
      VerbForm(number: Number.plural, person: Person.first): "estamos",
      VerbForm(number: Number.plural, person: Person.third): "estão",
    },
  ),
  Verb(
    infinitive: "poder",
    conjugation: Conjugation.second,
    exclusions: {
      VerbForm(number: Number.singular, person: Person.first): "posso",
    },
  ),
  Verb(
    infinitive: "fazer",
    conjugation: Conjugation.second,
    exclusions: {
      VerbForm(number: Number.singular, person: Person.first): "faço",
      VerbForm(number: Number.singular, person: Person.third): "faz",
    },
  ),
  Verb(
    infinitive: "ir",
    conjugation: Conjugation.irregular,
    exclusions: {
      VerbForm(number: Number.singular, person: Person.first): "vou",
      VerbForm(number: Number.singular, person: Person.second): "vais",
      VerbForm(number: Number.singular, person: Person.third): "vai",
      VerbForm(number: Number.plural, person: Person.first): "vamos",
      VerbForm(number: Number.plural, person: Person.third): "vão",
    },
  ),
  Verb(
    infinitive: "haver",
    conjugation: Conjugation.second,
    exclusions: {
      VerbForm(number: Number.singular, person: Person.first): "hei",
      VerbForm(number: Number.singular, person: Person.second): "hás",
      VerbForm(number: Number.singular, person: Person.third): "há",
      VerbForm(number: Number.plural, person: Person.first): "haveis",
      VerbForm(number: Number.plural, person: Person.third): "hão",
    },
  ),
  Verb(
    infinitive: "dizer",
    conjugation: Conjugation.second,
    exclusions: {
      VerbForm(number: Number.singular, person: Person.first): "digo",
      VerbForm(number: Number.singular, person: Person.third): "diz",
    },
  ),
  Verb(
    infinitive: "dar",
    conjugation: Conjugation.irregular,
    exclusions: {
      VerbForm(number: Number.singular, person: Person.first): "dou",
      VerbForm(number: Number.singular, person: Person.second): "dás",
      VerbForm(number: Number.singular, person: Person.third): "dá",
      VerbForm(number: Number.plural, person: Person.first): "damos",
      VerbForm(number: Number.plural, person: Person.third): "dão",
    },
  ),
  Verb(
    infinitive: "ver",
    conjugation: Conjugation.second,
    exclusions: {
      VerbForm(number: Number.singular, person: Person.first): "vejo",
      VerbForm(number: Number.singular, person: Person.second): "vês",
      VerbForm(number: Number.singular, person: Person.third): "vê",
      VerbForm(number: Number.plural, person: Person.third): "veêm",
    },
  ),
  Verb(
    infinitive: "saber",
    conjugation: Conjugation.second,
    exclusions: {
      VerbForm(number: Number.singular, person: Person.first): "sei",
    },
  ),
  Verb(
    infinitive: "querer",
    conjugation: Conjugation.second,
    exclusions: {
      VerbForm(number: Number.singular, person: Person.third): "quer",
    },
  ),
];
