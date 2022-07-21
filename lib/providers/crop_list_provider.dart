////////////////////////////////////////////////////////
////// Provider for list of CropStatus objects /////////
////////////////////////////////////////////////////////

import 'package:flutter/material.dart';

import '../models/crop_status_model.dart';

class CropListProvider with ChangeNotifier{
  List<CropStatus> cropStatusList = [
  ];

  /// add a CropStatus object to the list
  void addCropStatus(CropStatus cropStatus){
    cropStatusList.add(cropStatus);
    notifyListeners();
  }

  /// remove an item from the list
  void removeAt(int index){
    cropStatusList.removeAt(index);
    notifyListeners();
  }
}