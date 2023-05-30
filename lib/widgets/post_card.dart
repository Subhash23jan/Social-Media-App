

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tab_bar/FIreBase_operations/firebase_store_methods.dart';
import 'package:tab_bar/Models/user_model.dart';
import 'package:tab_bar/screens/comment_screen.dart';
import 'package:tab_bar/widgets/like_animation.dart';

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
  @override
  void initState() {
    super.initState();
    if(mounted) {
      fetchCommentLength();
    }
  }

  fetchCommentLength() async{
    QuerySnapshot snapshot=await  FirebaseFirestore.instance.collection("posts").doc(widget.snap['postId']).collection("comments").get();
    setState(() {
      commentLen=snapshot.docs.length;
    });
  }
  @override
  Widget build(BuildContext context) {
    try{
      List likes=widget.snap['likes'];
      return Container(
        color: Colors.black,
        padding: const EdgeInsets.only(top: 35,left: 5,right: 5),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children:  [
                Row(
                  children:  [
                    const SizedBox(width: 10,),
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(widget.snap['profileUrl']),
                    ),
                    const SizedBox(width: 12,),
                    Expanded(child: InkWell(
                      onTap: (){},
                      child:  Text(widget.snap['name'],style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,

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
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('we are working for this')));
                        } else if (result == 'Option 3') {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('we are working for this',softWrap: true,)));
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        if(widget.user.uid!=widget.snap['uid'])
                        const PopupMenuItem<String>(
                          value: 'Option 2',
                          child: Text('Edit',style: TextStyle(color: Colors.white),),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Option 3',
                          child: Text('Report',style: TextStyle(color: Colors.white),),
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
                    IconButton(onPressed: (){}, icon:likes.contains(widget.user.uid)?const Icon(Icons.favorite,color:Colors.red):const Icon(Icons.favorite_outline_rounded,color: Colors.white,)),
                    IconButton(onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) =>CommentScreen(widget.snap),)),icon: const Icon(FontAwesomeIcons.comment,color: Colors.white,)),
                    IconButton(onPressed: (){}, icon: const Icon(Icons.share,color: Colors.white)),
                    IconButton(onPressed: (){}, icon: const Icon(Icons.bookmark_border,color: Colors.white),padding: const EdgeInsets.only(left: 200),),
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
                      Text(widget.snap['name'],style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold,color: Colors.white),),
                      Text("  ${widget.snap['desc']}",style: GoogleFonts.aBeeZee(fontWeight:FontWeight.bold,color: Colors.white60),),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0,top: 3),
                  child: Text("view $commentLen comments ",style: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.w700,color: Colors.white54),),
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
      return Stack(
        alignment:Alignment.center,
        children:  [
          const Center(child: CircularProgressIndicator(strokeWidth: 4,color: Colors.blue,)),
          Center(child: Text('loading...',style:GoogleFonts.aBeeZee(fontWeight:FontWeight.bold,color: Colors.black))),
        ],
      );
    }
  }
}
