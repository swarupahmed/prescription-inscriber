import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prescription/widgets/calculator.dart';
import 'package:prescription/widgets/prescription_body.dart';
import 'package:prescription/widgets/prescription_creator.dart';
import 'package:prescription/widgets/treatment_provider.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ma\'s Prescription',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prescription'),
      ),
      body: AllPrescriptionsPage(),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Treatments'),
              onTap: () {
                pushPage(context, TreatmentsListPage());
              },
            )
          ],
        ),
      ),
      floatingActionButton: SizedFloatingButton(
        label: 'Prescription',
        icon: Icon(Icons.add),
        fontSize: 18,
        onPressed: () {
          pushPage(context, PrescriptionCreatorPage());
        },
      ),
    );
  }
}

class TreatmentsListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var treats = watch(allTreatmentsProv).treatments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Treatments'),
        actions: [IconButton(icon: Icon(Icons.add), onPressed: () {})],
      ),
      body: ListView.builder(
          itemCount: treats.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  title: Text(treats[index].title),
                ),
                Divider()
              ],
            );
          }),
    );
  }
}

class SizedFloatingButton extends StatelessWidget {
  final double fontSize;
  final Icon icon;
  final Function onPressed;
  final String label;
  const SizedFloatingButton({
    Key key,
    @required this.fontSize,
    @required this.icon,
    @required this.onPressed,
    @required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: FittedBox(
        child: FloatingActionButton.extended(
          icon: icon,
          label: Text(
            label,
            style: TextStyle(fontSize: fontSize),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class AllPrescriptionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: Container(
          child: Consumer(builder: (context, watch, child) {
            var treatPres = watch(allPrescriptionsProv).prescriptions;
            return treatPres.isEmpty
                ? Text('No Prescriptions')
                : Column(
                    children: treatPres
                        .asMap()
                        .entries
                        .map((e) => PrescriptionBody(e.key))
                        .toList(),
                  );
          }),
        ),
      ),
    );
  }
}
