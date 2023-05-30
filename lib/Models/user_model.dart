
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
 final String name,email,userId,profileUrl,bio,uid;
 final List<String> followers,following;

 UserModel(
      { required this.name,
        required this.email,
        required this.userId,
        required this.profileUrl,
        required this.bio,
        required  this.uid,
        required this.followers,
        required this.following
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
        'following':following
      };

  static UserModel fromSnap(DocumentSnapshot snapshot) {
    var  snap=snapshot.data() as Map<String,dynamic>;
    var followers=snap['followers'];
    var following=snap['following'];
    return UserModel(
        name: snap['name'], email: snap['email'],
        userId: snap['user_id'], profileUrl: snap['profile_url'],
        bio: snap['bio'], uid: snap['uid'],
        followers:List<String>.from(followers),
        following: List<String>.from(following),
    );
  }
}