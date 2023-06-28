import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prescription/models/prsecription.dart';
import 'package:prescription/widgets/treatment_provider.dart';

class MedicAdderButton extends StatelessWidget {
  final Function changeButtonState;

  MedicAdderButton({Key key, this.changeButtonState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: changeButtonState,
      icon: Icon(Icons.add),
    );
  }
}

class MedicAdderForm extends StatefulWidget {
  final int index;
  final Function changeFormState;

  const MedicAdderForm({Key key, this.changeFormState, @required this.index})
      : super(key: key);
  @override
  _MedicAdderFormState createState() => _MedicAdderFormState();
}

class _MedicAdderFormState extends State<MedicAdderForm> {
  final tabletCtrl = TextEditingController();
  final sigCtrl = TextEditingController();

  @override
  void dispose() {
    tabletCtrl.dispose();
    sigCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _prescription = context.read(prescriptionProv(widget.index));

    return Row(
      children: [
        Flexible(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                //Add validation later
                controller: tabletCtrl,
                decoration:
                    InputDecoration(helperText: 'Tablet', hintText: 'name'),
              ),
            )),
        Flexible(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                //Add validation later
                controller: sigCtrl,
                decoration:
                    InputDecoration(helperText: 'Signature', hintText: '0 0 0'),
              ),
            )),
        Flexible(
          flex: 1,
          child: IconButton(
            onPressed: () {
              if (tabletCtrl.text != '' && int.tryParse(sigCtrl.text) != null) {
                _prescription.addMedication(
                  makeMed(tabletCtrl.text, sigCtrl.text),
                );
                widget.changeFormState();
              }
            },
            icon: Icon(Icons.check),
          ),
        ),
        Flexible(
          flex: 1,
          child: IconButton(
              icon: Icon(Icons.cancel_outlined),
              onPressed: widget.changeFormState),
        )
      ],
    );
  }
}

Medication makeMed(String tablet, String sig) {
  return Medication(Recipie.tablet(Tablet(tablet), parseSignature(sig)));
}

Signature parseSignature(String sig) {
  var signature = Signature.three();
  var chars = sig.split('').map(int.parse).toList();
  // if (chars.length < 3) {
  //   if (chars.length == 2) {
  //     chars.insert(1, 0);
  //   } else
  //     chars.addAll([0, 0]);
  // }
  signature.morning = chars[0];
  signature.afternoon = chars[1];
  signature.night = chars[2];
  return signature;
}
