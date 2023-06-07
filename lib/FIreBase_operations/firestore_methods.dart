

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:tab_bar/Models/user_model.dart';

import '../Models/comment.dart';
import '../Models/post.dart';
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
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void>deletePost(String postID) async{
    try{
      await FirebaseFirestore.instance.collection("posts").doc(postID).delete();
      if (kDebugMode) {
        print("success");
      }
    }catch(e)
    {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
  Future<void>addBookMarks(String userUid,String postId) async{
    await FirebaseFirestore.instance.collection("users").doc(userUid).collection("bookmarks").doc(postId).set({'id':postId});
  }
  Future<void>removeBookmarks(String userUid,String postUrl) async{
    await FirebaseFirestore.instance.collection("users").doc(userUid).collection("bookmarks").doc(postUrl).delete();
  }
  Future<void>addFollowers(String follower,String following)async{
    await FirebaseFirestore.instance.collection("users").doc(follower).update({
      'following':FieldValue.arrayUnion([following])
    });
    await FirebaseFirestore.instance.collection("users").doc(following).update({
      'followers':FieldValue.arrayUnion([follower])
    });
  }
  Future<void>removeFollower(String follower,String following)async{
    await FirebaseFirestore.instance.collection("users").doc(follower).update({
      'following':FieldValue.arrayRemove([following])
    });
    await FirebaseFirestore.instance.collection("users").doc(following).update({
      'followers':FieldValue.arrayRemove([follower])
    });
  }
  Future<void>sendMessage(String content,UserModel sender,UserModel receiver) async{
    sender.dateTime=DateTime.now();
    receiver.dateTime=DateTime.now();
    String id=const Uuid().v1();
    try{
      await FirebaseFirestore.instance.collection("chats").doc(sender.uid).update({
        'friend':receiver.uid,
      });
      await FirebaseFirestore.instance.collection("chats").doc(receiver.uid).update({
        'friend':sender.uid,
      });
    }catch(e)
    {
      await FirebaseFirestore.instance.collection("chats").doc(sender.uid).set({
        'friend':receiver.uid,
      });
      await FirebaseFirestore.instance.collection("chats").doc(receiver.uid).set({
        'friend':sender.uid,
      });
    }
    try{

      await FirebaseFirestore.instance.collection("users").doc(sender.uid).collection("chats").doc(receiver.uid).update(receiver.toJson());
    }catch(e)
    {
      await FirebaseFirestore.instance.collection("users").doc(sender.uid).collection("chats").doc(receiver.uid).set(receiver.toJson());
    }
    try{
      await FirebaseFirestore.instance.collection("users").doc(receiver.uid).collection("chats").doc(sender.uid).update(sender.toJson());
    }catch(e)
    {
      FirebaseFirestore.instance.collection("users").doc(receiver.uid).collection("chats").doc(sender.uid).set(sender.toJson());
    }
    await FirebaseFirestore.instance.collection("chats").doc(sender.uid).collection(receiver.uid).doc(id).set({
      'id':id,
      'content':content,
      'dateTime':DateTime.now(),
      'type':'send',
      'seen':false,
    });
    await FirebaseFirestore.instance.collection("chats").doc(receiver.uid).collection(sender.uid).doc(id).set({
      'id':id,
      'content':content,
      'dateTime':DateTime.now(),
      'type':'receive',
      'seen':false,
    });

  }
  Future<String>deleteChat(String senderId,String receiverId )async{
    String res="success";
    try{
      QuerySnapshot querySnapshot=await FirebaseFirestore.instance.collection("chats").doc(senderId).collection(receiverId).get();
      for (var documentSnapshot in querySnapshot.docs) {
        await documentSnapshot.reference.delete();
      }
      QuerySnapshot querySnapshot2=await FirebaseFirestore.instance.collection("chats").doc(receiverId).collection(senderId).get();
      for(var document in querySnapshot2.docs){
        await document.reference.delete();
      }
      return res;
    }catch(e)
    {
      return "failure";
    }
  }
  Future<void>deleteChatHistory(String senderUid,String receiverUid)async{
    await FirebaseFirestore.instance.collection("users").doc(senderUid).collection("chats").doc(receiverUid).delete();
  }
}