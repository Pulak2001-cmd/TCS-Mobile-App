import 'package:flutter/material.dart';

import '../models/crop_status_model.dart';

class CropListProvider with ChangeNotifier{
  List<CropStatus> cropStatusList = [
  ];

  void addCropStatus(CropStatus cropStatus){
    cropStatusList.add(cropStatus);
    notifyListeners();
  }

  void removeAt(int index){
    cropStatusList.removeAt(index);
    notifyListeners();
  }
}