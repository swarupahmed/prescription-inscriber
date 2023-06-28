import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prescription/models/prsecription.dart';
import 'package:prescription/models/treatment.dart';
import 'package:prescription/widgets/medic_Form_Adder.dart';

var allTreatmentsProv = ChangeNotifierProvider<AllTreatmentsProvider>((ref) {
  var prov = AllTreatmentsProvider();
  if (prov.treatments.isEmpty) prov.treatments.add(Treatment('My Treatment'));
  return prov;
});

var allPrescriptionsProv =
    ChangeNotifierProvider<AllPrescriptionsProvider>((ref) {
  var prov = AllPrescriptionsProvider();
  if (prov.prescriptions.isEmpty) prov.prescriptions.add(presSchizophrenia());
  return prov;
});

var prescriptionProv =
    ChangeNotifierProvider.family<PrescriptionProvider, int>((ref, id) {
  var treatp = ref.watch(allPrescriptionsProv).prescriptions;
  PrescriptionProvider pres;
  if (treatp.isEmpty) treatp.add(Prescription());
  pres = PrescriptionProvider(treatp[id]);
  return pres;
});

class AllTreatmentsProvider extends ChangeNotifier {
  List<Treatment> treatments = [];
}

class AllPrescriptionsProvider extends ChangeNotifier {
  List<Prescription> prescriptions = [];

  addPrescription(Prescription prescription) {
    prescriptions.add(prescription);
    notifyListeners();
  }
}

class PrescriptionProvider extends ChangeNotifier {
  Prescription prescription;
  PrescriptionProvider(this.prescription);

  void addMedication(Medication med) {
    prescription.meds.add(med);
    notifyListeners();
  }
}

Prescription presSchizophrenia() {
  var p = Prescription(
      prescriber: Prescriber(name: 'Dr Moksed Ali'), sickness: 'Schizophrenia');
  p.meds.add(makeMed('Halopid', '224'));
  p.meds.add(makeMed('Opsonil', '112'));
  p.meds.add(makeMed('Perkinil', '101'));
  p.meds.add(makeMed('Frenia', '102'));
  return p;
}
