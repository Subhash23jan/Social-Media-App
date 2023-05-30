
class Comment{
  String commenterPic;
  String postId;
  String commenterName;
  String commenterUid;
  String comment;
  String commentId;
  DateTime dateTime;
  List  likes;
  Comment(this.commenterPic, this.commenterName, this.comment, this.likes,this.commentId,this.commenterUid,this.postId,this.dateTime);
}