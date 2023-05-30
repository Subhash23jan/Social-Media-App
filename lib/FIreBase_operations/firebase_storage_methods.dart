
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageMethods{
 final FirebaseStorage firebaseStorage=FirebaseStorage.instance;
 final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

 Future<String ?> addPics(String childName,Uint8List file,bool isPost) async{
  Reference reference= firebaseStorage.ref().child(childName).child(_firebaseAuth.currentUser!.uid);
    if(isPost)
   {
       String id= const Uuid().v1();
       reference=reference.child(id);
   }
   UploadTask task=  reference.putData(file);
   TaskSnapshot snapshot=await task;
   String? url=await snapshot.ref.getDownloadURL();
   if(url==null) {
     return " ";
   }
   return url;
 }
}