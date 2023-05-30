
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tab_bar/screens/comment_screen.dart';

import '../Models/comment.dart';
import '../Models/post.dart';
import '../utils/usefulumethods.dart';
import 'package:tab_bar/FIreBase_operations/firebase_auth_methods.dart';
import 'package:tab_bar/FIreBase_operations/firebase_storage_methods.dart';
import 'package:uuid/uuid.dart';
class FirestoreMethods{
  final storage=FirebaseStorageMethods();
  final _firestore=FirebaseFirestore.instance;
  Future<String?>addPost(
      String username,
      String profile,
      Uint8List file,
      String uid,
      String desc,
      ) async{
    String res="error";
    try{
      String? url=await storage.addPics('profile', file, true);
      String postId=const Uuid().v1();
      Post post=Post(name: username, uid: uid, profileUrl: profile, postUrl: url!, postId: postId, desc: desc, dateTime:DateTime.now()
          , likes:[]);
      await _firestore.collection("posts").doc(postId).set(post.toJson());
      res="success";
    }catch(e)
    {
       res="error";
    }
    return res;
  }
  Future<void> updateLike(String postId,String uid,List likes)async{
    if(likes.contains(uid))
      {
        await FirebaseFirestore.instance.collection("posts").doc(postId).update({
              'likes':FieldValue.arrayRemove([uid])
            }
        );
      }else
        {
          await FirebaseFirestore.instance.collection("posts").doc(postId).update({
                'likes':FieldValue.arrayUnion([uid])
              });
        }
  }

  Future<void>addComments(Comment comment) async {

    try{
      await FirebaseFirestore.instance.collection("posts").doc(comment.postId).collection("comments").doc(comment.commentId).set(
          {
            'commenterPic':comment.commenterPic,
            'postId':comment.postId,
            'commenterName':comment.commenterName,
            'commenterUid':comment.commenterUid,
            'comment':comment.comment,
            'commentId':comment.commentId,
             'likes':comment.likes,
            'dateTime':comment.dateTime,
          });
    }catch(e)
    {
      print(e.toString());
    }
  }

  Future<void>deletePost(String postID) async{
    try{
      await FirebaseFirestore.instance.collection("posts").doc(postID).delete();
      print("success");
    }catch(e)
    {
      print(e.toString());
    }
  }

}