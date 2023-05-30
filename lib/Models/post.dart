class Post {
  final String name, uid, profileUrl, postUrl,postId;
  final String desc;
  final DateTime dateTime;
  final List likes;
  Post({ required this.name,
    required this.uid,
    required this.profileUrl,
    required this.postUrl,
    required this.postId,
    required this.desc,
    required this.dateTime,
    required this.likes
  });

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'uid': uid,
        'profileUrl': profileUrl,
        'postUrl': postUrl,
        'postId': postId,
        'desc': desc,
        'dateTime': dateTime,
        'likes': likes
      };
}