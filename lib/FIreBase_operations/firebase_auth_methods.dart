

import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tab_bar/FIreBase_operations/firebase_storage_methods.dart';
import 'package:tab_bar/Models/user_model.dart' as model;
import 'package:tab_bar/Models/user_model.dart';

class FirebaseAuthMethods {

   final FirebaseAuth _firebaseauth=FirebaseAuth.instance;
   final FirebaseFirestore _firestore=FirebaseFirestore.instance;

   Future<model.UserModel> getUserDetails() async {
   User currentUser= _firebaseauth.currentUser!;
   DocumentSnapshot snapshot= await _firestore.collection("users").doc(currentUser.uid).get();

   return model.UserModel.fromSnap(snapshot);
}

  Future<String> signIn(String email,String password,String id,Uint8List  image,String bio,String name) async{

    String res="some error occurred";
        try {
          print("this is subhash");
          UserCredential cred = await _firebaseauth.createUserWithEmailAndPassword(
            email: email,
            password: password,);
          String ? profileUrl= await FirebaseStorageMethods().addPics('profile_pics', image, false);
          profileUrl=profileUrl ??"";
          var user= model.UserModel(name: name.toLowerCase(), email: email, userId: id, profileUrl:profileUrl, bio: bio, uid:cred.user!.uid, followers:[], following: []);
          await _firestore.collection("users").doc(cred.user?.uid.toString()).set(user.toJson()).then( (value) {
        print("success");
      }).onError((error, stackTrace){
        print(stackTrace.toString());
     });
      res="success";
    } on FirebaseAuthException catch (e) {
          print(e.stackTrace);
      res=e.code.toString().toLowerCase();
    } catch (e) {
      res=e.toString().toLowerCase();
    }
    return res;
  }
  Future<String> logIn(String email,String password) async{
    String res="some error occurred";
    try {
      UserCredential credential = await _firebaseauth.signInWithEmailAndPassword(
        email: email,
        password: password,);

      res="success";
    } on FirebaseAuthException catch (e) {
      res=e.code.toString().toLowerCase();
    } catch (e) {
      res=e.toString().toLowerCase();
    }
    return res;
  }
  Future<bool> logOut()async{
    try{
      await FirebaseAuth.instance.signOut();
      return true;
    }catch(e)
    {
      return false;
    }
  }

}