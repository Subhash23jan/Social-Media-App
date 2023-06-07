
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tab_bar/FIreBase_operations/firestore_methods.dart';
import 'package:tab_bar/Models/comment.dart';
import 'package:tab_bar/Models/user_model.dart';
import 'package:tab_bar/providers/user_provider.dart';
import 'package:tab_bar/widgets/comment_card.dart';
import 'package:uuid/uuid.dart';

class CommentScreen extends StatefulWidget {
  final dynamic snap;
  static bool isAdding=false;
  const CommentScreen(this.snap,{super.key});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController commentTextController=TextEditingController();
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentTextController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    UserModel? user=Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text("comments"),
        backgroundColor: Colors.black,
      ),
      body:StreamBuilder(
        stream:FirebaseFirestore.instance.collection("posts").doc(widget.snap['postId']).collection("comments").orderBy('dateTime').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting)
          {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context,index)=> CommentCard(snap: snapshot.data!.docs[index].data()),
          );
        },
      ),
      bottomNavigationBar:  SafeArea(
        child:Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,left: 5),
          child: Row(
            children:  [
               CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(user.profileUrl),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                  child:TextField(
                    style:GoogleFonts.aBeeZee(color: Colors.white),
                    controller: commentTextController,
                    onSubmitted: (value) async {
                      String commentId=const Uuid().v1();
                      await FirestoreMethods().addComments(Comment(user.profileUrl, user.name, value, [], commentId, user.uid, widget.snap['postId'],DateTime.now()));
                      setState(() {
                        CommentScreen.isAdding=false;
                        commentTextController.text="";
                      });
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('comment added')));
                    },
                      decoration:  InputDecoration(
                      border:InputBorder.none,
                      hintStyle: GoogleFonts.aBeeZee(color: Colors.white70),
                      hintText: "add your comments"
                      ),
                      )),
                      TextButton(onPressed: ()  async {
                      setState(() {
                      CommentScreen.isAdding=true;
                      });
                      String commentId=const Uuid().v1();
                      await FirestoreMethods().addComments(Comment(user.profileUrl, user.name, commentTextController.text.toString(), [], commentId, user.uid, widget.snap['postId'],DateTime.now()));
                      setState(() {
                      CommentScreen.isAdding=false;
                      commentTextController.text="";
                      });
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('comment added')));
                      }, child:CommentScreen.isAdding?const CircularProgressIndicator(strokeWidth: 2,):const Text("add",style: TextStyle(fontSize: 18),))
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,

    );
  }
}
