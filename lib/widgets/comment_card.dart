
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommentCard extends StatelessWidget {
  final dynamic snap;
   const CommentCard({required this.snap,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List likes=snap['likes'];
    return Container(
      color: Colors.black,
        child:Column(
          children: [
            Row(
              children:  [
                const SizedBox(width: 10,),
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(snap!['commenterPic']),
                ),
                const SizedBox(width: 8,),
                InkWell(
                  onTap: (){},
                  child: Text(snap['commenterName'],style:GoogleFonts.aBeeZee(fontWeight:FontWeight.bold,color: Colors.white)),
                ),
                const SizedBox(width: 6,),
                Expanded(child: InkWell(
                  onTap: (){},
                  child:Text(snap['comment'],style: GoogleFonts.aBeeZee(fontWeight:FontWeight.bold,color: Colors.white60),),
                )),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: (){

                    }, icon:  const Icon(Icons.favorite_outline_rounded,color: Colors.white,)),
                    Text("${likes.length}",style: GoogleFonts.aBeeZee(fontWeight:FontWeight.bold,color: Colors.white60),),
                  ],
                )
              ],
            ),
           
           const SizedBox(height: 13,)
          ],
        )
    );
  }
}
