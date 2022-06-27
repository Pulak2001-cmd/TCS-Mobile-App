import 'package:flutter/material.dart';

class StorageProtocolPage extends StatelessWidget {
  const StorageProtocolPage({Key? key}) : super(key: key);

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
          title: Text('Storage Protocol',
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
                    border: TableBorder.all(color: Colors.white70),
                    children: [
                      buildRow([
                        'Parameter',
                        'Acceptable Range'
                      ], isHeader: true),
                      buildRow([
                        'Carbon Dioxide',
                        '<2500ppm>'
                      ]),
                      buildRow([
                        'Temperature - French fries',
                        '7-10°C'
                      ]),
                      buildRow([
                        'Temperature - Domestic Use',
                        '2- 4°C'
                      ]),
                      buildRow([
                        'Temperature - Chips',
                        '4-5°C'
                      ]),
                      buildRow([
                        'Temperature - Mashed Potato',
                        '5-7°C'
                      ]),
                      buildRow([
                        'Relative Humidity',
                        '85-90%'
                      ]),
                      buildRow([
                        'Light Intensity',
                        'No Light'
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
