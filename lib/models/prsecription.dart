import 'package:uuid/uuid.dart';

class Prescription {
  String id = Uuid().v1();
  String relatedTreatmentId;
  Patient patient;
  Prescriber prescriber;
  String sickness;
  List<Medication> meds;

  Prescription(
      {this.relatedTreatmentId, this.meds, this.prescriber, this.sickness}) {
    if (prescriber == null) prescriber = Prescriber();
    if (meds == null) meds = [];
    if (sickness == null) sickness = 'unknown';
  }
}

class Prescriber {
  Prescriber({this.name}) {
    if (name == null) name = 'Unknown';
  }
  String name;
}

class Patient {
  String name;
  int age;
  Gender gender;

  Patient({this.name, this.age, this.gender}) {
    name = name ?? 'unknown';
    age = age ?? 0;
    gender = gender ?? Gender.unknown;
  }
}

enum Gender { unknown, male, female }

class Medication {
  MedType medType;
  Recipie recipie;

  Medication(this.recipie);
}

enum MedType { tab, inj }

class Recipie {
  Tablet tablet;
  Injection injection;
  SignatureType sigType;
  Signature sig;

  Recipie.tablet(this.tablet, this.sig);
  Recipie.injection(this.injection, this.sig);
}

enum SignatureType { any, two, three, four }

class Signature {
  int anytime;
  int morning;
  int noon;
  int afternoon;
  int evening;
  int night;

  Signature(this.anytime);

  Signature.two({this.morning, this.night});

  Signature.three({this.morning, this.afternoon, this.night});

  Signature.four({this.morning, this.noon, this.evening, this.night});
}

class Tablet {
  String name;

  Tablet(this.name);
}

class Injection {
  String name;

  Injection(this.name);
}
