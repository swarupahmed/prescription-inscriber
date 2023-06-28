import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prescription/main.dart';
import 'package:prescription/models/prsecription.dart';
import 'package:prescription/widgets/treatment_provider.dart';

class PrescriptionCreatorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var prescriberCtrl = TextEditingController();
    var sicknessCtrl = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Prescription'),
      ),
      body: Column(
        children: [
          Flexible(
              child:
                  CreatorForm(controller: prescriberCtrl, hint: 'Prescriber')),
          Flexible(
              child: CreatorForm(controller: sicknessCtrl, hint: 'Sickness')),
          SizedFloatingButton(
            label: 'Save',
            icon: Icon(Icons.save),
            fontSize: 16,
            onPressed: () {
              if (prescriberCtrl.text != '') {
                context.read(allPrescriptionsProv).addPrescription(Prescription(
                    prescriber: Prescriber(name: prescriberCtrl.text),
                    sickness: sicknessCtrl.text));
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
    );
  }
}

class CreatorForm extends StatefulWidget {
  final TextEditingController controller;
  final String hint;

  CreatorForm({@required this.controller, @required this.hint});
  @override
  _CreatorFormState createState() => _CreatorFormState();
}

class _CreatorFormState extends State<CreatorForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: TextField(
          controller: widget.controller,
          decoration:
              InputDecoration(hintText: widget.hint, labelText: widget.hint),
        ),
      ),
    );
  }
}
