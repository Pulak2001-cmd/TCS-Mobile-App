import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/alert_provider.dart';



Widget buildSheet(ctx) {
  return StatefulBuilder(
    builder: (context, setState) => DraggableScrollableSheet(
      builder: (_,controller) =>
          Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: <Color>[
              Theme.of(ctx).primaryColor,
              Theme.of(ctx).colorScheme.secondary,
            ],
          ),
        ),
        child: ListView.builder(
            controller: controller,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            itemCount: Provider.of<AlertProvider>(context).getLength(),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white70),
                  borderRadius: BorderRadius.circular(5),
                ),
                width: MediaQuery
                    .of(ctx)
                    .size
                    .width * 0.9,
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Icon(FontAwesomeIcons.triangleExclamation,
                        color: Colors.red,),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text('${Provider.of<AlertProvider>(context).getAlert(index)['alertString']} \n ${DateFormat('d MMM, yy hh:mm aaa').format(Provider.of<AlertProvider>(context).getAlert(index)['timestamp'])}', style: TextStyle(
                        color: Colors.white70,
                      ),),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Provider.of<AlertProvider>(context, listen: false).removeAt(index);
                          });
                          Navigator.pop(context);
                          // setState((){});
                        },
                        child: Icon(Icons.cancel_outlined,
                          color: Colors.white70,),
                      ),
                    ),
                  ],
                ),
              );
              },
          ),
      ),
    ),
  );
}