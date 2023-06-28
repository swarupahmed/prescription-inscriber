import 'package:uuid/uuid.dart';

class Treatment {
  final String id = Uuid().v1();
  String title;
  List<String> prescriptionIds;

  Treatment(this.title, {this.prescriptionIds}) {
    if (prescriptionIds == null) prescriptionIds = [];
  }
}
