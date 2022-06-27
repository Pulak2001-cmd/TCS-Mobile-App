import 'package:flutter/material.dart';

class SproutManagementPage extends StatelessWidget {
  const SproutManagementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: <Color>[
            Theme.of(context).primaryColor,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Sprout Management',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),),
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Table(
                  columnWidths: {
                    0: FractionColumnWidth(0.34),
                    1: FractionColumnWidth(0.66)
                  },
                  border: TableBorder.all(color: Colors.white70),
                  children: [
                    buildRow([
                      'Suprressant',
                      'Time of Application'
                    ], isHeader: true),
                    buildRow([
                      'CIPC',
                      'As a gas after curing is completed'
                    ]),
                    buildRow([
                      'Maelic Hydrazide',
                      'In the field during late full bloom to postbloom'
                    ]),
                    buildRow([
                      'Ethylene Treatment',
                      'As a gas and can be generated in the potato store'
                    ]),
                    buildRow([
                      'Carvone',
                      'At regular intervals during long-term storage'
                    ]),
                  ],
                ),
              )
            ),
          ),
        ),
      ),
    );


  }

  TableRow buildRow(List<String> cells, {bool isHeader = false}) => TableRow(
    children: cells.map((cell) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topLeft,
          child: Text(cell,
      style: TextStyle(
        fontWeight: isHeader ? FontWeight.bold: FontWeight.normal,
        color: isHeader ? Colors.white : Colors.white70,
      ),)),
    )).toList()
  );


}
