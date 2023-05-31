
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tab_bar/pages/profile_page.dart';

class CommentCard extends StatefulWidget {
  final dynamic snap;
  const CommentCard({required this.snap,Key? key}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  QuerySnapshot? querySnapshot;
  String? profileUrl;
  String? name;
  @override
  void initState() {
    super.initState();
    getComments();
  }
  getComments()async{
    querySnapshot=await FirebaseFirestore.instance.collection("users").where('uid',isEqualTo:widget.snap['commenterUid']).get();
    if(mounted)
      {
        profileUrl=querySnapshot?.docs[0]['profile_url'];
        name=querySnapshot?.docs[0]['name'];
        setState(() {});
      }
  }
  @override
  Widget build(BuildContext context) {
    List likes=widget.snap['likes'];
    return Container(
      color: Colors.black,
        child:Column(
          children: [
            Row(
              children:  [
                const SizedBox(width: 10,),
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(profileUrl??widget.snap['commenterPic']),
                ),
                const SizedBox(width: 8,),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen(uid: widget.snap['commenterUid'])));
                  },
                  child: Text(name??widget.snap['commenterName'],style:GoogleFonts.aBeeZee(fontWeight:FontWeight.bold,color: Colors.white)),
                ),
                const SizedBox(width: 6,),
                Expanded(child: InkWell(
                  onTap: (){},
                  child:Text(widget.snap['comment'],style: GoogleFonts.aBeeZee(fontWeight:FontWeight.bold,color: Colors.white60),),
                )),
                // Row(
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     IconButton(onPressed: (){
                //
                //     }, icon:  const Icon(Icons.favorite_outline_rounded,color: Colors.white,)),
                //     Text("${likes.length}",style: GoogleFonts.aBeeZee(fontWeight:FontWeight.bold,color: Colors.white60),),
                //   ],
                // )
              ],
            ),

           const SizedBox(height: 13,)
          ],
        )
    );
  }
}
