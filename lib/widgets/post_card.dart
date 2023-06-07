

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tab_bar/FIreBase_operations/firestore_methods.dart';
import 'package:tab_bar/Models/user_model.dart';
import 'package:tab_bar/pages/profile_page.dart';
import 'package:tab_bar/screens/comment_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tab_bar/widgets/like_animation.dart';

import '../pages/image_screen.dart';

class PostCard extends StatefulWidget {
  final dynamic snap;
  final UserModel user;

  const PostCard({Key? key,required this.snap,required this.user}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isAnimating=false;
  int commentLen=0;
  QuerySnapshot? postUploader;
  bool isBookmarked=false;
  @override
  void initState() {
    super.initState();
    if(mounted) {
      fetchCommentLength();
    }
    fetchPostUploaderDetails();
  }
  fetchPostUploaderDetails()async{
     postUploader=await FirebaseFirestore.instance.collection("users").where('uid',isEqualTo:widget.snap['uid']).get();
     QuerySnapshot<Map<String,dynamic>> snapshot= await FirebaseFirestore.instance.collection("users").doc(widget.user.uid).collection("bookmarks").where('id',isEqualTo:widget.snap['postId']).get();
     if(snapshot.docs.isNotEmpty)
       {
         if(mounted){
           setState(() {
             isBookmarked=true;
           });
         }
       }
  }
  fetchCommentLength() async{
    QuerySnapshot snapshot=await  FirebaseFirestore.instance.collection("posts").doc(widget.snap['postId']).collection("comments").get();
    if(mounted)
      {
        setState(() {
          commentLen=snapshot.docs.length;
        });
      }
  }
  @override
  Widget build(BuildContext context) {
    try{
      List likes=widget.snap['likes'];
      return Container(
        color: Colors.black,
        padding: const EdgeInsets.only(top: 25,left: 5,right: 5),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children:  [
                Row(
                  children:  [
                    const SizedBox(width: 10,),
                    InkWell(
                      onTap:()=>Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ImageViewScreen(postUrl:postUploader?.docs[0]['profile_url']),)),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(postUploader?.docs[0]['profile_url']??"https://static.vecteezy.com/system/resources/thumbnails/009/734/564/small/default-avatar-profile-icon-of-social-media-user-vector.jpg"),
                      ),
                    ),
                    const SizedBox(width: 12,),
                    Expanded(child: InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen(uid: postUploader?.docs[0]['uid']),));
                      },
                      child:  Text(postUploader?.docs[0]['name'],style: GoogleFonts.aBeeZee(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,

                      ),),
                    )),
                    PopupMenuButton<String>(
                      color: Colors.black,
                      constraints: const BoxConstraints(
                          maxWidth: 80
                      ),
                      padding: const EdgeInsets.only(left: 5),
                      elevation: 3,
                      icon:const Icon(Icons.more_vert,color: Colors.white,),
                      onSelected: (String result) {
                        if (result == 'Option 1') {
                          showDialog(context: context, builder: (context) {
                            return  AlertDialog(
                              backgroundColor: Colors.black,
                              title: const Text("do you want to delete this post!!",style: TextStyle(color: Colors.white),),
                              alignment: Alignment.center,
                              shape: RoundedRectangleBorder(
                                  borderRadius:BorderRadius.circular(15)
                              ),
                              actions: [
                                TextButton(onPressed: (){
                                  FirestoreMethods().deletePost(widget.snap['postId']);
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('post deleted successfully')));
                                }, child: const Text("Yes",style: TextStyle(color: Colors.white70),),),
                                TextButton(onPressed: (){
                                  Navigator.of(context).pop();
                                }, child: const Text("No",style: TextStyle(color: Colors.white70),),),
                              ],
                            );
                          },);

                        } else if (result == 'Option 2') {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('iro option use madro  🫠')));
                        } else if (result == 'Option 3') {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('enide anta report madtiya!!  😉',softWrap: true,)));
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        widget.user.uid==widget.snap['uid']?const PopupMenuItem<String>(
                          value: 'Option 1',
                          child: Text('Delete',style: TextStyle(color: Colors.white),),
                        ):const PopupMenuItem<String>(
                          value: 'Option 3',
                          child: Text('Report',style: TextStyle(color: Colors.white),),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Option 2',
                          child: Text('More',style: TextStyle(color: Colors.white),),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onDoubleTap:(){
                    FirestoreMethods().updateLike(widget.snap['postId'], widget.user.uid, widget.snap['likes']);
                    setState(() {
                      isAnimating=true;
                    });
                  },
                  onTap:()=>Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ImageViewScreen(postUrl:widget.snap['postUrl']),)),
                  child: Stack(
                    alignment:Alignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.35,
                        width:  MediaQuery.of(context).size.width,
                        child:Image.network(widget.snap['postUrl'],fit: BoxFit.cover,),),
                      AnimatedOpacity(
                          opacity:isAnimating?1:0,
                          duration: const Duration(milliseconds:450),
                          onEnd: (){
                            setState(() {
                              isAnimating=false;
                            });
                          },
                          child:LikeAnimation(
                              isAnimating: isAnimating,
                              duration: const Duration(milliseconds: 300),
                              child:  Icon(Icons.favorite,color:likes.contains(widget.user.uid)?Colors.red:Colors.white,size: 120,)))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children:<Widget>[
                    IconButton(onPressed: (){
                     FirestoreMethods().updateLike(widget.snap['postId'], widget.user.uid, widget.snap['likes']);
                    }, icon:likes.contains(widget.user.uid)?const Icon(Icons.favorite,color:Colors.red):const Icon(Icons.favorite_outline_rounded,color: Colors.white,)),
                    IconButton(onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) =>CommentScreen(widget.snap),)),icon: const Icon(FontAwesomeIcons.commentDots,color: Colors.white,)),
                    IconButton(onPressed: () async{
                     await Share.share(widget.snap['postUrl'],subject:"share using");
                    }, icon: const Icon(Icons.share,color: Colors.white)),
                    isBookmarked?IconButton(onPressed: (){
                      FirestoreMethods().removeBookmarks(widget.user.uid, widget.snap['postId']);
                      setState(() {
                        isBookmarked=false;
                      });
                    },icon: const Icon(Icons.bookmark,color: Colors.white,size: 30,),padding: const EdgeInsets.only(left: 200),):IconButton(onPressed: (){
                      FirestoreMethods().addBookMarks(widget.user.uid, widget.snap['postId']);
                      setState(() {
                        isBookmarked=true;
                      });
                    }, icon: const Icon(Icons.bookmark_border,color: Colors.white,size: 30),padding: const EdgeInsets.only(left: 200),),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0,),
                  child: Text("${widget.snap['likes'].length} likes",style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold,color: Colors.white60),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0,top: 3),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(onTap:()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen(uid: postUploader?.docs[0]['uid']))),child: Text(postUploader?.docs[0]['name'],
                        style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold,color: Colors.white,backgroundColor: Colors.black38),)),
                      Text("  ${widget.snap['desc']}",style: GoogleFonts.aBeeZee(color: Colors.white70),),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0,top: 3),
                  child: InkWell(onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) =>CommentScreen(widget.snap),)),child: Text("view $commentLen comments ",style: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.w700,color: Colors.white54),)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0,top: 3),
                  child: Text(DateFormat.yMMMd().format(widget.snap['dateTime'].toDate()),
                    style: GoogleFonts.jetBrainsMono(color: Colors.white70),),
                ),
                const SizedBox(height: 10,),
              ],
            ),
          ],
        ),
      );
    }catch(e)
    {
      return Container(color: Colors.white,);
    }
  }
}
