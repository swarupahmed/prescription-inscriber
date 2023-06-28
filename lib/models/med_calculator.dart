import 'package:prescription/models/prsecription.dart';

class MedCalculator {
  List<_MedAvailable> availables;
  int remainingDays;

  MedCalculator({this.availables, this.remainingDays}) {
    if (availables == null) availables = [];
  }

  List<MedNeeded> calcNeeded() {
    var needed = availables.map((e) => _singledayCalc(e)).toList();

    return needed;
  }

  MedNeeded _singledayCalc(_MedAvailable available) {
    int _needed =
        dailyMedsTotal(available.med) * remainingDays - available.available;
    return MedNeeded(available.med, _needed);
  }

  int dailyMedsTotal(Medication med) {
    //MAYBE do it by Looping
    return med.recipie.sig.morning +
        med.recipie.sig.afternoon +
        med.recipie.sig.night;
  }

  addAvailable(Medication med, int available) {
    availables.add(_MedAvailable(med, available));
  }
}

class _MedAvailable {
  final Medication med;
  final int available;

  _MedAvailable(this.med, this.available);
}

class MedNeeded {
  final Medication med;
  final int needed;

  MedNeeded(this.med, this.needed);
}
