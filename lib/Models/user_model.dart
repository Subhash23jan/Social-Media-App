
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
 final String name,email,userId,profileUrl,bio,uid;
 final List<String> followers,following;
  DateTime? dateTime;

 UserModel(
      { required this.name,
        required this.email,
        required this.userId,
        required this.profileUrl,
        required this.bio,
        required  this.uid,
        required this.followers,
        required this.following,
        this.dateTime
      });

  Map<String,dynamic> toJson()=>
      {
        'name':name,
        'email':email,
        'user_id':userId,
        'profile_url':profileUrl,
        'bio':bio,
        'uid':uid,
        'followers':followers,
        'following':following,
        'dateTime':dateTime
      };

  static UserModel fromSnap(DocumentSnapshot snapshot) {
    var  snap=snapshot.data() as Map<String,dynamic>;
    var followers=snap['followers'];
    var following=snap['following'];
    if(snap['dateTime']!=null) {
      var date = snap['dateTime'].toDate();
      return UserModel(
          name: snap['name'],
          email: snap['email'],
          userId: snap['user_id'],
          profileUrl: snap['profile_url'],
          bio: snap['bio'],
          uid: snap['uid'],
          followers: List<String>.from(followers),
          following: List<String>.from(following),
          dateTime: date
      );
    }
      return UserModel(
          name: snap['name'], email: snap['email'],
          userId: snap['user_id'], profileUrl: snap['profile_url'],
          bio: snap['bio'], uid: snap['uid'],
          followers:List<String>.from(followers),
          following: List<String>.from(following),
      );
  }

}