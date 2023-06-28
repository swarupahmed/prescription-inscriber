import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prescription/models/prsecription.dart';
import 'package:prescription/widgets/medic_Form_Adder.dart';
import 'package:prescription/widgets/treatment_provider.dart';

import 'calculator.dart';

class PrescriptionBody extends StatelessWidget {
  final int index;

  const PrescriptionBody(this.index);

  @override
  Widget build(BuildContext context) {
    var pres = context.read(prescriptionProv(index)).prescription;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('#' + pres.id.split('-').last),
                  CalculatorIcon(index: index),
                ],
              ),
              PrescriptionData(pres: pres),
              MedicationListWidget(
                prescriptionIndex: index,
              ),
              MedicationAdder(
                index: index,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrescriptionData extends StatelessWidget {
  const PrescriptionData({
    Key key,
    @required this.pres,
  }) : super(key: key);

  final Prescription pres;

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(builder: (context) {
            if (mq <= 500) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Prescriber: ${pres.prescriber.name}'),
                  Text('Sickness : ${pres.sickness}'),
                ],
              );
            } else {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Prescriber: ${pres.prescriber.name}'),
                  SizedBox(width: 10),
                  Text('Sickness : ${pres.sickness}'),
                ],
              );
            }
          }),
        ],
      ),
    );
  }
}

class MedicationListWidget extends StatelessWidget {
  final int prescriptionIndex;

  const MedicationListWidget({Key key, this.prescriptionIndex})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer(builder: (context, watch, child) {
        var _prescription = watch(prescriptionProv(prescriptionIndex));

        return _prescription.prescription.meds.isEmpty
            ? Container(
                child: Text('No Medications'),
              )
            : Column(
                children: _prescription.prescription.meds
                    .map((med) => _MedItem(med: med))
                    .toList(),
              );
      }),
    );
  }
}

class _MedItem extends StatelessWidget {
  final Medication med;
  const _MedItem({Key key, @required this.med}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        trailing: _sigRoutine(med),
        leading: CircleAvatar(
            maxRadius: 17,
            backgroundColor: Colors.blue.shade300,
            child: Text('tab', textScaleFactor: 0.95)),
        title: Text(med.recipie.tablet.name),
      ),
    );
  }

  Widget _sigRoutine(Medication med) {
    return Text(med.recipie.sig.morning.toString() +
        ' + ' +
        med.recipie.sig.afternoon.toString() +
        ' + ' +
        med.recipie.sig.night.toString());
  }
}

var medicationAdderFormState = StateProvider<bool>((ref) => false);

class MedicationAdder extends StatefulWidget {
  final int index;

  const MedicationAdder({Key key, @required this.index}) : super(key: key);
  @override
  _MedicationAdderState createState() => _MedicationAdderState();
}

class _MedicationAdderState extends State<MedicationAdder> {
  bool formState = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: formState
          ? MedicAdderForm(
              changeFormState: () {
                setState(() => formState = false);
              },
              index: widget.index,
            )
          : MedicAdderButton(changeButtonState: () {
              setState(() => formState = true);
            }),
    );
  }
}
