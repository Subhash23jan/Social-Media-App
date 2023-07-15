import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tab_bar/FIreBase_operations/firestore_methods.dart';
import 'package:tab_bar/Models/user_model.dart';
import 'package:tab_bar/pages/chat_screen.dart';
import 'package:tab_bar/pages/image_screen.dart';
import 'package:tab_bar/providers/user_provider.dart';
class MessageScreen extends StatefulWidget {
  final String userId;
  const MessageScreen({Key? key, required this.userId,}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
   late UserModel userModel;
   bool isLongPressed=false;
  @override
  Widget build(BuildContext context) {
    UserModel user=Provider.of<UserProvider>(context).getUser;
    userModel=user;
    return  Scaffold(
      backgroundColor:Colors.white,
      appBar: AppBar(
        backgroundColor:Colors.black,
        toolbarHeight: kToolbarHeight+20,
        elevation: 30,
        leading:Padding(
          padding: const EdgeInsets.only(top: 5,left: 5),
          child: InkWell(
            onTap:()=>Navigator.push(context,
                MaterialPageRoute(builder: (context) => ImageViewScreen(postUrl: user.profileUrl),)),
            child: CircleAvatar(
              radius:20,
              backgroundImage: NetworkImage(user.profileUrl),
            ),
          ),
        ),
        title: Text("Messages",style:GoogleFonts.aBeeZee(fontSize: 18,color: Colors.blue),),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            showContactLists();
          }, icon: const Icon(Icons.add,color: Colors.blue,size: 30,))
        ],
      ),
      body: StreamBuilder(
        stream:FirebaseFirestore.instance.collection("users").doc(user.uid).collection("chats").orderBy('dateTime',descending: true).snapshots(),
        builder: (context, snapshot){
          if(snapshot.connectionState==ConnectionState.waiting || snapshot.hasError || !snapshot.hasData) {
              return Stack(
                alignment:Alignment.center,
                children:  [
                  const Center(child: CircularProgressIndicator(strokeWidth: 4,color: Colors.blue,)),
                  Center(child: Text('uploading...',style:GoogleFonts.aBeeZee(fontWeight:FontWeight.bold,color: Colors.white))),
                ],
              );
            }
          List<UserModel> recentChats = snapshot.data!.docs.map((doc) =>UserModel.fromSnap(doc)).toList();
           return ListView.builder(
            itemCount:recentChats.length,
            scrollDirection:Axis.vertical,
            itemBuilder: (context, index) {
              return InkWell(
                onTap:()=>Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(sender: user, receiver: recentChats[index]),)),
                child: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border:Border.all(color:Colors.black26)
                    ),
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: InkWell(
                                onTap:()=>Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => ImageViewScreen(postUrl: recentChats[index].profileUrl),)),
                                child: CircleAvatar(
                                  radius: 27,
                                  backgroundImage:NetworkImage(recentChats[index].profileUrl),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 25),
                              child: Text(recentChats[index].name,style:GoogleFonts.aBeeZee(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),),
                            ),
                          ],
                        ),
                       InkWell(
                         onTap:(){
                           showDialog(context: context, builder: (context) => AlertDialog(
                             content:const Text("Do you want to clear this chat from database",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),),
                             actions: [
                               TextButton( onPressed:()=> Navigator.pop(context),
                                 child: const Text("No",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 18,),),),
                               TextButton(onPressed:() async {
                                 Navigator.pop(context);
                                 await FirestoreMethods().deleteChatHistory(user.uid, recentChats[index].uid);
                                 if(context.mounted) {
                                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text("history clear agoytu kanla")));
                                 }
                               },  child: const Text("Yes",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 18,),),
                               )
                             ],
                           ),);
                         },
                           child: const Icon(Icons.delete,color: Colors.black,)),

                      ],
                    ),
                  ),
                ),
              );
            },);
        },
      ),
    );
  }

  void showContactLists()async {
    List<UserModel>users=[];
    QuerySnapshot querySnapshot=await FirebaseFirestore.instance.collection("users").get();
    List<DocumentSnapshot> snapshot=querySnapshot.docs;
    for(int i=0;i<snapshot.length;i++)
      {
        UserModel userModel=UserModel.fromSnap(snapshot[i]);
        if(widget.userId!=userModel.uid)
          {
            users.add(userModel);
          }
      }
    if(context.mounted){
      showModalBottomSheet(context: context,
        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height*0.8),
        builder: (context)=>ListView.builder(
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10),
            child: Row(
              mainAxisAlignment:MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage:NetworkImage(users[index].profileUrl),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(users[index].name,style:GoogleFonts.cabin(fontSize: 17,color: Colors.black),),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                      onTap: (){
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>ChatScreen(sender:userModel, receiver: users[index]),));
                      }, child: Text("start chat",style:GoogleFonts.aBeeZee(fontSize: 16,color: Colors.blue,fontWeight: FontWeight.bold),)),
                ),
              ],
            ),
          );
        },
      ),);
    }
  }
}
