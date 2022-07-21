/////////////////////////////////////////////////////////////
////////////// Class Storage for FirebaseStorage ////////////
/////////////////////////////////////////////////////////////

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'dart:io';

/// custom Storage class with required functions to upload images to Firebase storage
class Storage{

  /// instantiating the storage object
  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  /// function to upload image from given file path to Firebase storage
  Future<void> uploadImageToFirebaseStorage(File path, String filename) async{
    try{

      await deleteAllFiles('test'); /// this function deletes all files previously stored on Firebase storage folder named 'test', comment this line if you want to keep previously uploaded images
      await storage.ref('test/$filename').putFile(path); /// uploads the file with the provided filename, replace 'test' with required folder name where image will be uploaded
    } on firebase_core.FirebaseException catch (e){
      print('Caught Error: ');
      print(e);
    }
  }

  /// Returns a list with all the uploaded images and their download URLs
  Future<List>  listFiles(String folderName) async{
    firebase_storage.ListResult results = await storage.ref(folderName).listAll();
    List<String> imageURLs = [];
    for(int i=0; i<results.items.length;i++){
      String imageName = results.items[i].fullPath.split('/').last;
      String imageURL = await downloadURL(folderName,imageName);
      imageURLs.add(imageURL);
    }
    return [results, imageURLs];
  }

  /// function that deletes all files in the provided folder
  Future<void> deleteAllFiles(String folderName) async{
    firebase_storage.ListResult results = await storage.ref(folderName).listAll();
    for(int i=0; i<results.items.length;i++){
      String imageName = results.items[i].fullPath.split('/').last;
      String imageURL = await downloadURL(folderName,imageName);
      firebase_storage.FirebaseStorage.instance.refFromURL(imageURL).delete();
    }
  }

  /// function that fetches the download URL of the images uploaded on Firebase storage
  Future<String> downloadURL(String folderName, String imageName) async {
    String downloadURL = await storage.ref('$folderName/$imageName').getDownloadURL();
    return downloadURL;
  }
}

