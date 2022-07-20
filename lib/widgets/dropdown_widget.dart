import 'package:flutter/material.dart';

Widget DropdownWidget({required List<String> itemList, required String dropdownValue, required Function(String) notifyParent , Function(String)? setValue}){

  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.white38),
      borderRadius: BorderRadius.circular(8),
    ),
    padding: EdgeInsets.symmetric(horizontal: 8),
    child: DropdownButton<String>(
      value: dropdownValue,
      isExpanded: true,
      underline: Container(
        color: Colors.transparent,
      ),
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 0,
      dropdownColor: Colors.grey[900],
      style: const TextStyle(color: Colors.white70),
      onChanged: (String? newValue) async{
        dropdownValue = newValue!;
        notifyParent(dropdownValue);
        setValue!(dropdownValue);
      },
      items: itemList
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    ),
  );
}
