import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'dart:io';

class Storage{
  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  Future<void> uploadImageToFirebaseStorage(File path, String filename) async{
    try{
      await deleteAllFiles();
      await storage.ref('test/$filename').putFile(path);
    } on firebase_core.FirebaseException catch (e){
      print('Caught Error: ');
      print(e);
    }
  }

  Future<List>  listFiles() async{
    firebase_storage.ListResult results = await storage.ref('test').listAll();
    List<String> imageURLs = [];
    for(int i=0; i<results.items.length;i++){
      String imageName = results.items[i].fullPath.split('/').last;
      String imageURL = await downloadURL(imageName);
      imageURLs.add(imageURL);
    }
    return [results, imageURLs];
  }

  Future<void> deleteAllFiles() async{
    firebase_storage.ListResult results = await storage.ref('test').listAll();
    List<String> imageURLs = [];
    for(int i=0; i<results.items.length;i++){
      String imageName = results.items[i].fullPath.split('/').last;
      String imageURL = await downloadURL(imageName);
      firebase_storage.FirebaseStorage.instance.refFromURL(imageURL).delete();
    }
  }

  Future<String> downloadURL(String imageName) async {
    String downloadURL = await storage.ref('test/$imageName').getDownloadURL();
    return downloadURL;
  }
}

