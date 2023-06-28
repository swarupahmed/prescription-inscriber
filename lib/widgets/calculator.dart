import 'package:flutter/material.dart';
import 'package:prescription/models/med_calculator.dart';
import 'package:prescription/models/prsecription.dart';
import 'package:prescription/widgets/treatment_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalculatorIcon extends StatelessWidget {
  final int index;

  const CalculatorIcon({Key key, @required this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CalculatePage(
                    index: index,
                  ))),
      icon: Icon(
        Icons.calculate,
        color: Colors.blueGrey,
        size: 26,
      ),
    );
  }
}

class CalculatePage extends StatelessWidget {
  final int index;

  const CalculatePage({Key key, @required this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculate'),
        actions: [],
      ),
      body: CalcForms(
        index: index,
      ),
    );
  }
}

class MedAvailableInput extends StatefulWidget {
  final Medication med;
  final TextEditingController controller;

  const MedAvailableInput({this.med, this.controller});
  @override
  _MedAvailableInputState createState() => _MedAvailableInputState();
}

class _MedAvailableInputState extends State<MedAvailableInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: Text(
                widget.med.recipie.tablet.name,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                  child: Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 20),
                child: TextField(controller: widget.controller),
              )),
            ),
          ],
        ),
      ),
    );
  }
}

class CalcForms extends StatefulWidget {
  final int index;

  const CalcForms({Key key, @required this.index}) : super(key: key);
  @override
  _CalcFormsState createState() => _CalcFormsState();
}

class _CalcFormsState extends State<CalcForms> {
  @override
  Widget build(BuildContext context) {
    var meds =
        context.read(allPrescriptionsProv).prescriptions[widget.index].meds;
    var controllers = <TextEditingController>[];
    TextEditingController totaldaysController = TextEditingController();

    meds.forEach((element) {
      controllers.add(TextEditingController());
    });

    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Column(
                children: meds
                    .asMap()
                    .entries
                    .map((entry) => MedAvailableInput(
                          med: entry.value,
                          controller: controllers[entry.key],
                        ))
                    .toList()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: totaldaysController,
                keyboardType: TextInputType.number,
                decoration:
                    InputDecoration(hintText: '0', helperText: 'Until (days)'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 120,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    var remainingDays = int.tryParse(totaldaysController.text);
                    if (remainingDays != null) {
                      var medcalc = MedCalculator(remainingDays: remainingDays);
                      meds.asMap().forEach((i, med) {
                        medcalc.addAvailable(
                            med, int.parse(controllers[i].text));
                      });
                      pushPage(context,
                          MedNeededList(neededs: medcalc.calcNeeded()));
                    }
                  },
                  child: Row(children: [
                    Icon(Icons.calculate),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Calculate',
                      style: TextStyle(fontSize: 16),
                    ),
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

pushPage(BuildContext context, Widget page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

class MedNeededList extends StatelessWidget {
  final List<MedNeeded> neededs;

  const MedNeededList({Key key, this.neededs}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prescription'),
      ),
      body: Container(
        child: Column(
          children: neededs.map((e) => AvailablePage(medNeeded: e)).toList(),
        ),
      ),
    );
  }
}

class AvailablePage extends StatelessWidget {
  final MedNeeded medNeeded;

  const AvailablePage({Key key, this.medNeeded}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
      child: ListTile(
        title: Text(medNeeded.med.recipie.tablet.name),
        trailing: Text(medNeeded.needed.toString()),
      ),
    ));
  }
}
