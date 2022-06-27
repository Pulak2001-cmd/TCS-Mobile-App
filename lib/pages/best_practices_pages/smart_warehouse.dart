import 'package:flutter/material.dart';

class SmartWarehousePage extends StatelessWidget {
  const SmartWarehousePage({Key? key}) : super(key: key);

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
          title: Text('Smart Warehouse',
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
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Image.asset('assets/images/best_practices/smart_warehouse/smartwarehouse.jpeg'),
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
